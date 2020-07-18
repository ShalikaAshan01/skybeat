import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:skybeat/src/models/player_stats.dart';
import 'package:skybeat/src/models/song.dart';

//typedef void TimeChangeHandler(Duration duration);
typedef StreamController CreateStreamController();

class MusicProvider {
  final platform = const MethodChannel('sa.flutter.dev/music');
  final StreamController<Duration> _positionController =
      StreamController<Duration>.broadcast();
  final StreamController<void> _completeController =
      StreamController<void>.broadcast();
  Stream<Duration> get onAudioPositionChanged => _positionController.stream;
  Stream<void> get onComplete => _completeController.stream;

  MusicProvider() {
    platform.setMethodCallHandler(platformCallHandler);
  }

  Future<List<Song>> fetchLocalMusicList() async {
    try {
      final List<dynamic> result =
          await platform.invokeMethod('getAllMusicAsList');
      List<Song> songs = List();
      for (var song in result) {
        songs.add(Song.fromMapObject(song));
      }
      return songs;
    } on PlatformException catch (e) {
      print(e.message);
      return List();
    }
  }

  Future<dynamic> play(Song  song) async {
    try {
      final result = await platform.invokeMethod('play', {"url": song.path});
      return result == 1;
    } on PlatformException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<dynamic> pause() async {
    try {
      final result = await platform.invokeMethod('pause');
      return result == 1;
    } on PlatformException catch (e) {
      print(e.message);
      return false;
    }
  }

  Future<int> currentPosition() async {
    try {
      print("called platform");
      final int res = await platform.invokeMethod('currentPosition');
      print(res.toString());
      return res;
    } on PlatformException catch (e) {
      print(e.message);
      return -1;
    }
  }

  Future<dynamic> seek(Duration duration) async {
    _positionController.add(duration);
    await platform.invokeMethod("seek", {"milliseconds": duration.inMilliseconds});
  }
  VoidCallback completionHandler;
  void setCompletionHandler(VoidCallback callback) {
    completionHandler = callback;
  }
  Future platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "audio.onCurrentPosition":
        _positionController.add(Duration(milliseconds: call.arguments));
        break;
      case "audio.onComplete":
        _completeController.add(null);
        PlayerStats.next();
        PlayerStats.isPlaying = true;
        break;
      case "audio.playNext":
        PlayerStats.next();
        PlayerStats.isPlaying = true;
        break;
      case "audio.playPrevious":
        PlayerStats.previous();
        PlayerStats.isPlaying = true;
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }

  Future<void> dispose() async {
    if(!_completeController.isClosed){
      _completeController.close();
    }
    if(!_positionController.isClosed){
      _positionController.close();
    }
  }
}

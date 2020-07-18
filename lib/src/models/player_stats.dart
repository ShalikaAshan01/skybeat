import 'package:flutter/material.dart';
import 'package:skybeat/src/models/song.dart';
import 'package:skybeat/src/resources/music_provider.dart';
import 'package:skybeat/src/widgets/sb_random_color.dart';

class PlayerStats{

  static int songIndex;
  static bool _isPlaying = false;
  static List<Song> currentPlayList;
  static Song current;
  static Color color;
  static MusicProvider musicProvider = MusicProvider();


  static bool get isPlaying => _isPlaying;

  static void playerSeek(int milli){
    musicProvider.seek(Duration(milliseconds: milli));
  }

  static set isPlaying(bool value) {
    if(value){
      musicProvider.play(current);
    }
    else
      musicProvider.pause();
    _isPlaying = value;
  }

  static Song next(){
    int index = songIndex+1;
    if(index >= currentPlayList.length)
      index = 0;
    songIndex = index;
    current = currentPlayList[index];
    Color color = current.albumArt != null? Colors.transparent:getColor(index);
    PlayerStats.color = color;
    return current;
  }

  static Song previous(){
    int index = songIndex-1;
    if(index < 0)
      index = currentPlayList.length-1;
    songIndex = index;
    current = currentPlayList[index];
    Color color = current.albumArt != null? Colors.transparent:getColor(index);
    PlayerStats.color = color;
    return current;
  }

  static final PlayerStats _playerStats = PlayerStats._internal();

  factory PlayerStats(){
    return _playerStats;
  }
  PlayerStats._internal();
}
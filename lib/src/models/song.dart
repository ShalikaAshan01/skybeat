import 'package:flutter/cupertino.dart';

class Song {
  int songId;
  String name;
  String path;
  String albumName;
  String albumArt;
  int albumId;
  String artistName;
  int duration;
  int year;
  String track;
  String dateAdded;
  String dateModified;
  String size;
  String title;

  Song(
      {this.songId,
      @required this.name,
      @required this.path,
      this.albumName,
      this.albumArt,
      this.albumId,
      this.artistName,
      this.duration,
      this.year,
      this.track,
      this.dateAdded,
      this.dateModified,
      this.size,
      this.title});

  Song.fromMapObject(Map<dynamic, dynamic> map) {
    this.songId = map["songId"];
    this.name = map["name"];
    this.path = map["path"];
    this.title = map["title"];
    this.albumName = map["albumName"];
    this.albumArt = map["albumArt"];
    this.albumId = map["albumId"];
    this.artistName = map["artistName"];
    this.duration = map["duration"];
    this.year = map["year"];
    this.track = map["track"];
    this.dateAdded = map["dateAdded"];
    this.dateModified = map["dateModified"];
    this.size = map["size"];
  }

   Map<String,dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map["songId"] = this.songId;
    map["name"] = this.name;
    map["path"] = this.path;
    map["title"] = this.title;
    map["albumName"] = this.albumName;
    map["albumArt"] = this.albumArt;
    map["albumId"] = this.albumId;
    map["artistName"] = this.artistName;
    map["duration"] = this.duration;
    map["year"] = this.year;
    map["track"] = this.track;
    map["dateAdded"] = this.dateAdded;
    map["dateModified"] = this.dateModified;
    map["size"] = this.size;
    return map;
  }
}

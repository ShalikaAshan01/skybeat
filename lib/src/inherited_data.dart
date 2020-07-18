import 'package:flutter/cupertino.dart';
import 'package:skybeat/src/models/player_stats.dart';

import 'models/song.dart';

class MyInheritedWidget extends StatefulWidget{
  final Widget child;

  const MyInheritedWidget({Key key,@required this.child, }) : super(key: key);

  static MyInheritedData of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType();

  @override
  State<StatefulWidget> createState() => _MyInheritedWidget();

}

class _MyInheritedWidget extends State<MyInheritedWidget>{
  List<Song> songList;
  PlayerStats playerStats;
  @override
  void initState() {
    super.initState();
    songList = List();
  }

  void onSongListChange(List<Song> list){
    setState(() {
      songList = list;
    });
  }

  void onChangePlayerStats(PlayerStats playerStats){
    setState(() {
      playerStats = playerStats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MyInheritedData(
      child: widget.child,
      songList: songList,
      onSongListChange: onSongListChange,
    );
  }
}


class MyInheritedData extends InheritedWidget{
  final List<Song> songList;

  final ValueChanged<List<Song>> onSongListChange;

  MyInheritedData({this.songList, this.onSongListChange,@required Widget child, Key key}):super(key:key, child: child);



  @override
  bool updateShouldNotify(MyInheritedData oldWidget) {
//    bool _currentSong = oldWidget.currentSong != currentSong || oldWidget.onCurrentSongChange != onCurrentSongChange;
//    bool _songList = oldWidget.songList != songList || oldWidget.onSongListChange != onSongListChange;
//    return _currentSong || _songList;
  return true;
  }

}
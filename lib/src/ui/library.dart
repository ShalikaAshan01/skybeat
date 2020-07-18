import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skybeat/src/inherited_data.dart';
import 'package:skybeat/src/models/player_stats.dart';
import 'package:skybeat/src/models/song.dart';
import 'package:skybeat/src/resources/music_provider.dart';
import 'package:skybeat/src/widgets/marquee_widget.dart';
import 'package:skybeat/src/widgets/sb_image.dart';
import 'package:skybeat/src/widgets/sb_listviewItem.dart';
import 'package:skybeat/src/widgets/sb_random_color.dart';
import 'package:skybeat/src/widgets/seek_bar.dart';

import 'now_playing.dart';

class Library extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  Song _song;
  bool _playing = false;

  @override
  void initState() {
    super.initState();
    _getSongs();
    PlayerStats.musicProvider.onComplete.listen((event) {
      setState(() {
        _song = PlayerStats.current;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {
      _song = PlayerStats.current;
      _playing = PlayerStats.isPlaying;
    });
    Size size = MediaQuery.of(context).size;
    Color _bgColor = Theme.of(context).backgroundColor;
    double availableHeight = size.height - 235;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: Column(
          children: <Widget>[
            Container(
              height: 60,
              child: Row(
                children: <Widget>[
                  SizedBox(width: 15,),
                  Expanded(
                    child: RaisedButton.icon(
                        onPressed: () {
                          PlayerStats.current = PlayerStats.currentPlayList[0];
                          PlayerStats.songIndex = 0;
                          Color color = PlayerStats.current.albumArt != null
                              ? Colors.transparent
                              : getColor(0);
                          PlayerStats.color = color;
                          setState(() {
                            _song = PlayerStats.current;
                            _playing = true;
                          });
                          PlayerStats.isPlaying = true;
                        },
                        icon: Icon(Icons.play_arrow),
                        label: Text("Play all")),
                  ),
                  SizedBox(width: 35,),
                  Expanded(
                    child: RaisedButton.icon(
                        onPressed: () {
                          PlayerStats.currentPlayList.shuffle();
                          PlayerStats.current = PlayerStats.currentPlayList[0];
                          PlayerStats.songIndex = 0;
                          Color color = PlayerStats.current.albumArt != null
                              ? Colors.transparent
                              : getColor(0);
                          PlayerStats.color = color;
                          setState(() {
                            _song = PlayerStats.current;
                            _playing = true;
                          });
                          PlayerStats.isPlaying = true;
                        },
                        icon: Icon(Icons.shuffle),
                        label: Text("Shuffle all")),
                  ),
                  SizedBox(width: 15,),
                ],
              ),
            ),
            Container(
                height: availableHeight,
                child: _builder()),
            Container(
              height: 40,
              child: _song != null ? _nowPlaying(_bgColor, size) : Container(
                child: Text("No songs selected"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nowPlaying(Color _bgColor, Size size) {
    double imgSize = size.height * 0.05;
    double other = size.width - imgSize - 10;
    String text = "${_song.title}  ⚫  ${_song.artistName}";
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => NowPlaying()));
      },
      onDoubleTap: () => _play(),
      onHorizontalDragUpdate: (details) {
        if (details.delta.dx >= 0)
          _playPrev();
        else
          _playNext();
      },
      onVerticalDragUpdate: (details) {
        if (details.delta.dy < 0)
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => NowPlaying()));
      },
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(color: _bgColor),
        child: Column(
          children: <Widget>[
            _mySeekBarSteamBuilder(),
            Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.fromLTRB(5, 5, 0, 0),
                  width: imgSize,
                  height: imgSize,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: getColor(PlayerStats.songIndex),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: SbImage(
                          uri: _song.albumArt,
                        )),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Container(
                  padding: EdgeInsets.only(top: 5),
                  width: other * 0.5,
                  alignment: Alignment.center,
                  height: imgSize,
                  child: MarqueeWidget(
                    direction: Axis.horizontal,
                    child: Text(text),
                  ),
                ),
                Container(
                  width: other * 0.5,
                  height: imgSize,
                  child: Row(
                    children: <Widget>[
                      Spacer(),
                      Expanded(
                          child: IconButton(
                            icon: Icon(Icons.skip_previous),
                            onPressed: () => _playPrev(),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          )),
                      Expanded(
                          child: IconButton(
                            icon: Icon(_playing ? Icons.pause : Icons
                                .play_arrow),
                            onPressed: () => _play(),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          )),
                      Expanded(
                          child: IconButton(
                            icon: Icon(Icons.skip_next),
                            onPressed: () => _playNext(),
                            splashColor: Colors.transparent,
                            highlightColor: Colors.transparent,
                          )),
                      SizedBox(
                        width: 8,
                      )
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  void _playNext() {
    Song song = PlayerStats.next();
    PlayerStats.isPlaying = true;
    setState(() {
      setState(() {
        _song = song;
      });
    });
  }

  void _play() {
    PlayerStats.isPlaying = !PlayerStats.isPlaying;
    setState(() {
      _playing = !_playing;
    });
  }

  void _playPrev() {
    Song song = PlayerStats.previous();
    PlayerStats.isPlaying = true;
    setState(() {
      setState(() {
        _song = song;
      });
    });
  }

  Widget _mySeekBarSteamBuilder() {
    return StreamBuilder(
        stream: PlayerStats.musicProvider.onAudioPositionChanged,
        builder: (context, AsyncSnapshot<Duration> snapshot) {
          if (snapshot.hasData) return _mySeekBar(snapshot.data.inMilliseconds);
          return _mySeekBar(0);
        });
  }

  Widget _mySeekBar(int milli) {
    double seekBarVal = 1 / _song.duration * milli;
    Color color = getColor(PlayerStats.songIndex);
    return SeekBar(
      thumbColor: Colors.transparent,
      progressColor: color,
      secondProgressColor: color,
      barColor: color.withOpacity(0.27),
      progressWidth: 3,
      value: seekBarVal,
      secondValue: 0.0,
      thumbRadius: 0.0,
    );
  }

  Widget _builder() {
    List<Song> songList = MyInheritedWidget.of(context).songList;
    if (songList != null) {
      if (PlayerStats.current == null && songList.length > 0) {
        PlayerStats.current = songList[0];
        PlayerStats.songIndex = 0;
      }
      return ListView.builder(
          itemCount: songList.length,
          itemBuilder: (context, index) {
            return SbListView(
                onTap: () {
                  PlayerStats.current = songList[index];
                  PlayerStats.songIndex = index;
                  Color color = PlayerStats.current.albumArt != null
                      ? Colors.transparent
                      : getColor(index);
                  PlayerStats.color = color;
                  setState(() {
                    _song = PlayerStats.current;
                    _playing = true;
                  });
                  PlayerStats.isPlaying = true;
                },
                song: songList[index],
                index: index,
                active: false,
                color: getColor(index));
          });
    }
    return Center(
      child: Text("Loading... "),
    );
  }

  Future<void> _getSongs() async {
    final List<Song> list = await MusicProvider().fetchLocalMusicList();
    MyInheritedWidget.of(context).onSongListChange(list);
    PlayerStats.currentPlayList = list;
  }
}

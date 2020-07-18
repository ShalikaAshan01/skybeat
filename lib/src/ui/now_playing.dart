import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skybeat/src/models/player_stats.dart';
import 'package:skybeat/src/models/song.dart';
import 'package:skybeat/src/widgets/sb_image.dart';
import 'package:skybeat/src/widgets/seek_bar.dart';

class NowPlaying extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NowPlaying();
}

class _NowPlaying extends State<NowPlaying> {

  ThemeData _theme;
  bool _playing;
  String _length;

  @override
  void initState() {
    super.initState();
    PlayerStats.isPlaying = true;
    _playing = true;

  PlayerStats.musicProvider.onComplete.listen((event){
    if(mounted)
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>NowPlaying()));
  });
  }
  @override
  Widget build(BuildContext context) {
    setState(() {
      _theme = Theme.of(context);
    });

    return Scaffold(
      backgroundColor: _theme.backgroundColor,
      body: Container(
        padding: EdgeInsets.only(left: 8.0, right: 8.0),
        child: PlayerStats.current.albumArt == null
            ? _body()
            : _bodyWithBlurImage(),
      ),
    );
  }

  Widget _bodyWithBlurImage() {
    File file = File.fromUri(Uri.parse(PlayerStats.current.albumArt));
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
        image: DecorationImage(image: FileImage(file), fit: BoxFit.cover),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: _body(),
        ),
      ),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Spacer(),
        Center(
          child: GestureDetector(
            onDoubleTap: ()=>_play(),
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx >= 0)
                changePage(PlayerStats.previous(), context);
              else
                changePage(PlayerStats.next(), context);
            },
            onVerticalDragUpdate: (details) {
              if (details.delta.dy > 0) Navigator.pop(context);
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 500),
              padding: EdgeInsets.all(_playing ? 10 : 60),
              width: 350,
              height: 350,
              child: Container(
                child: Hero(
                    tag: "${PlayerStats.current.albumId}${PlayerStats.current
                        .name}",
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: SbImage(
                          uri: PlayerStats.current.albumArt,
                          iconSize: 60,
                        ))),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: PlayerStats.color,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.transparent.withOpacity(0.4),
                          blurRadius: 10,
                          offset: Offset(2, 2))
                    ]),
              ),
            ),
          ),
        ),
        Hero(
            tag: PlayerStats.current.songId,
            child: Container(
                margin: EdgeInsets.only(top: 10),
                child: Text(
                  PlayerStats.current.title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .title,
                  textAlign: TextAlign.center,
                ))),
        Container(
          margin: EdgeInsets.only(top: 5),
          child: Text(
            PlayerStats.current.artistName.replaceAll("<", "").replaceAll(
                ">", ""),
            style: Theme
                .of(context)
                .textTheme
                .subtitle
                .copyWith(color: Colors.white54),
          ),
        ),
        Spacer(),
        _bottom()
      ],
    );
  }

  Widget _bottom(){
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(top: 35),
            width: 300,
            child: Row(
              children: <Widget>[
                //TODO:Implement
                Expanded(child: Icon(Icons.volume_mute)),
                Expanded(child: Icon(Icons.shuffle)),
                Expanded(child: Icon(Icons.repeat)),
                Expanded(child: Icon(Icons.favorite)),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15),
            child: StreamBuilder(
              stream: PlayerStats.musicProvider.onAudioPositionChanged,
              builder: (context, AsyncSnapshot<Duration> snapshot) {
                if (snapshot.hasData) {
                  return mySeekBar(current: snapshot.data,duration: PlayerStats.current.duration);
                }
                return mySeekBar(current: Duration(seconds: 0),duration: PlayerStats.current.duration);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.only(top: 15, bottom: 21),
            child: Row(
              children: <Widget>[
                Spacer(),
                PreviousButton(),
                playButton(),
                NextButton(),
                Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget mySeekBar({Duration current,int duration}) {
    double seekBarVal = 1 / duration * current.inMilliseconds;

    Duration songDuration = Duration(milliseconds: duration);

    int songDurationMinutes = songDuration.inMinutes;
    int songDurationSeconds = songDuration.inSeconds - songDurationMinutes * 60;
    String songDurationSecondsInString = songDurationSeconds > 9? songDurationSeconds.toString():
    "0$songDurationSeconds";

    int currentDurationMinutes = current.inMinutes;
    int currentDurationSeconds = current.inSeconds - currentDurationMinutes * 60;
    String currentDurationSecondsInString = currentDurationSeconds > 9? currentDurationSeconds.toString():
        "0$currentDurationSeconds";

    _length = "$currentDurationMinutes:$currentDurationSecondsInString";

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Container(
            child: SeekBar(
              thumbColor: _theme.buttonColor,
              progressColor: _theme.buttonColor,
              secondProgressColor: _theme.backgroundColor.withOpacity(0.8),
              barColor: _theme.backgroundColor,
              progressWidth: 3,
              value: seekBarVal,
              secondValue: 0.0,
              thumbRadius: 10,
              onProgressChanged: (double val){
                int milli = (val * duration).round();
                Duration _current = Duration(milliseconds: milli);
                int _currentDurationMinutes = _current.inMinutes;
                int _currentDurationSeconds = _current.inSeconds - _currentDurationMinutes * 60;
                String _currentDurationSecondsInString = _currentDurationSeconds > 9? _currentDurationSeconds.toString():
                "0$_currentDurationSeconds";
                if(mounted)
                  setState(() {
                    _length = "$_currentDurationMinutes:$_currentDurationSecondsInString";
                  });
                PlayerStats.playerSeek(milli);
                if(!_playing && milli >= duration )
                  changePage(PlayerStats.next(), context);
              },
            ),
          ),
          Row(
            children: <Widget>[
              Container(child: Text(_length),),
              Spacer(),
              Container(child: Text("$songDurationMinutes:$songDurationSecondsInString"),),
            ],
          )
        ],
      ),
    );
  }
  void _play(){
    setState(() {
      _playing = !_playing;
    });
    PlayerStats.isPlaying = _playing;
  }

  Widget playButton() {
    return Expanded(
      child: IconButton(
        onPressed: () => _play(),
        iconSize: 45,
        icon: Icon(
          !_playing ? Icons.play_arrow : Icons.pause,
        ),
      ),
    );
  }
}

void changePage(Song song, BuildContext context) {
  Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => NowPlaying(),
      ));
}

class NextButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        onPressed: () => changePage(PlayerStats.next(), context),
        iconSize: 45,
        icon: Icon(
          Icons.skip_next,
          size: 45,
        ),
      ),
    );
  }
}

class PreviousButton extends StatelessWidget {
  const PreviousButton({Key key,}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconButton(
        onPressed: () => changePage(PlayerStats.previous(), context),
        iconSize: 45,
        icon: Icon(
          Icons.skip_previous,
          size: 45,
        ),
      ),
    );
  }
}
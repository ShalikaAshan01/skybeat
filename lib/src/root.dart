import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skybeat/src/ui/library.dart';

class Root extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _RootState();
}

class _RootState extends State<Root> {
  int _page = 0;
  GlobalKey _bottomNavigationKey = GlobalKey();

  final List<Widget> _pages = [
    Library(),
    Library(),
    Library(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Skybeats"),
        ),
        bottomNavigationBar: CurvedNavigationBar(
          key: _bottomNavigationKey,
          items: <Widget>[
            Icon(
              Icons.music_note,
              size: 30,
              color: Theme.of(context).backgroundColor,
            ),
            Icon(
              Icons.queue_music,
              size: 30,
              color: Theme.of(context).backgroundColor,
            ),
            Icon(
              Icons.album,
              size: 30,
              color: Theme.of(context).backgroundColor,
            ),
          ],
          backgroundColor: Colors.black87,
          height: 55,
          color: Colors.white,
          onTap: (index) {
            setState(() {
              _page = index;
            });
          },
        ),
        body: _pages[_page]);
  }
}

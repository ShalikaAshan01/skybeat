import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skybeat/src/inherited_data.dart';
import 'package:skybeat/src/models/song.dart';
import 'package:skybeat/src/widgets/sb_image.dart';

class SbListView extends StatefulWidget {
  final bool active;
  final Color color;
  final int index;
  final onTap;
  final Song song;

  const SbListView(
      {Key key, this.active, this.color, this.index, @required this.onTap, this.song})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _SbListViewState();
}

class _SbListViewState extends State<SbListView> {
  bool _isDrag = false;

  @override
  Widget build(BuildContext context) {
    Color _color = widget.song.albumArt != null ? Colors.transparent : widget
        .color;
    return GestureDetector(
      onTap: () => widget.onTap(),
      onHorizontalDragStart: (val) {
        setState(() {
          _isDrag = true;
        });
      },
      child: Container(
        margin: EdgeInsets.all(12),
        child: Row(
          children: <Widget>[
            Container(
              width: 45,
              height: 45,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Hero(
                    tag: "${widget.song.albumId}${widget.song.name}",
                    child: SbImage(
                      uri: widget.song.albumArt,
                    ),
                  )),
              decoration: BoxDecoration(
                  color: _color,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.transparent.withOpacity(0.4),
                        blurRadius: 10,
                        offset: Offset(2, 2))
                  ]
              ),
            ),
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                height: 45,
                margin: EdgeInsets.only(left: 15),
                child: Hero(
                  tag: widget.song.songId.toString(),
                  child: Text(
                    widget.song.title,
                  ),
                ),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                            color: Colors.transparent.withOpacity(0.1)))),
              ),
            ),
            _isDrag ? Container(child: IconButton(
              icon: Icon(Icons.delete_forever),
              color: Colors.redAccent,
              onPressed: () {
                setState(() {
                  _isDrag = false;
                });
                List<Song> _list = MyInheritedWidget
                    .of(context)
                    .songList;
                _list.removeAt(widget.index);
                MyInheritedWidget.of(context).onSongListChange(_list);
              },
            ),
            ) : Container(),
            _isDrag ? Container(child: IconButton(
              icon: Icon(Icons.cancel),
              onPressed: () {
                setState(() {
                  _isDrag = false;
                });
              },
            ),
            ) : Container(),
          ],
        ),
      ),
    );
  }
}
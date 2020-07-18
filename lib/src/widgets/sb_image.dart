import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SbImage extends StatelessWidget {
  final String uri;
  final double iconSize;

  const SbImage({Key key, this.uri, this.iconSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: uri != null ? _albumArt() : _placeholder(),
    );
  }

  Widget _placeholder() {
    return Icon(Icons.audiotrack,size: iconSize,);
  }

  Widget _albumArt() {
    File file = File.fromUri(Uri.parse(uri));
    return Image.file(
      file,
      fit: BoxFit.fill,
    );
  }
}

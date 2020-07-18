import 'package:flutter/material.dart';

List _colors = [
  Color(0xFFff1744),
  Color(0xFFd500f9),
  Color(0xFF651fff),
  Color(0xFFc6ff00),
  Color(0xFF1de9b6),
  Color(0xFFf50057),
  Color(0xFF00b0ff),
  Color(0xFFffc400),
  Color(0xFF00e676),
  Color(0xFF2979ff),
  Color(0xFF76ff03),
  Color(0xFF3d5afe),
  Color(0xFFff9100),
  Color(0xFF00e5ff),
  Color(0xFFffea00),
  Color(0xFFff3d00)
];

Color getColor(int index) {
  return _colors[index % _colors.length];
}

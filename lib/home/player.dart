import 'dart:io';
import 'package:cisum/home/player_dark.dart';
import 'package:cisum/home/player_white.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Player extends StatefulWidget {
  final Color bgColor;
  Player({this.bgColor});
  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> {
  PageController controller;

  @override
  void initState() {
    super.initState();
    if(widget.bgColor == Color(0xFFEAEBF3)){
      controller = PageController(initialPage: 2);
    } else {
      controller = PageController();
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    return PageView(
      controller: controller,
      physics: NeverScrollableScrollPhysics(),
      children: <Widget>[
        PlayerDark(controller: controller,),
        PlayerWhite(controller: controller,),
      ],
    );
  }
}







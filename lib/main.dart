import 'dart:ui' as ui;

import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:trex/game/game.dart';

void main() async {
  Flame.audio.disableLog();

  runApp(Title(
    title: 'TRexGame',
    color: Colors.white,
    child: Container(
      decoration: BoxDecoration( color: Colors.white),
      child: TRexGameWrapper(),
    ),
  ));

  SystemChrome.setEnabledSystemUIOverlays([]);
}


class TRexGameWrapper extends StatefulWidget {

  @override
  _TRexGameWrapperState createState() => _TRexGameWrapperState();
}

class _TRexGameWrapperState extends State<TRexGameWrapper> {

  List<ui.Image> image;
  TRexGame game;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() async {
    image = await Flame.images.loadAll(["sprite.png"]);
    game = TRexGame(spriteImage: image[0]);
    setState(() {});
    Flame.util.addGestureRecognizer(TapGestureRecognizer()
      ..onTapDown = (TapDownDetails evt) => game.onTap());
  }

  @override
  Widget build(BuildContext context) {
    if(image == null || game == null) {
      return Container();
    }
    return game.widget;
  }
}
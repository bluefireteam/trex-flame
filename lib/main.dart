import 'dart:ui' as ui;

import 'package:flame/flame.dart';
import 'package:flutter/material.dart';
import 'package:trex/game/Game.dart';

void main() async {
  Flame.audio.disableLog();
  List<ui.Image> image = await Flame.images.loadAll(["sprite.png"]);

  runApp(MaterialApp(
    title: 'TRexGame',
    home: Scaffold(
      body: GameWrapper(TRexGame(spriteImage: image[0])),
    ),
  ));
}


class GameWrapper extends StatelessWidget{
  final TRexGame tRexGame;
  GameWrapper(this.tRexGame);


  @override
  Widget build(BuildContext context) {
    return tRexGame.widget;
  }
}


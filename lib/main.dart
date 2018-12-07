import 'dart:ui' as ui;

import 'package:flame/flame.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trex/game/game.dart';

void main() async {
  Flame.audio.disableLog();
  List<ui.Image> image = await Flame.images.loadAll(["sprite.png"]);
  TRexGame tRexGame = TRexGame(spriteImage: image[0]);
  runApp(MaterialApp(
    title: 'TRexGame',
    home: Scaffold(
      body: GameWrapper(tRexGame),
    ),
  ));

  Flame.util.addGestureRecognizer(new TapGestureRecognizer()
    ..onTapDown = (TapDownDetails evt) => tRexGame.onTap());

  SystemChrome.setEnabledSystemUIOverlays([]);
}

class GameWrapper extends StatelessWidget {
  final TRexGame tRexGame;
  GameWrapper(this.tRexGame);

  @override
  Widget build(BuildContext context) {
    return tRexGame.widget;
  }
}

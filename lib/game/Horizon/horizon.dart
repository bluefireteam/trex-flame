import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';

class Horizon extends SpriteComponent with Resizable {
  Horizon(Image spriteImage): super.fromSprite(2400.0, 24.0, Sprite.fromImage(spriteImage,
    width: 2400.0,
    height: 24.0,
    y: 104.0,
    x: 2.0,
  ));

  @override
  void update(double t) {
    if(size == null) return;
    y = (size.height / 2) + 21.0;
    super.update(t);
  }
}
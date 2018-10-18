import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/game.dart';
import 'package:flame/sprite.dart';


class TRexGame extends BaseGame{

  Dino dino;
  Ground ground;

  TRexGame({
    Image spriteImage
  }) {
    dino = Dino(spriteImage);
    ground = Ground(spriteImage);

    this..add(dino)
        ..add(ground);
  }

  @override
  void update(double t) {
    dino.update(t);
    ground.update(t);
    // TODO: implement update
  }

}


class Dino extends PositionComponent with Resizable {
  bool isIdle = true;

  IdleDino idleDino;
  RunningDino runningDino;


  Dino(Image spriteImage) :
      runningDino = RunningDino(spriteImage),
      idleDino = IdleDino(spriteImage),
      super();


  @override
  void render(Canvas canvas) {
    runningDino.render(canvas);
  }

  @override
  void update(double t) {
    if(size == null) return;
    y = (size.height / 2) - 45.0;
    runningDino.update(t, y);
  }


}

class RunningDino extends AnimationComponent {
  RunningDino(Image spriteImage) : super(88.0, 90.0, Animation.spriteList([
    Sprite.fromImage(spriteImage,
      width: 88.0,
      height: 90.0,
      y: 6.0,
      x: 1514.0,
    ),
    Sprite.fromImage(spriteImage,
      width: 88.0,
      height: 90.0,
      y: 6.0,
      x: 1602.0,
    ),
  ], stepTime: 0.2, loop: true));

  @override
  void update(double t, [double newY]) {
    y = newY;
    super.update(t);
  }
}

class IdleDino extends SpriteComponent {
  IdleDino(Image spriteImage): super.fromSprite(88.0, 90.0, Sprite.fromImage(spriteImage,
    width: 88.0,
    height: 90.0,
    x: 76.0,
    y: 6.0
  ));
}

class Ground extends SpriteComponent with Resizable {
  Ground(Image spriteImage): super.fromSprite(2400.0, 24.0, Sprite.fromImage(spriteImage,
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
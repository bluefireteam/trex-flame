import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';
import 'package:trex/game/t_rex/config.dart';

enum TRexStatus { crashed, ducking, jumping, running, waiting }

class TRex extends PositionComponent with Resizable {
  bool isIdle = true;

  TRexStatus status = TRexStatus.waiting;

  WaitingTRex idleDino;
  RunningTRex runningDino;

  TRex(Image spriteImage) :
        runningDino = RunningTRex(spriteImage),
        idleDino = WaitingTRex(spriteImage),
        super();


  TRexRepresentation get chosenDino {
    switch(status){
      case TRexStatus.waiting:
        return idleDino;
      case TRexStatus.running:
      default:
        return runningDino;
    }
  }

  void startPlaying (bool playing){
    status = playing ? TRexStatus.running : TRexStatus.waiting;
  }

  @override
  void render(Canvas canvas) {
    this.chosenDino.render(canvas);
  }


  void update(double t) {
    if(size == null) return;
    y = (size.height / 2) - TRexConfig.height / 2;
    this.chosenDino.update(t, y);
  }
}


class RunningTRex extends AnimationComponent with TRexRepresentation{
  RunningTRex(Image spriteImage) : super(88.0, 90.0, Animation.spriteList([
    Sprite.fromImage(spriteImage,
      width: TRexConfig.width,
      height: TRexConfig.height,
      y: 4.0,
      x: 1514.0,
    ),
    Sprite.fromImage(spriteImage,
      width: TRexConfig.width,
      height: TRexConfig.height,
      y: 4.0,
      x: 1602.0,
    ),
  ], stepTime: 0.2, loop: true));

}

class WaitingTRex extends SpriteComponent with TRexRepresentation {
  WaitingTRex(Image spriteImage): super.fromSprite(88.0, 90.0, Sprite.fromImage(spriteImage,
      width: TRexConfig.width,
      height: TRexConfig.height,
      x: 76.0,
      y: 6.0
  ));
}

abstract class TRexRepresentation extends PositionComponent{
  double y = 0.0;

  void update(double t, [double newY]) {
    y = newY;
    super.update(t);
  }
}

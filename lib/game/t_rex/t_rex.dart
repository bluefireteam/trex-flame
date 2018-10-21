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

  double jumpVelocity = 0.0;
  bool reachedMinHeight = false;
  int jumpCount = 0;

  TRex(Image spriteImage) :
        runningDino = RunningTRex(spriteImage),
        idleDino = WaitingTRex(spriteImage),
        super();


  TRexRepresentation get actualDino {
    switch(status){
      case TRexStatus.waiting:
        return idleDino;
      case TRexStatus.running:
      default:
        return runningDino;
    }
  }

  void startJump (double speed){
    if(status == TRexStatus.jumping || status == TRexStatus.ducking) return;

    status = TRexStatus.jumping;
    this.jumpVelocity = TRexConfig.initialJumpVelocity - (speed / 10);
    this.reachedMinHeight = false;

  }

  @override
  void render(Canvas canvas) {
    this.actualDino.render(canvas);
  }

  void reset() {
    y = groundYPos;
    jumpVelocity = 0.0;
    jumpCount = 0;
  }

  void update(double t) {
    if (status == TRexStatus.jumping){
      y += (jumpVelocity);
      this.jumpVelocity += TRexConfig.gravity;
      if (this.y > this.groundYPos) {
        this.reset();
        this.jumpCount++;
        this.status = TRexStatus.running;
      }
    } else {
      y = this.groundYPos;
    }
    updateY(t);
  }
  void updateY(double t){
    this.actualDino.update(t, y);
  }

  double get groundYPos {
    if(size == null) return 0.0;
    return (size.height / 2) - TRexConfig.height / 2;
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

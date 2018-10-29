import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';
import 'package:trex/game/collision/collision_box.dart';
import 'package:trex/game/t_rex/config.dart';

enum TRexStatus { crashed, ducking, jumping, running, waiting, intro }

class TRex extends PositionComponent with Resizable {
  bool isIdle = true;

  TRexStatus status = TRexStatus.waiting;

  WaitingTRex idleDino;
  RunningTRex runningDino;
  JumpingTRex jumpingTRex;

  double jumpVelocity = 0.0;
  bool reachedMinHeight = false;
  int jumpCount = 0;
  bool hasPlayedIntro = false;

  TRex(Image spriteImage) :
        runningDino = RunningTRex(spriteImage),
        idleDino = WaitingTRex(spriteImage),
        jumpingTRex = JumpingTRex(spriteImage),
        super();


  PositionComponent get actualDino {
    switch(status){
      case TRexStatus.waiting:
        return idleDino;
      case TRexStatus.jumping:
        return jumpingTRex;
      case TRexStatus.intro:
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

    // intro related
    if(jumpCount == 1 && !playingIntro && !hasPlayedIntro){
      status = TRexStatus.intro;
    }
    if (playingIntro && x < TRexConfig.startXPos) {
      x += ((TRexConfig.startXPos / TRexConfig.introDuration) * t * 5000);
    }


    updateCoordinates(t);
  }
  void updateCoordinates(double t){
    this.actualDino.x = x;
    this.actualDino.y = y;
    this.actualDino.update(t);
  }

  double get groundYPos {
    if(size == null) return 0.0;
    return (size.height / 2) - TRexConfig.height / 2;
  }
  bool get playingIntro => status == TRexStatus.intro;

  bool get ducking => status == TRexStatus.ducking;
}


class RunningTRex extends AnimationComponent {
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

class WaitingTRex extends SpriteComponent  {
  WaitingTRex(Image spriteImage): super.fromSprite(TRexConfig.width, TRexConfig.height, Sprite.fromImage(spriteImage,
      width: TRexConfig.width,
      height: TRexConfig.height,
      x: 76.0,
      y: 6.0
  ));
}

class JumpingTRex extends SpriteComponent {
  JumpingTRex(Image spriteImage):super.fromSprite(TRexConfig.width, TRexConfig.height, Sprite.fromImage(spriteImage,
      width: TRexConfig.width,
      height: TRexConfig.height,
      x: 1339.0,
      y: 6.0
  ));
}

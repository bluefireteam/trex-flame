import 'dart:ui';

import 'package:flame/animation.dart';
import 'package:flame/components/animation_component.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/sprite.dart';
import 'package:trex/game/t_rex/config.dart';

enum TRexStatus { crashed, ducking, jumping, running, waiting, intro }

class TRex extends PositionComponent with Resizable {
  TRex(Image spriteImage)
      : runningDino = RunningTRex(spriteImage),
        idleDino = WaitingTRex(spriteImage),
        jumpingTRex = JumpingTRex(spriteImage),
        surprisedTRex = SurprisedTRex(spriteImage),
        super();

  bool isIdle = true;

  TRexStatus _status = TRexStatus.waiting;

  TRexStatus get status => _status;
  void set status(TRexStatus status) {
    _status = status;
    actualDino.x = x;
    actualDino.y = y;
  }

  WaitingTRex idleDino;
  RunningTRex runningDino;
  JumpingTRex jumpingTRex;
  SurprisedTRex surprisedTRex;

  double jumpVelocity = 0.0;
  bool reachedMinHeight = false;
  int jumpCount = 0;
  bool hasPlayedIntro = false;

  PositionComponent get actualDino {
    switch (status) {
      case TRexStatus.waiting:
        return idleDino;
      case TRexStatus.jumping:
        return jumpingTRex;

      case TRexStatus.crashed:
        return surprisedTRex;
      case TRexStatus.intro:
      case TRexStatus.running:
      default:
        return runningDino;
    }
  }

  void startJump(double speed) {
    if (status == TRexStatus.jumping || status == TRexStatus.ducking) {
      return;
    }

    status = TRexStatus.jumping;
    jumpVelocity = TRexConfig.initialJumpVelocity - (speed / 10);

    reachedMinHeight = false;
  }

  @override
  void render(Canvas c) {
    if (size == null) {
      return;
    }
    actualDino.render(c);
  }

  void reset() {
    actualDino.y = groundYPos;
    jumpVelocity = 0.0;
    jumpCount = 0;
    status = TRexStatus.running;
  }

  @override
  void update(double t) {
    if (status == TRexStatus.jumping) {
      y += jumpVelocity;
      jumpVelocity += TRexConfig.gravity;
      if (y > groundYPos) {
        reset();
        jumpCount++;
      }
    } else {
      y = groundYPos;
    }

    // intro related
    if (jumpCount == 1 && !playingIntro && !hasPlayedIntro) {
      status = TRexStatus.intro;
    }
    if (playingIntro && x < TRexConfig.startXPos) {
      x += (TRexConfig.startXPos / TRexConfig.introDuration) * t * 5000;
    }

    actualDino.x = x;
    actualDino.y = y;
    actualDino.update(t);
  }

  @override
  void resize(Size size) {
    super.resize(size);
    actualDino.y = groundYPos;
  }

  double get groundYPos {
    if (size == null) {
      return null;
    }
    return (size.height / 2) - TRexConfig.height / 2;
  }

  bool get playingIntro => status == TRexStatus.intro;

  bool get ducking => status == TRexStatus.ducking;
}

class RunningTRex extends AnimationComponent {
  RunningTRex(Image spriteImage)
      : super(
          88.0,
          90.0,
          Animation.spriteList(
            [
              Sprite.fromImage(
                spriteImage,
                width: TRexConfig.width,
                height: TRexConfig.height,
                y: 4.0,
                x: 1514.0,
              ),
              Sprite.fromImage(
                spriteImage,
                width: TRexConfig.width,
                height: TRexConfig.height,
                y: 4.0,
                x: 1602.0,
              ),
            ],
            stepTime: 0.2,
            loop: true,
          ),
        );
}

class WaitingTRex extends SpriteComponent {
  WaitingTRex(Image spriteImage)
      : super.fromSprite(
          TRexConfig.width,
          TRexConfig.height,
          Sprite.fromImage(
            spriteImage,
            width: TRexConfig.width,
            height: TRexConfig.height,
            x: 76.0,
            y: 6.0,
          ),
        );
}

class JumpingTRex extends SpriteComponent {
  JumpingTRex(Image spriteImage)
      : super.fromSprite(
          TRexConfig.width,
          TRexConfig.height,
          Sprite.fromImage(
            spriteImage,
            width: TRexConfig.width,
            height: TRexConfig.height,
            x: 1339.0,
            y: 6.0,
          ),
        );
}

class SurprisedTRex extends SpriteComponent {
  SurprisedTRex(Image spriteImage)
      : super.fromSprite(
          TRexConfig.width,
          TRexConfig.height,
          Sprite.fromImage(
            spriteImage,
            width: TRexConfig.width,
            height: TRexConfig.height,
            x: 1782.0,
            y: 6.0,
          ),
        );
}

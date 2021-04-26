import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:trex/game/game.dart';
import 'package:trex/game/t_rex/config.dart';

enum TRexStatus { crashed, ducking, jumping, running, waiting, intro }

class TRex extends PositionComponent with HasGameRef<TRexGame> {
  final config = TRexConfig();

  // state
  TRexStatus status = TRexStatus.waiting;
  bool isIdle = true;

  double jumpVelocity = 0.0;
  bool reachedMinHeight = false;
  int jumpCount = 0;
  bool hasPlayedIntro = false;

  // ref to children
  late final WaitingTRex idleDino = WaitingTRex(gameRef.spriteImage, config);
  late final RunningTRex runningDino =
      RunningTRex(gameRef.spriteImage, config);
  late final JumpingTRex jumpingTRex =
      JumpingTRex(gameRef.spriteImage, config);
  late final SurprisedTRex surprisedTRex = SurprisedTRex(
    gameRef.spriteImage,
    config,
  );

  bool get playingIntro => status == TRexStatus.intro;

  bool get ducking => status == TRexStatus.ducking;

  double get groundYPos {
    return (gameRef.size.y / 2) - config.height / 2;
  }

  @override
  Future? onLoad() {
    addChild(idleDino);
    addChild(runningDino);
    addChild(jumpingTRex);
    addChild(surprisedTRex);
  }

  void startJump(double speed) {
    if (status == TRexStatus.jumping || status == TRexStatus.ducking) {
      return;
    }

    status = TRexStatus.jumping;
    jumpVelocity = config.initialJumpVelocity - (speed / 10);

    reachedMinHeight = false;
  }

  void reset() {
    y = groundYPos;
    jumpVelocity = 0.0;
    jumpCount = 0;
    status = TRexStatus.running;
  }

  @override
  void update(double dt) {
    if (status == TRexStatus.jumping) {
      y += jumpVelocity;
      jumpVelocity += config.gravity;
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
    if (playingIntro && x < config.startXPos) {
      x += (config.startXPos / config.introDuration) * dt * 5000;
    }
    super.update(dt);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    y = groundYPos;
    super.onGameResize(gameSize);
  }
}

mixin TRexStateVisibility on BaseComponent {
  late final List<TRexStatus> showFor;

  @override
  TRex get parent => super.parent as TRex;

  @override
  void render(Canvas canvas) {
    final show = showFor.any((element) => element == parent.status);
    if (!show) {
      return;
    }
    super.render(canvas);
  }
}

/// A component superclass for TRex states with still sprites
class TRexStateStillComponent extends SpriteComponent with TRexStateVisibility {
  TRexStateStillComponent({
    required List<TRexStatus> showFor,
    required Image spriteImage,
    required TRexConfig config,
    required Vector2 srcPosition,
  }) : super(
          size: Vector2(config.width, config.height),
          sprite: Sprite(
            spriteImage,
            srcPosition: srcPosition,
            srcSize: Vector2(config.width, config.height),
          ),
        ) {
    this.showFor = showFor;
  }
}

class TRexStateAnimatedComponent extends SpriteAnimationComponent
    with TRexStateVisibility {
  TRexStateAnimatedComponent({
    required List<TRexStatus> showFor,
    required Image spriteImage,
    required TRexConfig config,
    required Vector2 size,
    required List<Vector2> frames,
  }) : super(
          size: size, //,
          animation: SpriteAnimation.spriteList(
            frames
                .map((vector) => Sprite(
                      spriteImage,
                      srcSize: Vector2(config.width, config.height),
                      srcPosition: vector,
                    ))
                .toList(),
            stepTime: 0.2,
            loop: true,
          ),
        ) {
    this.showFor = showFor;
  }
}

class RunningTRex extends TRexStateAnimatedComponent {
  RunningTRex(
    Image spriteImage,
    TRexConfig config,
  ) : super(
          showFor: [TRexStatus.running, TRexStatus.intro],
          spriteImage: spriteImage,
          size: Vector2(88.0, 90.0),
          config: config,
          frames: [Vector2(1514.0, 4.0), Vector2(1602.0, 4.0)],
        );
}

class WaitingTRex extends TRexStateStillComponent {
  WaitingTRex(Image spriteImage, TRexConfig config)
      : super(
          showFor: [TRexStatus.waiting],
          config: config,
          spriteImage: spriteImage,
          srcPosition: Vector2(76.0, 6.0),
        );
}

class JumpingTRex extends TRexStateStillComponent {
  JumpingTRex(Image spriteImage, TRexConfig config)
      : super(
          showFor: [TRexStatus.jumping],
          config: config,
          spriteImage: spriteImage,
          srcPosition: Vector2(1339.0, 6.0),
        );
}

class SurprisedTRex extends TRexStateStillComponent {
  SurprisedTRex(Image spriteImage, TRexConfig config)
      : super(
          showFor: [TRexStatus.crashed],
          config: config,
          spriteImage: spriteImage,
          srcPosition: Vector2(1782.0, 6.0),
        );
}

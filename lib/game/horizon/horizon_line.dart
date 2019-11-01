import 'dart:math';
import 'dart:ui';

import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components/component.dart';
import 'package:flame/components/composed_component.dart';
import 'package:trex/game/horizon/clouds.dart';
import 'package:trex/game/horizon/config.dart';
import 'package:trex/game/obstacle/obstacle.dart';

Random rnd = Random();

class HorizonLine extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {

  HorizonLine(Image spriteImage) {
    final softSprite = Sprite.fromImage(
      spriteImage,
      width: HorizonDimensions.width,
      height: HorizonDimensions.height,
      y: 104.0,
      x: 2.0,
    );

    final bumpySprite = Sprite.fromImage(
      spriteImage,
      width: HorizonDimensions.width,
      height: HorizonDimensions.height,
      y: 104.0,
      x: 2.0 + HorizonDimensions.width,
    );

    cloudManager = CloudManager(spriteImage);
    obstacleManager = ObstacleManager(spriteImage);
    firstGround = HorizonGround(softSprite);
    secondGround = HorizonGround(bumpySprite);
    this
      ..add(firstGround)
      ..add(secondGround)
      ..add(cloudManager)
      ..add(obstacleManager);
  }

  HorizonGround firstGround;
  HorizonGround secondGround;

  CloudManager cloudManager;
  ObstacleManager obstacleManager;

  final double bumpThreshold = 0.5;

  bool getRandomType() {
    return rnd.nextDouble() > bumpThreshold;
  }

  void updateXPos(bool isBumpyFirst, double increment) {
    final first = isBumpyFirst ? firstGround : secondGround;
    final second = isBumpyFirst ? secondGround : firstGround;

    first.x -= increment;
    second.x = first.x + HorizonDimensions.width;

    if (first.x <= -HorizonDimensions.width) {
      first.x += HorizonDimensions.width * 2;
      second.x = first.x - HorizonDimensions.width;
    }
  }

  void updateWithSpeed(double t, double speed) {
    final increment = speed * 50 * t;
    updateXPos(firstGround.x <= 0, increment);

    cloudManager.updateWithSpeed(t, speed);
    obstacleManager.updateWithSpeed(t, speed);

    super.update(t);
  }

  @override
  void update(t) {
    for ( final c in components ) {
      final positionComponent = c as PositionComponent;
      positionComponent.y = y;
    }
  }

  void reset() {
    cloudManager.reset();
    obstacleManager.reset();

    firstGround.x = 0.0;
    secondGround.y = HorizonDimensions.width;
  }
}

class HorizonGround extends SpriteComponent with Resizable {
  HorizonGround(Sprite sprite)
      : super.fromSprite(
          HorizonDimensions.width,
          HorizonDimensions.height,
          sprite,
        );
}

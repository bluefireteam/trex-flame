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
    thirdGround = HorizonGround(softSprite);
    this
      ..add(firstGround)
      ..add(secondGround)
      ..add(thirdGround)
      ..add(cloudManager)
      ..add(obstacleManager);
  }

  HorizonGround firstGround;
  HorizonGround secondGround;
  HorizonGround thirdGround;

  CloudManager cloudManager;
  ObstacleManager obstacleManager;

  final double bumpThreshold = 0.5;

  bool getRandomType() {
    return rnd.nextDouble() > bumpThreshold;
  }

  void updateXPos(int indexFirst, double increment) {
    final grounds = [firstGround, secondGround, thirdGround];

    final first = grounds[indexFirst];
    final second = grounds[(indexFirst + 1) % 3];
    final third = grounds[(indexFirst + 2) % 3];

    first.x -= increment;
    second.x = first.x + HorizonDimensions.width;
    third.x = second.x + HorizonDimensions.width;

    if (first.x <= -HorizonDimensions.width) {
      first.x += HorizonDimensions.width * 3;
    }
  }

  void updateWithSpeed(double t, double speed) {
    final increment = speed * 50 * t;
    int index = firstGround.x <= 0 ? 0 : secondGround.x <= 0 ? 1 : 2;
    updateXPos(index, increment);

    cloudManager.updateWithSpeed(t, speed);
    obstacleManager.updateWithSpeed(t, speed);

    super.update(t);
  }

  @override
  void update(t) {
    super.update(t);
    for (final c in components) {
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

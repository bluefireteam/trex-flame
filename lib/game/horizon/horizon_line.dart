import 'dart:math';
import 'dart:ui';

import 'package:flame/sprite.dart';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';

import 'package:trex/game/custom/composed_component.dart';
import 'package:trex/game/horizon/clouds.dart';
import 'package:trex/game/horizon/config.dart';
import 'package:trex/game/obstacle/obstacle.dart';

Random rnd = new Random();

class HorizonLine extends PositionComponent with Resizable, ComposedComponent {
  HorizonGround firstGround;
  HorizonGround secondGround;

  CloudManager cloudManager;
  ObstacleManager obstacleManager;

  final double bumpThreshold = 0.5;

  HorizonLine(Image spriteImage) {
    Sprite softSprite = Sprite.fromImage(
      spriteImage,
      width: HorizonDimensions.width,
      height: HorizonDimensions.height,
      y: 104.0,
      x: 2.0,
    );

    Sprite bumpySprite = Sprite.fromImage(
      spriteImage,
      width: HorizonDimensions.width,
      height: HorizonDimensions.height,
      y: 104.0,
      x: 2.0 + HorizonDimensions.width,
    );

    this.cloudManager = CloudManager(spriteImage);
    this.obstacleManager = ObstacleManager(spriteImage);
    this.firstGround = HorizonGround(softSprite);
    this.secondGround = HorizonGround(bumpySprite);
    this
      ..add(firstGround)
      ..add(secondGround)
      ..add(cloudManager)
      ..add(obstacleManager);
  }

  bool getRandomType() {
    return rnd.nextDouble() > this.bumpThreshold;
  }

  void updateXPos(bool isBumpyFirst, double increment) {
    HorizonGround first = isBumpyFirst ? firstGround : secondGround;
    HorizonGround second = isBumpyFirst ? secondGround : firstGround;

    first.x -= increment;
    second.x = first.x + HorizonDimensions.width;

    if (first.x <= -HorizonDimensions.width) {
      first.x += HorizonDimensions.width * 2;
      second.x = first.x - HorizonDimensions.width;
    }
  }

  void updateWithSpeed(double t, double speed) {
    double increment = (speed * 50 * t);
    updateXPos(firstGround.x <= 0, increment);

    cloudManager.updateWithSpeed(t, speed);
    obstacleManager.updateWithSpeed(t, speed);

    super.update(t);
  }

  void update(t) {
    this.updateComponents((c) {
      PositionComponent positionComponent = c as PositionComponent;
      positionComponent.y = y;
    });
  }

  void reset() {
    cloudManager.reset();
    obstacleManager.reset();

    this.firstGround.x = 0.0;
    this.secondGround.y = HorizonDimensions.width;
  }
}

class HorizonGround extends SpriteComponent with Resizable {
  HorizonGround(Sprite sprite)
      : super.fromSprite(
            HorizonDimensions.width, HorizonDimensions.height, sprite);
}

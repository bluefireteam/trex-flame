import 'dart:collection';
import 'dart:ui';

import 'package:flame/components.dart';
import 'package:trex/game/collision/collision_box.dart';
import 'package:trex/game/custom/util.dart';
import 'package:trex/game/horizon/config.dart';

import '../game.dart';
import 'config.dart';
import 'obstacle_type.dart';

class ObstacleManager extends PositionComponent with HasGameRef<TRexGame> {
  ObstacleManager(this.dimensions);

  ListQueue<ObstacleType> history = ListQueue();
  final HorizonDimensions dimensions;

  @override
  void update(double dt) {
    for (final c in children) {
      final cloud = c as Obstacle;
      cloud.y = y + cloud.type.y - 75;
    }

    final speed = gameRef.currentSpeed;

    if (children.isNotEmpty) {
      final lastObstacle = children.last as Obstacle?;

      if (lastObstacle != null &&
          !lastObstacle.followingObstacleCreated &&
          lastObstacle.isVisible &&
          (lastObstacle.x + lastObstacle.width + lastObstacle.gap) <
              dimensions.width) {
        addNewObstacle(speed);
        lastObstacle.followingObstacleCreated = true;
      }
    } else {
      addNewObstacle(speed);
    }

    super.update(dt);
  }

  void addNewObstacle(double speed) {
    if (speed == 0) {
      return;
    }
    final type = getRandomNum(0.0, 1.0).round() == 0
        ? ObstacleType.cactusSmall
        : ObstacleType.cactusLarge;
    if (duplicateObstacleCheck(type) || speed < type.multipleSpeed) {
      return;
    } else {
      final obstacle = Obstacle(
        type: type,
        spriteImage: gameRef.spriteImage,
        speed: speed,
        gapCoefficient: gameRef.config.gapCoefficient,
        dimensions: dimensions,
      );

      obstacle.x = gameRef.size.x;

      addChild(obstacle);

      history.addFirst(type);
      if (history.length > 1) {
        final sublist =
            history.toList().sublist(0, gameRef.config.maxObstacleDuplication);
        history = ListQueue.from(sublist);
      }
    }
  }

  bool duplicateObstacleCheck(ObstacleType nextType) {
    int duplicateCount = 0;

    for (final c in history) {
      duplicateCount += c.type == nextType.type ? 1 : 0;
    }
    return duplicateCount >= gameRef.config.maxObstacleDuplication;
  }

  void reset() {
    clearChildren();
    history.clear();
  }
}

class Obstacle extends SpriteComponent with HasGameRef<TRexGame> {
  Obstacle({
    required this.type,
    required Image spriteImage,
    required double speed,
    required double gapCoefficient,
    required HorizonDimensions dimensions,
    double xOffset = 0.0,
  }) : super(
          sprite: type.getSprite(spriteImage),
        ) {
    x = dimensions.width + xOffset;

    if (internalSize > 1 && type.multipleSpeed > speed) {
      internalSize = 1;
    }

    width = type.width * internalSize;
    height = type.height;
    gap = computeGap(gapCoefficient, speed);
    final actualSrc = sprite!.src;
    sprite!.src = Rect.fromLTWH(
      actualSrc.left,
      actualSrc.top,
      width,
      actualSrc.height,
    );
  }

  final ObstacleConfig config = ObstacleConfig();

  bool followingObstacleCreated = false;
  late double gap;

  late int internalSize = getRandomNum(
    1.0,
    config.maxObstacleLength / 1,
  ).floor();

  ObstacleType type;

  late List<CollisionBox> collisionBoxes = [
    for (final box in type.collisionBoxes) CollisionBox.from(box)
  ];

  bool get isVisible => (x + width) > 0;

  double computeGap(double gapCoefficient, double speed) {
    final minGap = (width * speed * type.minGap * gapCoefficient).round() / 1;
    final maxGap = (minGap * config.maxGapCoefficient).round() / 1;

    return getRandomNum(minGap, maxGap);
  }

  @override
  void update(double dt) {
    if (shouldRemove) {
      return;
    }

    final increment = gameRef.currentSpeed * 50 * dt;
    x -= increment;

    if (!isVisible) {
      remove();
    }
    super.update(dt);
  }
}

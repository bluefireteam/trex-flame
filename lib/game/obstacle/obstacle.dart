import 'dart:collection';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/composed_component.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';

import 'package:trex/game/collision/collision_box.dart';
import 'package:trex/game/custom/util.dart';
import 'package:trex/game/game_config.dart';
import 'package:trex/game/horizon/config.dart';
import 'package:trex/game/obstacle/config.dart';
import 'package:trex/game/obstacle/obstacle_type.dart';

class ObstacleManager extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {

  ObstacleManager(this.spriteImage) : super();

  ListQueue<ObstacleType> history = ListQueue();

  Image spriteImage;

  void updateWithSpeed(double t, double speed) {
    for(final c in components){
      final cloud = c as Obstacle;
      cloud.updateWithSpeed(t, speed);
    }

    if (components.isNotEmpty) {
      final lastObstacle = components.last as Obstacle;

      if (lastObstacle != null &&
          !lastObstacle.followingObstacleCreated &&
          lastObstacle.isVisible &&
          (lastObstacle.x + lastObstacle.width + lastObstacle.gap) <
              HorizonDimensions.width) {
        addNewObstacle(speed);
        lastObstacle.followingObstacleCreated = true;
      }
    } else {
      addNewObstacle(speed);
    }
  }

  void addNewObstacle(double speed) {
    final type = getRandomNum(0.0, 1.0).round() == 0
        ? ObstacleType.cactusSmall
        : ObstacleType.cactusLarge;
    if (duplicateObstacleCheck(type) || speed < type.multipleSpeed) {
      return;
    } else {
      final obstacleSprite = ObstacleType.spriteForType(type, spriteImage);
      final obstacle = Obstacle(
        type,
        obstacleSprite,
        speed,
        GameConfig.gapCoefficient,
        type.width,
      );

      obstacle.x = HorizonDimensions.width;

      components.add(obstacle);

      history.addFirst(type);
      if (history.length > 1) {
        final sublist =
            history.toList().sublist(0, GameConfig.maxObstacleDuplication);
        history = ListQueue.from(sublist);
      }
    }
  }

  bool duplicateObstacleCheck(ObstacleType nextType) {
    int duplicateCount = 0;
    for (final c in history) {
      duplicateCount += c == nextType ? 1 : 0;
    }
    return duplicateCount >= GameConfig.maxObstacleDuplication;
  }

  void reset() {
    components.clear();
    history.clear();
  }

  @override
  void update(double t) {
    for (final c in components) {
      final cloud = c as Obstacle;
      cloud.y = y + cloud.type.y - 75;
    }
    super.update(t);
  }
}

class Obstacle extends SpriteComponent with Resizable {

  Obstacle(
      this.type,
      Sprite sprite,
      double speed,
      double gapCoefficient, [
        double xOffset,
      ]) : super.fromSprite(
    type.width,
    type.height,
    sprite,
  ) {
    cloneCollisionBoxes();

    internalSize =
        getRandomNum(1.0, ObstacleConfig.maxObstacleLength / 1).floor();
    x = HorizonDimensions.width + (xOffset ?? 0.0);

    if (internalSize > 1 && type.multipleSpeed > speed) {
      internalSize = 1;
    }

    width = type.width * internalSize;
    final actualSrc = this.sprite.src;
    this.sprite.src = Rect.fromLTWH(
      actualSrc.left,
      actualSrc.top,
      width,
      actualSrc.height,
    );

    gap = getGap(gapCoefficient, speed);
  }

  List<CollisionBox> collisionBoxes = [];
  ObstacleType type;

  bool toRemove = false;
  bool followingObstacleCreated = false;
  double gap = 0.0;
  int internalSize;

  @override
  void update(double t) {}

  void updateWithSpeed(double t, double speed) {
    if (toRemove) {
      return;
    }

    final increment = speed * 50 * t;
    x -= increment;

    if (!isVisible) {
      toRemove = true;
    }
  }

  double getGap(double gapCoefficient, double speed) {
    final minGap = (width * speed * type.minGap * gapCoefficient).round() / 1;
    final maxGap = (minGap * ObstacleConfig.maxGapCoefficient).round() / 1;
    return getRandomNum(minGap, maxGap);
  }

  @override
  bool destroy() {
    return toRemove;
  }

  bool get isVisible => x + width > 0;

  void cloneCollisionBoxes() {
    final typeCollisionBoxes = type.collisionBoxes;

    for (final box in typeCollisionBoxes) {
      collisionBoxes
        ..add(
          CollisionBox(
            x: box.x,
            y: box.y,
            width: box.width,
            height: box.height,
          ),
        );
    }
  }
}

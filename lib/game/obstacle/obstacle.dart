import 'dart:collection';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/sprite.dart';
import 'package:trex/game/collision/collision_box.dart';
import 'package:trex/game/custom/composed_component.dart';
import 'package:trex/game/custom/util.dart';
import 'package:trex/game/game_config.dart';
import 'package:trex/game/horizon/config.dart';
import 'package:trex/game/obstacle/config.dart';
import 'package:trex/game/obstacle/obstacle_type.dart';

class ObstacleManager extends PositionComponent
    with Resizable, ComposedComponent {
  ListQueue<ObstacleType> history = new ListQueue();

  Image spriteImage;
  ObstacleManager(this.spriteImage) : super();

  void updateWithSpeed(double t, double speed) {
    updateComponents((c) {
      Obstacle cloud = c as Obstacle;
      cloud.updateWithSpeed(t, speed);
    });

    if (components.length > 0) {
      Obstacle lastObstacle = components.last as Obstacle;

      if (lastObstacle != null &&
          !lastObstacle.followingObstacleCreated &&
          lastObstacle.isVisible &&
          (lastObstacle.x + lastObstacle.width + lastObstacle.gap) <
              HorizonDimensions.width) {
        this.addNewObstacle(speed);
        lastObstacle.followingObstacleCreated = true;
      }
    } else {
      addNewObstacle(speed);
    }
  }

  void addNewObstacle(double speed) {
    ObstacleType type = getRandomNum(0.0, 1.0).round() == 0
        ? ObstacleType.cactusSmall
        : ObstacleType.cactusLarge;
    if (duplicateObstacleCheck(type) || speed < type.multipleSpeed) {
      return;
    } else {
      Sprite obstacleSprite = ObstacleType.spriteForType(type, spriteImage);
      Obstacle obstacle = Obstacle(
          type, obstacleSprite, speed, GameConfig.gapCoefficient, type.width);

      obstacle.x = HorizonDimensions.width;

      components.add(obstacle);

      history.addFirst(type);
      if (history.length > 1) {
        List<ObstacleType> sublist =
            history.toList().sublist(0, GameConfig.maxObstacleDuplication);
        history = ListQueue.from(sublist);
      }
    }
  }

  bool duplicateObstacleCheck(ObstacleType nextType) {
    int duplicateCount = 0;
    history.forEach((c) {
      duplicateCount += c == nextType ? 1 : 0;
    });

    return duplicateCount >= GameConfig.maxObstacleDuplication;
  }

  void reset() {
    components.clear();
    history.clear();
  }

  @override
  void update(double t) {
    updateComponents((c) {
      Obstacle cloud = c as Obstacle;
      cloud.y = this.y + cloud.type.y - 75;
    });
    super.update(t);
  }
}

class Obstacle extends SpriteComponent with Resizable {
  List<CollisionBox> collisionBoxes = new List();
  ObstacleType type;

  bool toRemove = false;
  bool followingObstacleCreated = false;
  double gap = 0.0;
  double width = 0.0;
  int internalSize;

  Obstacle(this.type, Sprite sprite, double speed, double gapCoefficient,
      [double opt_xOffset])
      : super.fromSprite(type.width, type.height, sprite) {
    cloneCollisionBoxes();

    internalSize =
        getRandomNum(1.0, ObstacleConfig.maxObstacleLength / 1).floor();
    x = HorizonDimensions.width + (opt_xOffset ?? 0.0);

    if (this.internalSize > 1 && type.multipleSpeed > speed) {
      this.internalSize = 1;
    }

    width = this.type.width * internalSize;
    Rect actualSrc = this.sprite.src;
    this.sprite.src =
        Rect.fromLTWH(actualSrc.left, actualSrc.top, width, actualSrc.height);

    gap = this.getGap(gapCoefficient, speed);
  }

  @override
  void update(double t) {}

  void updateWithSpeed(double t, double speed) {
    if (toRemove) return;
    double increment = (speed * 50 * t);
    x -= increment;

    if (!isVisible) {
      this.toRemove = true;
    }
  }

  double getGap(double gapCoefficient, double speed) {
    double minGap = (width * speed * type.minGap * gapCoefficient).round() / 1;
    double maxGap = (minGap * ObstacleConfig.maxGapCoefficient).round() / 1;
    return getRandomNum(minGap, maxGap);
  }

  bool destroy() {
    return toRemove;
  }

  bool get isVisible => x + this.width > 0;

  void cloneCollisionBoxes() {
    List<CollisionBox> typeCollisionBoxes = type.collisionBoxes;

    typeCollisionBoxes.forEach((CollisionBox box) {
      this.collisionBoxes.add(CollisionBox(
            x: box.x,
            y: box.y,
            width: box.width,
            height: box.height,
          ));
    });
  }
}

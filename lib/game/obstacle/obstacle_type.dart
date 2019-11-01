import 'dart:ui';

import 'package:flame/sprite.dart';
import 'package:trex/game/collision/collision_box.dart';

class ObstacleType {
  const ObstacleType._internal(
    this.type, {
    this.width,
    this.height,
    this.y,
    this.multipleSpeed,
    this.minGap,
    this.minSpeed,
    this.numFrames,
    this.frameRate,
    this.speedOffset,
    this.collisionBoxes,
  });

  final String type;
  final double width;
  final double height;
  final double y;
  final int multipleSpeed;
  final double minGap;
  final double minSpeed;
  final int numFrames;
  final double frameRate;
  final double speedOffset;

  final List<CollisionBox> collisionBoxes;

  static const cactusSmall = ObstacleType._internal(
    "cactusSmall",
    width: 34.0,
    height: 70.0,
    y: 20.0,
    multipleSpeed: 4,
    minGap: 120.0,
    minSpeed: 0.0,
    collisionBoxes: <CollisionBox>[
      CollisionBox(
        x: 5.0,
        y: 7.0,
        width: 10.0,
        height: 54.0,
      ),
      CollisionBox(
        x: 9.0,
        y: 0.0,
        width: 12.0,
        height: 68.0,
      ),
      CollisionBox(
        x: 15.0,
        y: 4.0,
        width: 14.0,
        height: 28.0,
      ),
    ],
  );

  static const cactusLarge = ObstacleType._internal(
    "cactusLarge",
    width: 50.0,
    height: 100.0,
    y: 1.0,
    multipleSpeed: 7,
    minGap: 120.0,
    minSpeed: 0.0,
    collisionBoxes: <CollisionBox>[
      CollisionBox(x: 0.0, y: 12.0, width: 14.0, height: 76.0),
      CollisionBox(x: 8.0, y: 0.0, width: 14.0, height: 98.0),
      CollisionBox(x: 13.0, y: 10.0, width: 20.0, height: 76.0)
    ],
  );

  static Sprite spriteForType(ObstacleType type, Image spriteImage) {
    if (type == cactusSmall) {
      return Sprite.fromImage(
        spriteImage,
        x: 446.0,
        y: 2.0,
        width: type.width,
        height: type.height,
      );
    }
    return Sprite.fromImage(
      spriteImage,
      x: 652.0,
      y: 2.0,
      width: type.width,
      height: type.height,
    );
  }
}

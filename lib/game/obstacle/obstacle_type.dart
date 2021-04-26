import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/sprite.dart';
import 'package:trex/game/collision/collision_box.dart';

class ObstacleType {
  const ObstacleType._internal(
    this.type, {
    required this.width,
    required this.height,
    required this.y,
    required this.multipleSpeed,
    required this.minGap,
    required this.minSpeed,
    this.numFrames,
    this.frameRate,
    this.speedOffset,
    required this.collisionBoxes,
  });

  final String type;
  final double width;
  final double height;
  final double y;
  final int multipleSpeed;
  final double minGap;
  final double minSpeed;
  final int? numFrames;
  final double? frameRate;
  final double? speedOffset;

  final List<CollisionBox> collisionBoxes;

  static final cactusSmall = ObstacleType._internal(
    "cactusSmall",
    width: 34.0,
    height: 70.0,
    y: 20.0,
    multipleSpeed: 4,
    minGap: 120.0,
    minSpeed: 0.0,
    collisionBoxes: <CollisionBox>[
      CollisionBox(
        position: Vector2(5.0, 7.0),
        size: Vector2(10.0, 54.0),
      ),
      CollisionBox(
        position: Vector2(5.0, 7.0),
        size: Vector2(12.0, 68.0),
      ),
      CollisionBox(
        position: Vector2(15.0, 4.0),
        size: Vector2(14.0, 28.0),
      ),
    ],
  );

  static final cactusLarge = ObstacleType._internal(
    "cactusLarge",
    width: 50.0,
    height: 100.0,
    y: 1.0,
    multipleSpeed: 7,
    minGap: 120.0,
    minSpeed: 0.0,
    collisionBoxes: <CollisionBox>[
      CollisionBox(
        position: Vector2(0.0, 12.0),
        size: Vector2(14.0, 76.0),
      ),
      CollisionBox(
        position: Vector2(8.0, 0.0),
        size: Vector2(14.0, 98.0),
      ),
      CollisionBox(
        position: Vector2(13.0, 10.0),
        size: Vector2(20.0, 76.0),
      )
    ],
  );

  Sprite getSprite(Image spriteImage) {
    if (this == cactusSmall) {
      return Sprite(
        spriteImage,
        srcPosition: Vector2(446.0, 2.0),
        srcSize: Vector2(width, height),
      );
    }
    return Sprite(
      spriteImage,
      srcPosition: Vector2(652.0, 2.0),
      srcSize: Vector2(width, height),
    );
  }

  @override
  String toString() {
    return type;
  }
}

import 'dart:ui';

import 'package:flame/sprite.dart';

class ObstacleType {

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

  const ObstacleType._internal(this.type,{
    this.width,
    this.height,
    this.y,
    this.multipleSpeed,
    this.minGap,
    this.minSpeed,
    this.numFrames,
    this.frameRate,
    this.speedOffset,
  });

  static const cactusSmall = ObstacleType._internal("cactusSmall",
    width: 34.0,
    height: 70.0,
    y: 20.0,
    multipleSpeed: 4,
    minGap: 120.0,
    minSpeed: 0.0,
  );

  static const cactusLarge = ObstacleType._internal("cactusLarge",
    width: 50.0,
    height: 100.0,
    y: 1.0,
    multipleSpeed: 7,
    minGap: 120.0,
    minSpeed: 0.0,
  );

  static Sprite spriteForType(ObstacleType type, Image spriteImage){
    if(type == cactusSmall) {
      return Sprite.fromImage(spriteImage,
        x: 446.0,
        y: 2.0,
        width: type.width,
        height: type.height
      );
    }
    return Sprite.fromImage(spriteImage,
      x: 652.0,
      y: 2.0,
      width: type.width,
      height: type.height
    );
  }

}

import 'dart:math';
import 'dart:ui';

import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';

import 'package:trex/game/custom/composed_component.dart';
import 'package:trex/game/horizon/clouds.dart';
import 'package:trex/game/horizon/config.dart';

Random rnd = new Random();



class HorizonLine extends PositionComponent with  Resizable, ComposedComponent {
  HorizonGround firstGround;
  HorizonGround secondGround;

  CloudManager cloudManager;

  final double bumpThreshold = 0.5;

  HorizonLine(Image spriteImage){
    Sprite softSprite = Sprite.fromImage(spriteImage,
      width: HorizonDimensions.width,
      height: HorizonDimensions.height,
      y: 104.0,
      x: 2.0,
    );

    Sprite bumpySprite = Sprite.fromImage(spriteImage,
      width: HorizonDimensions.width,
      height: HorizonDimensions.height,
      y: 104.0,
      x: 2.0 + HorizonDimensions.width,
    );
    this.cloudManager = CloudManager(spriteImage);
    this.firstGround = HorizonGround(softSprite);
    this.secondGround = HorizonGround(bumpySprite);
    this..add(firstGround)..add(secondGround)..add(cloudManager);
  }

  bool getRandomType () {
    return rnd.nextDouble() > this.bumpThreshold;
  }

  void updateXPos(bool isBumpyFirst, double increment) {
    HorizonGround first = isBumpyFirst ? firstGround : secondGround;
    HorizonGround second = isBumpyFirst ? secondGround : firstGround;

    first.x -= increment;
    second.x = first.x + HorizonDimensions.width;

    if(first.x <= -HorizonDimensions.width){
      first.x += HorizonDimensions.width * 2;
      second.x = first.x - HorizonDimensions.width;
    }
  }

  void updateWithSpeed(double t, double speed) {
    double increment = (speed * 50 * t);
    updateXPos(firstGround.x <= 0, increment);
    cloudManager.updateWithSpeed(t, speed);
    super.update(t);
  }

  void update (t) {
    this.updateComponents((c){
      PositionComponent positionComponent = c as PositionComponent;
      positionComponent.y = y;
    });
  }
}

class HorizonGround extends SpriteComponent with Resizable {
  HorizonGround(Sprite sprite) :
        super.fromSprite(HorizonDimensions.width, HorizonDimensions.height, sprite);
  @override
  render(Canvas canvas) {
    if(x < HorizonDimensions.width){
      TextPainter p = Flame.util
          .text("Tampa", color: new Color.fromRGBO(0, 0, 0, 1.0), fontSize: 48.0);
    }
    super.render(canvas);
  }
}
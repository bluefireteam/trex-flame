import 'dart:math';
import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flutter/painting.dart';
import 'package:ordered_set/comparing.dart';
import 'package:ordered_set/ordered_set.dart';

class HorizonDimensions {
  static double width = 1200.0;
  static double height = 24.0;
  static double yPos = 127.0;
}

Random rnd = new Random();

class Horizon extends PositionComponent with  Resizable, ComposedComponent {
  HorizonLine horizonLine;

  Horizon(Image spriteImage){
    this.horizonLine = HorizonLine(spriteImage);
    this.add(horizonLine);
  }

  void update (t) {
    horizonLine.y = y;
    super.update(t);
  }

  void updateWithSpeed(double t, double speed) {

    if(size == null) return;
    y = (size.height / 2) + 21.0;

    this.updateComponents((c){
      PositionComponent positionComponent = c as PositionComponent;
      positionComponent.y = y;
    });
    horizonLine.updateWithSpeed(t, speed);
    super.update(t);
  }


}

class HorizonLine extends PositionComponent with  Resizable, ComposedComponent {
  HorizonGround firstGround;
  HorizonGround secondGround;
  Sprite softSprite;
  Sprite bumpySprite;

  final double bumpThreshold = 0.5;

  HorizonLine(Image spriteImage){
    softSprite = Sprite.fromImage(spriteImage,
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

    this.firstGround = HorizonGround(spriteImage, softSprite);
    this.secondGround = HorizonGround(spriteImage,bumpySprite);
    this..add(firstGround)..add(secondGround);
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
  HorizonGround(Image spriteImage, Sprite sprite) :
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



abstract class ComposedComponent extends Component with Resizable {
  OrderedSet<Component> components = new OrderedSet(Comparing.on((c) => c.priority()));

  @override
  render(Canvas canvas) {
    canvas.save();
    components.forEach((comp) => renderComponent(canvas, comp));
    canvas.restore();
  }

  void renderComponent(Canvas canvas, Component c) {
    c.render(canvas);
    canvas.restore();
    canvas.save();
  }

  @override
  void update(double t) {
    components.forEach((c) => c.update(t));
    components.removeWhere((c) => c.destroy());
  }

  void add(Component c) {
    this.components.add(c);

    // first time resize
    if (size != null) {
      c.resize(size);
    }
  }

  void updateComponents ( IterateOverComponents iterateOverComponents ){
    components.forEach(iterateOverComponents);
  }

}
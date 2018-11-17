import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/resizable.dart';

import 'package:trex/game/custom/composed_component.dart';
import 'package:trex/game/horizon/horizon_line.dart';

class Horizon extends PositionComponent with Resizable, ComposedComponent {
  HorizonLine horizonLine;

  Horizon(Image spriteImage) {
    this.horizonLine = HorizonLine(spriteImage);
    this.add(horizonLine);
  }

  void update(t) {
    horizonLine.y = y;
    super.update(t);
  }

  void updateWithSpeed(double t, double speed) {
    if (size == null) return;
    y = (size.height / 2) + 21.0;

    this.updateComponents((c) {
      PositionComponent positionComponent = c as PositionComponent;
      positionComponent.y = y;
    });
    horizonLine.updateWithSpeed(t, speed);
    super.update(t);
  }

  void reset() {
    horizonLine.reset();
  }
}

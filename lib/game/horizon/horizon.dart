import 'package:flame/components.dart';

import '../game.dart';
import 'horizon_line.dart';

class Horizon extends PositionComponent with HasGameRef<TRexGame> {
  late final horizonLine = HorizonLine();

  @override
  Future<void>? onLoad() {
    addChild(horizonLine);
  }

  @override
  void update(double t) {
    y = (size.y / 2) + 21.0;
    super.update(t);
  }

  void reset() {
    horizonLine.reset();
  }
}

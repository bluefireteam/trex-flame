import 'package:trex/game/collision/collision_box.dart';

class TRexConfig {
  static double gravity = 1;
  static double height = 90.0;
  static double heightDuck = 50.0;
  static double initialJumpVelocity = -15.0;
  static double introDuration = 1500.0;
  static double maxJumpHeight = 30.0;
  static double minJumpHeight = 30.0;
  static double speedDropCoefficient = 3.0;
  static double startXPos = 50.0;
  static double width = 88.0;
  static double widthDuck = 118.0;
}

class TRexCollisionBoxes {
  static final List<CollisionBox> ducking = <CollisionBox>[
    const CollisionBox(
      x: 1.0,
      y: 18.0,
      width: 110.0,
      height: 50.0,
    ),
  ];

  static final List<CollisionBox> running = <CollisionBox>[
    const CollisionBox(x: 22.0, y: 0.0, width: 34.0, height: 32.0),
    const CollisionBox(x: 1.0, y: 18.0, width: 60.0, height: 18.0),
    const CollisionBox(x: 10.0, y: 35.0, width: 28.0, height: 16.0),
    const CollisionBox(x: 1.0, y: 24.0, width: 58.0, height: 10.0),
    const CollisionBox(x: 5.0, y: 30.0, width: 42.0, height: 8.0),
    const CollisionBox(x: 9.0, y: 34.0, width: 30.0, height: 8.0)
  ];
}

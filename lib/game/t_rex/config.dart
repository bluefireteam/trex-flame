import 'package:flame/components.dart';
import 'package:trex/game/collision/collision_box.dart';

class TRexConfig {
  final double gravity = 1;

  final double initialJumpVelocity = -15.0;
  final double introDuration = 1500.0;
  final double maxJumpHeight = 30.0;
  final double minJumpHeight = 30.0;
  final double speedDropCoefficient = 3.0;
  final double startXPos = 50.0;

  final double height = 90.0;
  final double width = 88.0;

  final double heightDuck = 50.0;
  final double widthDuck = 118.0;
}

final tRexCollisionBoxesDucking = <CollisionBox>[
  CollisionBox(
    position: Vector2(1.0, 18.0),
    size: Vector2(110.0, 50.0),
  ),
];

final tRexCollisionBoxesRunning = <CollisionBox>[
  CollisionBox(
    position: Vector2(22.0, 0.0),
    size: Vector2(34.0, 32.0),
  ),
  CollisionBox(
    position: Vector2(1.0, 18.0),
    size: Vector2(60.0, 18.0),
  ),
  CollisionBox(
    position: Vector2(10.0, 35.0),
    size: Vector2(28.0, 16.0),
  ),
  CollisionBox(
    position: Vector2(1.0, 24.0),
    size: Vector2(58.0, 10.0),
  ),
  CollisionBox(
    position: Vector2(5.0, 30.0),
    size: Vector2(42.0, 8.0),
  ),
  CollisionBox(
    position: Vector2(9.0, 34.0),
    size: Vector2(30.0, 8.0),
  )
];

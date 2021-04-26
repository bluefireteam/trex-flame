import 'package:flame/components.dart';
import 'package:trex/game/collision/collision_box.dart';
import 'package:trex/game/obstacle/obstacle.dart';
import 'package:trex/game/t_rex/config.dart';
import 'package:trex/game/t_rex/t_rex.dart';

bool checkForCollision(Obstacle obstacle, TRex tRex) {
  final tRexBox = CollisionBox(
    position: Vector2(
      tRex.x + 1,
      tRex.y + 1,
    ),
    size: Vector2(
      tRex.config.width - 2,
      tRex.config.height - 2,
    ),
  );

  final obstacleBox = CollisionBox(
    position: Vector2(
      obstacle.absolutePosition.x + 1,
      obstacle.absolutePosition.y + 1,
    ),
    size: Vector2(
      obstacle.type.width * obstacle.internalSize - 2,
      obstacle.type.height - 2,
    ),
  );

  if (obstacleBox.toRect().overlaps(tRexBox.toRect())) {
    final collisionBoxes = obstacle.collisionBoxes;
    final tRexCollisionBoxes =
        tRex.ducking ? tRexCollisionBoxesDucking : tRexCollisionBoxesRunning;

    bool crashed = false;

    for (final obstacleCollisionBox in collisionBoxes) {
      final adjObstacleBox = createAdjustedCollisionBox(
        obstacleCollisionBox,
        obstacleBox,
      );

      for (final tRexCollisionBox in tRexCollisionBoxes) {
        final adjTRexBox = createAdjustedCollisionBox(
          tRexCollisionBox,
          tRexBox,
        );
        crashed =
            crashed || adjTRexBox.toRect().overlaps(adjObstacleBox.toRect());
      }
    }

    return crashed;
  }
  return false;
}

CollisionBox createAdjustedCollisionBox(
  CollisionBox box,
  CollisionBox adjustment,
) {
  return CollisionBox(
    position: Vector2(
      box.position.x + adjustment.position.x,
      box.position.y + adjustment.position.y,
    ),
    size: Vector2(
      box.size.x,
      box.size.y,
    ),
  );
}

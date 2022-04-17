import 'package:flame/components.dart';
import 'package:trex/game/obstacle/obstacle.dart';

import '../game.dart';
import 'clouds.dart';
import 'config.dart';

class HorizonLine extends PositionComponent with HasGameRef<TRexGame> {
  late final dimensions = HorizonDimensions();

  late final _softSprite = Sprite(
    gameRef.spriteImage,
    srcPosition: Vector2(2.0, 104.0),
    srcSize: Vector2(dimensions.width, dimensions.height),
  );

  late final _bumpySprite = Sprite(
    gameRef.spriteImage,
    srcPosition: Vector2(2.0 + dimensions.width, 104.0),
    srcSize: Vector2(dimensions.width, dimensions.height),
  );

  // grounds
  late final firstGround = HorizonGround(_softSprite, dimensions);
  late final secondGround = HorizonGround(_bumpySprite, dimensions);
  late final thirdGround = HorizonGround(_softSprite, dimensions);

  // children
  late final CloudManager cloudManager =
      CloudManager(horizonConfig: HorizonConfig());
  late final ObstacleManager obstacleManager = ObstacleManager(dimensions);

  @override
  void onMount() {
    add(firstGround);
    add(secondGround);
    add(thirdGround);
    add(cloudManager);
    add(obstacleManager);
    super.onMount();
  }

  void updateXPos(int indexFirst, double increment) {
    final grounds = [firstGround, secondGround, thirdGround];

    final first = grounds[indexFirst];
    final second = grounds[(indexFirst + 1) % 3];
    final third = grounds[(indexFirst + 2) % 3];

    first.x -= increment;
    second.x = first.x + dimensions.width;
    third.x = second.x + dimensions.width;

    if (first.x <= -dimensions.width) {
      first.x += dimensions.width * 3;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    final increment = gameRef.currentSpeed * 50 * dt;
    final index = firstGround.x <= 0
        ? 0
        : secondGround.x <= 0
            ? 1
            : 2;
    updateXPos(index, increment);
  }

  void reset() {
    cloudManager.reset();
    obstacleManager.reset();

    firstGround.x = 0.0;
    secondGround.x = dimensions.width;
  }
}

class HorizonGround extends SpriteComponent {
  HorizonGround(Sprite sprite, HorizonDimensions dimensions)
      : super(
          size: Vector2(dimensions.width, dimensions.height),
          sprite: sprite,
        );
}

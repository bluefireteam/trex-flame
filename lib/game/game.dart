import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/gestures.dart';
import 'package:trex/game/horizon/horizon.dart';
import 'package:trex/game/collision/collision_utils.dart';
import 'package:trex/game/game_config.dart';
import 'package:trex/game/game_over/game_over.dart';
import 'package:trex/game/t_rex/config.dart';
import 'package:trex/game/t_rex/t_rex.dart';

class Bg extends Component with HasGameRef {
  Vector2 size = Vector2.zero();

  late final Paint _paint = Paint()..color = const Color(0xffffffff);

  @override
  void render(Canvas c) {
    final rect = Rect.fromLTWH(0, 0, size.x, size.y);
    c.drawRect(rect, _paint);
  }

  @override
  void onGameResize(Vector2 gameSize) {
    size = gameSize;
  }
}

enum TRexGameStatus { playing, waiting, gameOver }

class TRexGame extends BaseGame with TapDetector {
 late final config = GameConfig();

  TRexGame({
    required this.spriteImage,
  }) : super();

  final Image spriteImage;

  /// children
  late final tRex = TRex();
  late final horizon = Horizon();
  late final gameOverPanel = GameOverPanel();


  @override
  Future<void> onLoad() async {
    add(Bg());
    add(horizon);
    add(tRex);
    add(gameOverPanel);
  }

  // state
  late TRexGameStatus status = TRexGameStatus.waiting;
  late double currentSpeed = config.speed;
  late double timePlaying = 0.0;
  bool get playing => status == TRexGameStatus.playing;
  bool get gameOver => status == TRexGameStatus.gameOver;

  @override
  void onTapDown(_) {
    onAction();
  }

  void onAction() {
    if (gameOver) {
      restart();
      return;
    }
    tRex.startJump(currentSpeed);
  }


  void startGame() {
    tRex.status = TRexStatus.running;
    status = TRexGameStatus.playing;
    tRex.hasPlayedIntro = true;
  }


  void doGameOver() {
    gameOverPanel.visible = true;
    status = TRexGameStatus.gameOver;
    tRex.status = TRexStatus.crashed;
  }


  void restart() {
    status = TRexGameStatus.playing;
    tRex.reset();
    horizon.reset();
    currentSpeed = config.speed;
    //gameOverPanel.visible = false;
    timePlaying = 0.0;
  }


  @override
  void update(double t) {
    tRex.update(t);

    if (gameOver) {
      return;
    }

    if (tRex.playingIntro && tRex.x >= tRex.config.startXPos) {
      startGame();
    } else if (tRex.playingIntro) {
    }

    if (playing) {
      timePlaying += t;

      final obstacles = horizon.horizonLine.obstacleManager.components;
      // final hasCollision = obstacles.isNotEmpty && checkForCollision(obstacles.first, tRex);
      // if (!hasCollision) {
      //   if (currentSpeed < GameConfig.maxSpeed) {
      //     currentSpeed += GameConfig.acceleration;
      //   }
      // } else {
      //   doGameOver();
      // }
    }
  }

}


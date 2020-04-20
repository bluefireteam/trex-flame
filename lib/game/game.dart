import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/game.dart';
import 'package:trex/game/horizon/horizon.dart';
import 'package:trex/game/collision/collision_utils.dart';
import 'package:trex/game/game_config.dart';
import 'package:trex/game/game_over/game_over.dart';
import 'package:trex/game/t_rex/config.dart';
import 'package:trex/game/t_rex/t_rex.dart';

class Bg extends Component with Resizable {
  Bg();

  final Paint _paint = Paint()..color = const Color(0xffffffff);

  @override
  void render(Canvas c) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    c.drawRect(rect, _paint);
  }

  @override
  void update(double t) {}
}

enum TRexGameStatus { playing, waiting, gameOver }

class TRexGame extends BaseGame {
  TRexGame({Image spriteImage}) {
    tRex = TRex(spriteImage);
    horizon = Horizon(spriteImage);
    gameOverPanel = GameOverPanel(spriteImage);

    this..add(Bg())..add(horizon)..add(tRex)..add(gameOverPanel);
  }

  TRex tRex;
  Horizon horizon;
  GameOverPanel gameOverPanel;
  TRexGameStatus status = TRexGameStatus.waiting;

  double currentSpeed = GameConfig.speed;
  double timePlaying = 0.0;

  @override
  void onTap() {
    if (gameOver) {
      restart();
      return;
    }
    tRex.startJump(currentSpeed);
  }

  @override
  void update(double t) {
    tRex.update(t);
    horizon.updateWithSpeed(0.0, currentSpeed);

    if (gameOver) {
      return;
    }

    if (tRex.playingIntro && tRex.x >= TRexConfig.startXPos) {
      startGame();
    } else if (tRex.playingIntro) {
      horizon.updateWithSpeed(0.0, currentSpeed);
    }

    if (playing) {
      timePlaying += t;
      horizon.updateWithSpeed(t, currentSpeed);

      final obstacles = horizon.horizonLine.obstacleManager.components;
      final hasCollision =
          obstacles.isNotEmpty && checkForCollision(obstacles.first, tRex);
      if (!hasCollision) {
        if (currentSpeed < GameConfig.maxSpeed) {
          currentSpeed += GameConfig.acceleration;
        }
      } else {
        doGameOver();
      }
    }
  }

  void startGame() {
    tRex.status = TRexStatus.running;
    status = TRexGameStatus.playing;
    tRex.hasPlayedIntro = true;
  }

  bool get playing => status == TRexGameStatus.playing;

  bool get gameOver => status == TRexGameStatus.gameOver;

  void doGameOver() {
    gameOverPanel.visible = true;
    stop();
    tRex.status = TRexStatus.crashed;
  }

  void stop() {
    status = TRexGameStatus.gameOver;
  }

  void restart() {
    status = TRexGameStatus.playing;
    tRex.reset();
    horizon.reset();
    currentSpeed = GameConfig.speed;
    gameOverPanel.visible = false;
    timePlaying = 0.0;
  }
}

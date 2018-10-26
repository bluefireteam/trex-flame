import 'dart:ui';

import 'package:flame/game.dart';
import 'package:trex/game/Horizon/horizon.dart';
import 'package:trex/game/game_config.dart';
import 'package:trex/game/t_rex/config.dart';
import 'package:trex/game/t_rex/t_rex.dart';

enum TRexGameStatus { playing, waiting, gameOver }

class TRexGame extends BaseGame{

  TRex tRex;
  Horizon horizon;
  TRexGameStatus status = TRexGameStatus.waiting;

  double currentSpeed = GameConfig.speed;

  TRexGame({
    Image spriteImage
  }) {
    tRex = new TRex(spriteImage);
    horizon = new Horizon(spriteImage);

    this..add(tRex)
        ..add(horizon);
  }
  void onTap() {
    tRex.startJump(this.currentSpeed);
  }

  @override
  void update(double t) {
    tRex.update(t);
    horizon.updateWithSpeed(0.0, this.currentSpeed);

    if(tRex.playingIntro && tRex.x >= TRexConfig.startXPos ) {
      startGame();
    } else if (tRex.playingIntro) {
      horizon.updateWithSpeed(0.0, this.currentSpeed);
    }

    if(this.playing){
      horizon.updateWithSpeed(t, this.currentSpeed);
    }

    if (this.currentSpeed < GameConfig.maxSpeed) {
      this.currentSpeed += GameConfig.acceleration;
    }

  }

  void startGame () {
    tRex.status = TRexStatus.running;
    status = TRexGameStatus.playing;
    tRex.hasPlayedIntro = true;
  }



  bool get playing => status ==  TRexGameStatus.playing;
}



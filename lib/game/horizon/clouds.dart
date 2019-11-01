import 'dart:ui';

import 'package:flame/components/component.dart';
import 'package:flame/components/mixins/has_game_ref.dart';
import 'package:flame/components/mixins/resizable.dart';
import 'package:flame/components/mixins/tapable.dart';
import 'package:flame/sprite.dart';
import 'package:flame/components/composed_component.dart';

import 'package:trex/game/custom/util.dart';
import 'package:trex/game/horizon/config.dart';

class CloudManager extends PositionComponent
    with HasGameRef, Tapable, ComposedComponent, Resizable {

  CloudManager(this.spriteImage) : super();

  Image spriteImage;

  void updateWithSpeed(double t, double speed) {
    final double cloudSpeed = HorizonConfig.bgCloudSpeed / 1000 * t * speed;
    final int numClouds = components.length;

    if (numClouds > 0) {
      for (final c in components) {
        final cloud = c as Cloud;
        cloud.updateWithSpeed(t, cloudSpeed);
      }

      final lastCloud = components.last as Cloud;
      if (numClouds < HorizonConfig.maxClouds &&
          (HorizonDimensions.width / 2 - lastCloud.x) > lastCloud.cloudGap &&
          HorizonConfig.cloudFrequency > rnd.nextDouble()) {
        addCloud();
      }
    } else {
      addCloud();
    }
  }

  void addCloud() {
    final cloud = Cloud(spriteImage);
    cloud.x = HorizonDimensions.width / 2;
    cloud.y = (y / 2 - (CloudConfig.maxSkyLevel - CloudConfig.minSkyLevel)) +
        getRandomNum(CloudConfig.minSkyLevel, CloudConfig.maxSkyLevel);
    components.add(cloud);
  }

  void reset() {
    components.clear();
  }
}

class Cloud extends SpriteComponent with Resizable {

  Cloud(Image spriteImage)
      : cloudGap =
            getRandomNum(CloudConfig.minCloudGap, CloudConfig.maxCloudGap),
        super.fromSprite(
          CloudConfig.width,
          CloudConfig.height,
          Sprite.fromImage(
            spriteImage,
            width: CloudConfig.width,
            height: CloudConfig.height,
            y: 2.0,
            x: 166.0,
          ),
        );

  final double cloudGap;
  bool toRemove = false;

  @override
  void update(double t) {}
  void updateWithSpeed(double t, double speed) {
    if (toRemove) {
      return;
    }
    x -= speed.ceil() * 50 * t;

    if (!isVisible) {
      toRemove = true;
    }
  }

  @override
  bool destroy() {
    return toRemove;
  }

  bool get isVisible {
    return x + CloudConfig.width > 0;
  }

  @override
  void resize(Size size) {
    y = (y / 2 - (CloudConfig.maxSkyLevel - CloudConfig.minSkyLevel)) +
        getRandomNum(CloudConfig.minSkyLevel, CloudConfig.maxSkyLevel);
  }
}

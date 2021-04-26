import 'package:flame/components.dart';
import 'package:flame/extensions.dart';
import 'package:flutter/foundation.dart';

@immutable
class CollisionBox {
  const CollisionBox({
    required this.position,
    required this.size,
  });

  factory CollisionBox.from(CollisionBox otherCollisionBox) {
    return CollisionBox(
      position: otherCollisionBox.position,
      size: otherCollisionBox.size,
    );
  }

  final Vector2 position;
  final Vector2 size;

  Rect toRect() {
    return Rect.fromLTWH(position.x, position.y, size.x, size.y);
  }

  @override
  String toString() {
    return 'position: $position; size: $size';
  }
}

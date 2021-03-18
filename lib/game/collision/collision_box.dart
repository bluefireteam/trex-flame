import 'package:flame/components.dart';

class CollisionBox {
  const CollisionBox({
    required this.position,
    required this.size,
  });

  final Vector2 position;
  final Vector2 size;
}

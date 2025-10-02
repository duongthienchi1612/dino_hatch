import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart' as material;
import 'detail/dino_detail.dart';
import 'package:flame/game.dart';

class SanctuaryGame extends FlameGame with HasCollisionDetection {
  @override
  Color backgroundColor() => const Color(0xFF0B1020);

  @override
  Future<void> onLoad() async {
    // Ensure we don't prepend 'assets/images' to our explicit asset paths
    images.prefix = '';
  }

  // Adjust this based on your sprite art orientation.
  // If your frames face RIGHT by default, set to true.
  // If your frames face LEFT by default, set to false.
  final bool spritesFaceRightByDefault = false;

  Future<void> spawnFromFrames(
    List<String> frames,
    bool isFly,
    Vector2 pos, {
    double stepTime = 0.12,
    double scale = 1.0,
  }) async {
    final SpriteAnimation anim = await _buildAnimation(frames, stepTime: stepTime);
    final _Walker dino = _Walker(animation: anim, isFly: isFly, faceRightByDefault: spritesFaceRightByDefault)
      ..position = pos
      ..anchor = Anchor.center
      ..scale = Vector2.all(scale);
    dino.onTap = () {
      material.showDialog(context: buildContext!, builder: (context) => const DinoDetail());
    };
    add(dino);
  }

  Future<SpriteAnimation> _buildAnimation(List<String> frames, {double stepTime = 0.1}) async {
    final List<Sprite> sprites = <Sprite>[];
    for (final String p in frames) {
      final image = await images.load(p);
      sprites.add(Sprite(image));
    }
    return SpriteAnimation.spriteList(sprites, stepTime: stepTime);
  }
}

class _Walker extends SpriteAnimationComponent with HasGameRef<SanctuaryGame>, TapCallbacks {
  final bool isFly;
  final bool faceRightByDefault;
  VoidCallback? onTap;
  _Walker({required SpriteAnimation animation, required this.isFly, required this.faceRightByDefault})
    : super(animation: animation, size: Vector2(96, 96));

  double speed = 60; // px/s

  @override
  void update(double dt) {
    super.update(dt);
    // If sprites face right by default, positive scale means facing right.
    // If sprites face left by default, positive scale means facing left, so invert.
    final int facing = scale.x >= 0 ? 1 : -1;
    final int moveSign = faceRightByDefault ? facing : -facing;
    position.x += speed * moveSign * dt;
    // bounce within viewport
    const double left = 16;
    final double right = (gameRef.size.x - 16).clamp(100, double.infinity);
    if (position.x > right && ((faceRightByDefault && scale.x > 0) || (!faceRightByDefault && scale.x < 0))) {
      position.x = right;
      scale.x = -scale.x; // turn
    } else if (position.x < left && ((faceRightByDefault && scale.x < 0) || (!faceRightByDefault && scale.x > 0))) {
      position.x = left;
      scale.x = -scale.x; // turn
    }
    // hover a bit if fly
    if (isFly) {
      position.y += (moveSign == 1 ? -1 : 1) * 10 * dt;
    }
  }

  @override
  void onTapDown(TapDownEvent event) {
    onTap?.call();
  }
}

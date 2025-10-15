import 'package:dino_hatch/utilities/router.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: GameWidget(game: HomeGame(context)));
  }
}

class HomeGame extends FlameGame with TapCallbacks {
  final BuildContext context;

  HomeGame(this.context);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Background
    final background = SpriteComponent()
      ..sprite = await loadSprite('home_background.png')
      ..size = size
      ..position = Vector2.zero()
      ..anchor = Anchor.topLeft;
    add(background);

    final w = size.x;
    final h = size.y;

    // Challenge button (DNA Map)
    add(
      ShapeButtonComponent.circle(
        position: Vector2(w * 0.50, h * 0.27),
        radius: w * 0.115,
        onTap: () => context.go(Routes.dnaMap),
      ),
    );

    // Hatchery button
    add(
      ShapeButtonComponent.ellipse(
        position: Vector2(w * 0.295, h * 0.7),
        widthRadius: w * 0.115,
        heightRadius: h * 0.17,
        onTap: () => _comingSoon(context),
      ),
    );

    // Sanctuary button
    add(
      ShapeButtonComponent.ellipse(
        position: Vector2(w * 0.705, h * 0.70),
        widthRadius: w * 0.12,
        heightRadius: h * 0.17,
        onTap: () => context.go(Routes.sanctuary),
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Sắp ra mắt!')));
  }
}

class ShapeButtonComponent extends PositionComponent with TapCallbacks, HasGameRef<HomeGame> {
  final double widthRadius;
  final double heightRadius;
  final VoidCallback onTap;

  ShapeButtonComponent.circle({required Vector2 position, required double radius, required this.onTap})
    : widthRadius = radius,
      heightRadius = radius {
    this.position = position;
    size = Vector2.all(radius * 2);
    anchor = Anchor.center;
  }

  ShapeButtonComponent.ellipse({
    required Vector2 position,
    required this.widthRadius,
    required this.heightRadius,
    required this.onTap,
  }) {
    this.position = position;
    size = Vector2(widthRadius * 2, heightRadius * 2);
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent event) {
    final p = event.localPosition;
    final cx = size.x / 2;
    final cy = size.y / 2;
    final dx = p.x - cx;
    final dy = p.y - cy;
    final normalized = (dx * dx) / (widthRadius * widthRadius) + (dy * dy) / (heightRadius * heightRadius);
    if (normalized <= 1) onTap();
    return true;
  }

  @override
  void render(Canvas canvas) {
    // final paint = Paint()..color = Colors.red.withOpacity(0.3);
    // canvas.drawOval(Rect.fromLTWH(0, 0, size.x, size.y), paint);
  }
}

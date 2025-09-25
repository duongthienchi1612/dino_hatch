import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:go_router/go_router.dart';
import 'dart:convert';
import 'package:dino_hatch/app/router.dart';
import 'sanctuary_game.dart';

class SanctuaryScreen extends StatelessWidget {
  const SanctuaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final SanctuaryGame game = SanctuaryGame();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khu bảo tồn'),
        actions: <Widget>[
          TextButton(
            onPressed: () => context.go(Routes.home),
            child: const Text('Home', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      body: FutureBuilder<Map<String, List<String>>>(
        future: _scanSprites(),
        builder: (context, snapshot) {
          return Row(
            children: <Widget>[
              Expanded(
                child: DragTarget<_SpriteBundle>(
                  onWillAccept: (data) => true,
                  onAcceptWithDetails: (details) async {
                    final bundle = details.data;
                    final isFly = bundle.frames.first.contains('/fly_');
                    // Convert global drop offset to local coordinates of this DragTarget
                    final RenderBox box = context.findRenderObject() as RenderBox;
                    final Offset local = box.globalToLocal(details.offset);
                    final Vector2 pos = Vector2(local.dx, local.dy);
                    await game.spawnFromFrames(bundle.frames, isFly, pos);
                  },
                  builder: (context, candidate, rejected) {
                    return GameWidget(game: game);
                  },
                ),
              ),
              Container(
                width: 220,
                color: Colors.black26,
                child: snapshot.hasData
                    ? _SpritePanel(sprites: snapshot.data!)
                    : const Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<Map<String, List<String>>> _scanSprites() async {
    final String raw = await rootBundle.loadString('AssetManifest.json');
    if (raw.isEmpty) return <String, List<String>>{};
    final Map<String, dynamic> manifest = Map<String, dynamic>.from(
        (await Future<Map<String, dynamic>>.value(
            Map<String, dynamic>.from(jsonDecode(raw) as Map))));
    final Map<String, List<String>> byFolder = <String, List<String>>{};
    final RegExp kind = RegExp(r'\/(walk|walking|fly)_', caseSensitive: false);
    for (final String path in manifest.keys) {
      if (path.startsWith('assets/sprites/') &&
          kind.hasMatch(path) &&
          path.toLowerCase().endsWith('.png')) {
        final String folder = path.substring(0, path.lastIndexOf('/'));
        byFolder.putIfAbsent(folder, () => <String>[]).add(path);
      }
    }
    for (final List<String> v in byFolder.values) {
      v.sort();
    }
    return byFolder;
  }
}

class _SpritePanel extends StatelessWidget {
  final Map<String, List<String>> sprites;
  const _SpritePanel({required this.sprites});

  @override
  Widget build(BuildContext context) {
    final entries = sprites.entries.toList()
      ..sort((a, b) => a.key.compareTo(b.key));
    return ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) {
        final e = entries[index];
        final name = e.key.split('/').reversed.first;
        final preview = e.value.first;
        return ListTile(
          leading: Draggable<_SpriteBundle>(
            data: _SpriteBundle(frames: e.value),
            feedback: Opacity(
              opacity: 0.85,
              child: Image.asset(preview, width: 64, height: 64, fit: BoxFit.contain),
            ),
            childWhenDragging: Opacity(
              opacity: 0.4,
              child: Image.asset(preview, width: 40, height: 40, fit: BoxFit.contain),
            ),
            child: Image.asset(preview, width: 40, height: 40, fit: BoxFit.contain),
          ),
          title: Text(name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Text('${e.value.length} frames'),
          trailing: Draggable<_SpriteBundle>(
            data: _SpriteBundle(frames: e.value),
            feedback: Opacity(
              opacity: 0.85,
              child: Image.asset(preview, width: 64, height: 64, fit: BoxFit.contain),
            ),
            childWhenDragging: const Icon(Icons.drag_indicator, color: Colors.white38),
            child: const Icon(Icons.drag_indicator),
          ),
        );
      },
    );
  }
}

class _SpriteBundle {
  final List<String> frames;
  const _SpriteBundle({required this.frames});
}



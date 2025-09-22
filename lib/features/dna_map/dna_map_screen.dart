import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DnaMapScreen extends StatelessWidget {
  const DnaMapScreen({super.key});

  static const int levelsPerEra = 50;
  static const List<String> eras = <String>['Triassic', 'Jurassic', 'Cretaceous'];

  @override
  Widget build(BuildContext context) {
    final List<_LevelNode> nodes = <_LevelNode>[];
    int globalIndex = 0;
    for (final String era in eras) {
      for (int i = 1; i <= levelsPerEra; i++) {
        nodes.add(_LevelNode(era: era, level: i, index: globalIndex));
        globalIndex++;
      }
      globalIndex += 4; // gap
    }

    // serpentine positions
    const double step = 120;
    const double rowHeight = 160;
    final List<Offset> positions = <Offset>[];
    for (int i = 0; i < nodes.length; i++) {
      final int row = i ~/ 8;
      final int colInRow = i % 8;
      final bool reverse = row.isOdd;
      final int col = reverse ? 7 - colInRow : colInRow;
      final double x = 80 + col * step;
      final double y = 120 + row * rowHeight + sin(i / 2) * 12;
      positions.add(Offset(x, y));
    }

    final double contentWidth = (positions.isNotEmpty ? positions.last.dx : 120) + 220;
    final double contentHeight = 800;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Thu thập DNA – Bản đồ level'),
        actions: <Widget>[
          TextButton.icon(
            onPressed: () => context.go('/home'),
            icon: const Icon(Icons.home, color: Colors.white70),
            label: const Text('Home', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0B1020), Color(0xFF151E36)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: InteractiveViewer(
          constrained: false,
          boundaryMargin: const EdgeInsets.all(200),
          minScale: 0.75,
          maxScale: 2.0,
          child: SizedBox(
            width: contentWidth,
            height: contentHeight,
            child: Stack(
              children: <Widget>[
                CustomPaint(
                  size: Size(contentWidth, contentHeight),
                  painter: _MapPathPainter(points: positions),
                ),
                ..._buildEraMarkers(nodes, positions),
                ...List<Widget>.generate(nodes.length, (int i) {
                  final _LevelNode node = nodes[i];
                  final Offset p = positions[i];
                  return Positioned(
                    left: p.dx - 22,
                    top: p.dy - 22,
                    child: _LevelDot(
                      node: node,
                      onTap: () => context.go('/game/${node.era}/${node.level}'),
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildEraMarkers(List<_LevelNode> nodes, List<Offset> pos) {
    final List<Widget> markers = <Widget>[];
    for (int i = 0; i < nodes.length; i++) {
      if (nodes[i].level == 1) {
        final Offset p = pos[i];
        markers.add(Positioned(
          left: p.dx - 60,
          top: p.dy - 90,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white24),
            ),
            child: Text(nodes[i].era, style: const TextStyle(fontSize: 14)),
          ),
        ));
      }
    }
    return markers;
  }
}

class _LevelNode {
  final String era;
  final int level;
  final int index;
  const _LevelNode({required this.era, required this.level, required this.index});
}

class _LevelDot extends StatelessWidget {
  final _LevelNode node;
  final VoidCallback onTap;
  const _LevelDot({required this.node, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.amber.shade400,
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, 4)),
          ],
          border: Border.all(color: Colors.white24),
        ),
        alignment: Alignment.center,
        child: Text('${node.level}', style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}

class _MapPathPainter extends CustomPainter {
  final List<Offset> points;
  const _MapPathPainter({required this.points});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint pathPaint = Paint()
      ..color = const Color(0xFF2E3F6E)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final Path path = Path();
    if (points.isNotEmpty) {
      path.moveTo(points.first.dx, points.first.dy);
    }
    for (int i = 1; i < points.length; i++) {
      final Offset p0 = points[i - 1];
      final Offset p1 = points[i];
      final Offset mid = Offset((p0.dx + p1.dx) / 2, (p0.dy + p1.dy) / 2);
      path.quadraticBezierTo(p0.dx, p0.dy, mid.dx, mid.dy);
      path.quadraticBezierTo(mid.dx, mid.dy, p1.dx, p1.dy);
    }
    canvas.drawPath(path, pathPaint);
  }

  @override
  bool shouldRepaint(covariant _MapPathPainter oldDelegate) => true;
}



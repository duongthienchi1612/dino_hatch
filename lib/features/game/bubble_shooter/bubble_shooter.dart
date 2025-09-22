import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// CONFIG
const int gridCols = 9;
const int gridRows = 12;
const double cellSize = 40.0;
const double bubbleRadius = cellSize * 0.5;
const List<Color> palette = <Color>[
  Colors.red,
  Colors.green,
  Colors.blue,
  Colors.orange,
  Colors.purple,
  Colors.yellow,
];

class BubbleShooterGame extends StatefulWidget {
  const BubbleShooterGame({super.key});

  @override
  State<BubbleShooterGame> createState() => _BubbleShooterGameState();
}

class _BubbleShooterGameState extends State<BubbleShooterGame>
    with SingleTickerProviderStateMixin {
  final Random _rand = Random();

  late List<List<Bubble?>> grid;
  Bubble? activeBubble;
  Offset _shooterPosition = Offset.zero;
  Offset? _projectilePosition;
  Offset? _projectileVelocity;
  Bubble? _nextBubble;
  late Ticker _ticker;

  // Centered playfield dimensions and offset
  late double _fieldWidth;
  double _fieldOffsetX = 0;

  List<int>? _lastPlacedCell; // [row, col]
  late List<List<Bubble?>> _lastKnownGridState =
      List<List<Bubble?>>.generate(
          gridRows, (int r) => List<Bubble?>.generate(gridCols, (int c) => null));

  double _aimAngle = -pi / 2; // up

  @override
  void initState() {
    super.initState();
    _initGrid();
    _spawnNewBubbles();
    _ticker = createTicker(_onTick)..start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  void _initGrid() {
    grid = List<List<Bubble?>>.generate(
      gridRows,
      (int r) => List<Bubble?>.generate(gridCols, (int c) => null),
    );
    for (int r = 0; r < 5; r++) {
      for (int c = 0; c < gridCols; c++) {
        grid[r][c] = Bubble(color: palette[_rand.nextInt(palette.length)]);
      }
    }
  }

  void _spawnNewBubbles() {
    activeBubble = Bubble(color: palette[_rand.nextInt(palette.length)]);
    _nextBubble = Bubble(color: palette[_rand.nextInt(palette.length)]);
    _projectilePosition = null;
    _projectileVelocity = null;
  }

  void _onTick(Duration elapsed) {
    const double dt = 1 / 60;
    if (_projectilePosition != null && _projectileVelocity != null) {
      setState(() {
        _projectilePosition = _projectilePosition! + _projectileVelocity! * dt;
        // Left wall at fieldOffsetX
        if (_projectilePosition!.dx - bubbleRadius <= _fieldOffsetX &&
            _projectileVelocity!.dx < 0) {
          _projectileVelocity =
              Offset(-_projectileVelocity!.dx, _projectileVelocity!.dy);
        }
        // Right wall at fieldOffsetX + fieldWidth
        if (_projectilePosition!.dx + bubbleRadius >=
                _fieldOffsetX + _fieldWidth &&
            _projectileVelocity!.dx > 0) {
          _projectileVelocity =
              Offset(-_projectileVelocity!.dx, _projectileVelocity!.dy);
        }
        if (_projectilePosition!.dy - bubbleRadius <= 0) {
          _snapProjectileToGrid();
          return;
        }
        for (int r = 0; r < gridRows; r++) {
          for (int c = 0; c < gridCols; c++) {
            final Bubble? b = grid[r][c];
            if (b == null) continue;
            final Offset center = _gridCellCenter(r, c);
            final double dist = (_projectilePosition! - center).distance;
            if (dist <= bubbleRadius * 2 - 2) {
              _snapProjectileNear(r, c);
              return;
            }
          }
        }
        if (_projectilePosition!.dy > gridRows * cellSize + 100) {
          _projectilePosition = null;
          _projectileVelocity = null;
          _consumeActiveAndPrepareNext();
        }
      });
    }
  }

  Offset _gridCellCenter(int row, int col) {
    final double xOffset =
        _fieldOffsetX + (col + 0.5) * cellSize + (row.isOdd ? cellSize * 0.5 : 0);
    final double yOffset = (row + 0.5) * cellSize;
    return Offset(xOffset, yOffset);
  }

  void _snapProjectileToGrid() {
    if (_projectilePosition == null) return;
    final List<_CellDist> candidates = <_CellDist>[];
    for (int r = 0; r < gridRows; r++) {
      for (int c = 0; c < gridCols; c++) {
        if (grid[r][c] != null) continue;
        final Offset center = _gridCellCenter(r, c);
        final double d = (center - _projectilePosition!).distance;
        candidates.add(_CellDist(r, c, d));
      }
    }
    if (candidates.isEmpty) {
      final double localX = _projectilePosition!.dx - _fieldOffsetX;
      final int col = (localX ~/ cellSize).clamp(0, gridCols - 1);
      int row = 0;
      while (row < gridRows && grid[row][col] != null) {
        row++;
      }
      if (row < gridRows) {
        setState(() => grid[row][col] = activeBubble);
        _lastPlacedCell = <int>[row, col];
      }
    } else {
      candidates.sort((a, b) => a.dist.compareTo(b.dist));
      setState(() {
        grid[candidates.first.row][candidates.first.col] = activeBubble;
        _lastPlacedCell = <int>[candidates.first.row, candidates.first.col];
      });
    }
    _projectilePosition = null;
    _projectileVelocity = null;
    _afterPlaceProcess();
  }

  void _snapProjectileNear(int hitRow, int hitCol) {
    if (_projectilePosition == null) return;
    final List<List<int>> neighbors = _neighbors(hitRow, hitCol);
    final List<_CellDist> candidates = <_CellDist>[];
    for (final List<int> n in neighbors) {
      final int r = n[0];
      final int c = n[1];
      if (r < 0 || c < 0 || r >= gridRows || c >= gridCols) continue;
      if (grid[r][c] != null) continue;
      final Offset center = _gridCellCenter(r, c);
      final double d = (center - _projectilePosition!).distance;
      candidates.add(_CellDist(r, c, d));
    }
    if (candidates.isEmpty) {
      final int r = hitRow - 1;
      final int c = hitCol;
      if (r >= 0 && grid[r][c] == null) {
        setState(() => grid[r][c] = activeBubble);
        _lastPlacedCell = <int>[r, c];
      } else {
        _snapProjectileToGrid();
        return;
      }
    } else {
      candidates.sort((a, b) => a.dist.compareTo(b.dist));
      setState(() {
        grid[candidates.first.row][candidates.first.col] = activeBubble;
        _lastPlacedCell = <int>[candidates.first.row, candidates.first.col];
      });
    }
    _projectilePosition = null;
    _projectileVelocity = null;
    _afterPlaceProcess();
  }

  List<List<int>> _neighbors(int r, int c) {
    if (r.isEven) {
      return <List<int>>[
        <int>[r, c - 1],
        <int>[r, c + 1],
        <int>[r - 1, c],
        <int>[r - 1, c - 1],
        <int>[r + 1, c],
        <int>[r + 1, c - 1],
      ];
    } else {
      return <List<int>>[
        <int>[r, c - 1],
        <int>[r, c + 1],
        <int>[r - 1, c],
        <int>[r - 1, c + 1],
        <int>[r + 1, c],
        <int>[r + 1, c + 1],
      ];
    }
  }

  void _afterPlaceProcess() {
    final List<List<int>> cluster = _floodFillSameColorFromLastPlaced();
    if (cluster.length >= 3) {
      setState(() {
        for (final List<int> p in cluster) {
          grid[p[0]][p[1]] = null;
        }
      });
      _dropFloatingClusters();
    }
    _consumeActiveAndPrepareNext();
  }

  List<List<int>> _floodFillSameColorFromLastPlaced() {
    final List<int>? placed = _lastPlacedCell;
    if (placed == null) return <List<int>>[];
    final int r0 = placed[0];
    final int c0 = placed[1];
    final Bubble? target = grid[r0][c0];
    if (target == null) return <List<int>>[];
    final Color color = target.color;
    final List<List<bool>> visited = List<List<bool>>.generate(
        gridRows, (int _) => List<bool>.generate(gridCols, (int __) => false));
    final List<List<int>> result = <List<int>>[];
    final List<List<int>> stack = <List<int>>[];
    stack.add(<int>[r0, c0]);
    visited[r0][c0] = true;
    while (stack.isNotEmpty) {
      final List<int> cur = stack.removeLast();
      result.add(cur);
      for (final List<int> n in _neighbors(cur[0], cur[1])) {
        final int nr = n[0];
        final int nc = n[1];
        if (nr < 0 || nc < 0 || nr >= gridRows || nc >= gridCols) continue;
        if (visited[nr][nc]) continue;
        final Bubble? nb = grid[nr][nc];
        if (nb == null) continue;
        if (nb.color == color) {
          visited[nr][nc] = true;
          stack.add(<int>[nr, nc]);
        }
      }
    }
    return result;
  }

  void _dropFloatingClusters() {
    final List<List<bool>> visited = List<List<bool>>.generate(
        gridRows, (int _) => List<bool>.generate(gridCols, (int __) => false));
    final List<List<int>> stack = <List<int>>[];
    for (int c = 0; c < gridCols; c++) {
      if (grid[0][c] != null) {
        visited[0][c] = true;
        stack.add(<int>[0, c]);
      }
    }
    while (stack.isNotEmpty) {
      final List<int> cur = stack.removeLast();
      for (final List<int> n in _neighbors(cur[0], cur[1])) {
        final int nr = n[0];
        final int nc = n[1];
        if (nr < 0 || nc < 0 || nr >= gridRows || nc >= gridCols) continue;
        if (visited[nr][nc]) continue;
        if (grid[nr][nc] != null) {
          visited[nr][nc] = true;
          stack.add(<int>[nr, nc]);
        }
      }
    }
    final List<List<int>> toRemove = <List<int>>[];
    for (int r = 0; r < gridRows; r++) {
      for (int c = 0; c < gridCols; c++) {
        if (grid[r][c] != null && !visited[r][c]) {
          toRemove.add(<int>[r, c]);
        }
      }
    }
    if (toRemove.isNotEmpty) {
      setState(() {
        for (final List<int> p in toRemove) {
          grid[p[0]][p[1]] = null;
        }
      });
    }
  }

  void _consumeActiveAndPrepareNext() {
    for (int r = 0; r < gridRows; r++) {
      for (int c = 0; c < gridCols; c++) {
        _lastKnownGridState[r][c] = grid[r][c] != null ? grid[r][c]!.copy() : null;
      }
    }
    activeBubble = _nextBubble;
    _nextBubble = Bubble(color: palette[_rand.nextInt(palette.length)]);
  }

  void _onPanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    final Offset local = details.localPosition;
    final Offset center = Offset(
      _fieldOffsetX + _fieldWidth / 2,
      constraints.maxHeight - 40,
    );
    final double angle = (local - center).direction;
    setState(() => _aimAngle = angle);
  }

  void _onTapShoot(BoxConstraints constraints) {
    if (activeBubble == null) return;
    if (_projectilePosition != null) return;
    final Offset center = Offset(
      _fieldOffsetX + _fieldWidth / 2,
      constraints.maxHeight - 40,
    );
    const double speed = 700.0;
    final double vx = cos(_aimAngle) * speed;
    final double vy = sin(_aimAngle) * speed;
    setState(() {
      _projectilePosition = center;
      _projectileVelocity = Offset(vx, vy);
    });
  }

  void _onTapDownSetAim(TapDownDetails details, BoxConstraints constraints) {
    final Offset local = details.localPosition;
    final Offset center = Offset(
      _fieldOffsetX + _fieldWidth / 2,
      constraints.maxHeight - 40,
    );
    final double angle = (local - center).direction;
    setState(() => _aimAngle = angle);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints cons) {
      _fieldWidth = gridCols * cellSize + cellSize * 0.5;
      _fieldOffsetX = (cons.maxWidth - _fieldWidth) / 2;
      _shooterPosition =
          Offset(_fieldOffsetX + _fieldWidth / 2, cons.maxHeight - 40);
      return GestureDetector(
        onPanUpdate: (DragUpdateDetails d) => _onPanUpdate(d, cons),
        onTapDown: (TapDownDetails d) => _onTapDownSetAim(d, cons),
        onTap: () => _onTapShoot(cons),
        child: Stack(
          children: <Widget>[
            CustomPaint(
              size: Size(cons.maxWidth, cons.maxHeight),
              painter: _GamePainter(
                grid: grid,
                cellSize: cellSize,
                bubbleRadius: bubbleRadius,
                gridCellCenter: _gridCellCenter,
                projectilePos: _projectilePosition,
                projectileBubble: activeBubble,
                shooterPos: _shooterPosition,
                aimAngle: _aimAngle,
                nextBubble: _nextBubble,
                fieldOffsetX: _fieldOffsetX,
                fieldWidth: _fieldWidth,
              ),
            ),
            Positioned(
              left: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _hudBox('Next', child: _bubbleIcon(_nextBubble)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _hudBox(String title, {required Widget child}) {
    return Column(
      children: <Widget>[
        Text(title),
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.black45,
          ),
          child: child,
        ),
      ],
    );
  }

  Widget _bubbleIcon(Bubble? b) {
    if (b == null) return const SizedBox(width: 40, height: 40);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle, color: b.color),
    );
  }
}

class _GamePainter extends CustomPainter {
  final List<List<Bubble?>> grid;
  final double cellSize;
  final double bubbleRadius;
  final Offset Function(int row, int col) gridCellCenter;
  final Offset? projectilePos;
  final Bubble? projectileBubble;
  final Offset shooterPos;
  final double aimAngle;
  final Bubble? nextBubble;
  final double fieldOffsetX;
  final double fieldWidth;

  _GamePainter({
    required this.grid,
    required this.cellSize,
    required this.bubbleRadius,
    required this.gridCellCenter,
    required this.projectilePos,
    required this.projectileBubble,
    required this.shooterPos,
    required this.aimAngle,
    required this.nextBubble,
    required this.fieldOffsetX,
    required this.fieldWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bg = Paint()..color = const Color(0xFF0B1020);
    canvas.drawRect(Offset.zero & size, bg);

    for (int r = 0; r < grid.length; r++) {
      for (int c = 0; c < grid[r].length; c++) {
        final Offset center = gridCellCenter(r, c);
        final Bubble? b = grid[r][c];
        if (b != null) {
          _drawBubble(canvas, center, b.color);
        }
      }
    }

    if (projectilePos != null && projectileBubble != null) {
      _drawBubble(canvas, projectilePos!, projectileBubble!.color, scale: 1.0);
    }

    final Paint shooterPaint = Paint()..color = Colors.grey.shade800;
    canvas.drawRect(
      Rect.fromCenter(center: shooterPos, width: 100, height: 20),
      shooterPaint,
    );

    final Offset aimEnd =
        shooterPos + Offset(cos(aimAngle), sin(aimAngle)) * 80;
    final Paint aimPaint = Paint()
      ..color = Colors.white24
      ..strokeWidth = 2;
    canvas.drawLine(shooterPos, aimEnd, aimPaint);

    // Side pillars at field boundaries
    final double top = 0;
    final double bottom = size.height;
    final Rect leftPillar = Rect.fromLTWH(fieldOffsetX - 8, top, 16, bottom);
    final Rect rightPillar =
        Rect.fromLTWH(fieldOffsetX + fieldWidth - 8, top, 16, bottom);
    final Paint pillarPaint = Paint()..color = const Color(0xFF2A2F45);
    final Paint pillarEdge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.black54;
    canvas.drawRRect(
        RRect.fromRectAndRadius(leftPillar, const Radius.circular(6)),
        pillarPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(leftPillar, const Radius.circular(6)),
        pillarEdge);
    canvas.drawRRect(
        RRect.fromRectAndRadius(rightPillar, const Radius.circular(6)),
        pillarPaint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(rightPillar, const Radius.circular(6)),
        pillarEdge);

    if (projectileBubble != null) {
      _drawBubble(
        canvas,
        shooterPos + const Offset(0, -60),
        projectileBubble!.color,
        scale: 0.9,
      );
    }
  }

  void _drawBubble(Canvas canvas, Offset center, Color color,
      {double scale = 1.0}) {
    final double r = bubbleRadius * scale;
    final Paint p = Paint()
      ..shader = RadialGradient(
        colors: <Color>[color.withOpacity(0.95), color.withOpacity(0.7)],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, p);
    final Paint edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black26;
    canvas.drawCircle(center, r, edge);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class Bubble {
  final Color color;
  Bubble({required this.color});

  Bubble copy() => Bubble(color: color);
}

class _CellDist {
  final int row;
  final int col;
  final double dist;
  _CellDist(this.row, this.col, this.dist);
}



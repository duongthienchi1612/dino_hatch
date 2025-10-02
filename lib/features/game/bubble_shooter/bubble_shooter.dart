import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dino_hatch/features/game/bloc/game_cubit.dart';
import 'package:dino_hatch/features/game/bloc/game_state.dart';

// CONFIG
const int gridCols = 9;
const int gridRows = 12;
const double cellSize = 40.0;
const double bubbleRadius = cellSize * 0.5;
const List<Color> palette = <Color>[
  Color(0xFFE53935), // placeholders mapping for color-index
  Color(0xFF43A047),
  Color(0xFF1E88E5),
  Color(0xFFFB8C00),
  Color(0xFF8E24AA),
  Color(0xFFFDD835),
];

const List<String> eggAssets = <String>[
  'assets/eggs/egg_1.png',
  'assets/eggs/egg_2.png',
  'assets/eggs/egg_3.png',
  'assets/eggs/egg_4.png',
  'assets/eggs/egg_5.png',
  'assets/eggs/egg_6.png',
];

enum LevelWinMode { clearAll, dropObstacles }

class LevelConfig {
  final LevelWinMode winMode;
  final int obstacleCount;
  final List<Point<int>>? obstacles;
  const LevelConfig({this.winMode = LevelWinMode.clearAll, this.obstacleCount = 0, this.obstacles});
}

class BubbleShooterGame extends StatefulWidget {
  final LevelConfig config;
  final VoidCallback? onWin;
  const BubbleShooterGame({super.key, this.config = const LevelConfig(), this.onWin});

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
  Bubble? _projectileBubble;
  Bubble? _nextBubble;
  late Ticker _ticker;
  List<ui.Image>? _eggImages;
  final Set<Point<int>> _obstacles = <Point<int>>{};
  bool _won = false;

  // Centered playfield dimensions and offset
  late double _fieldWidth;
  double _fieldOffsetX = 0;

  List<int>? _lastPlacedCell; // [row, col]
  late List<List<Bubble?>> _lastKnownGridState =
      List<List<Bubble?>>.generate(
          gridRows, (int r) => List<Bubble?>.generate(gridCols, (int c) => null));

  double _aimAngle = -pi / 2; // up
  double _shootEffectT = 0.0; // muzzle flash decay 1->0

  @override
  void initState() {
    super.initState();
    _initGrid();
    _spawnNewBubbles();
    _ticker = createTicker(_onTick)..start();
    _loadEggImages();
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
    if (widget.config.obstacles != null && widget.config.obstacles!.isNotEmpty) {
      _obstacles.addAll(widget.config.obstacles!);
    } else if (widget.config.winMode == LevelWinMode.dropObstacles && widget.config.obstacleCount > 0) {
      final List<Point<int>> candidates = <Point<int>>[
        Point<int>(6, (gridCols / 2).floor()),
        Point<int>(7, (gridCols / 2).floor() - 2),
        Point<int>(7, (gridCols / 2).floor() + 2),
      ];
      int placed = 0;
      for (final Point<int> p in candidates) {
        if (placed >= widget.config.obstacleCount) break;
        if (p.x >= 0 && p.y >= 0 && p.x < gridRows && p.y < gridCols) {
          _obstacles.add(p);
          placed++;
        }
      }
    }
  }

  void _spawnNewBubbles() {
    // Initial values will come from Bloc
    final GameState gs = context.read<GameCubit>().state;
    activeBubble = gs.active != null ? Bubble(color: gs.active!) : Bubble(color: palette[_rand.nextInt(palette.length)]);
    _nextBubble = gs.next != null ? Bubble(color: gs.next!) : Bubble(color: palette[_rand.nextInt(palette.length)]);
    _projectilePosition = null;
    _projectileVelocity = null;
  }

  Future<void> _loadEggImages() async {
    final List<ui.Image> imgs = <ui.Image>[];
    for (final String path in eggAssets) {
      try {
        final ByteData data = await rootBundle.load(path);
        final ui.Codec codec =
            await ui.instantiateImageCodec(data.buffer.asUint8List());
        final ui.FrameInfo fi = await codec.getNextFrame();
        imgs.add(fi.image);
      } catch (_) {
        // ignore; fallback painter will draw circles
      }
    }
    if (mounted) {
      setState(() => _eggImages = imgs);
    }
  }

  void _onTick(Duration elapsed) {
    const double dt = 1 / 60;
    if (_projectilePosition != null && _projectileVelocity != null) {
      setState(() {
        _projectilePosition = _projectilePosition! + _projectileVelocity! * dt;
        if (_shootEffectT > 0) {
          _shootEffectT = (_shootEffectT - dt * 3).clamp(0.0, 1.0);
        }
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
            if (!_isCellOccupied(r, c)) continue;
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
          _projectileBubble = null;
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
      while (row < gridRows && _isCellOccupied(row, col)) {
        row++;
      }
      if (row < gridRows) {
        setState(() => grid[row][col] = _projectileBubble);
        context.read<GameCubit>().placeBubble(row, col, _projectileBubble!.color);
        _lastPlacedCell = <int>[row, col];
      }
    } else {
      candidates.sort((a, b) => a.dist.compareTo(b.dist));
      setState(() {
        grid[candidates.first.row][candidates.first.col] = _projectileBubble;
        context.read<GameCubit>().placeBubble(
            candidates.first.row, candidates.first.col, _projectileBubble!.color);
        _lastPlacedCell = <int>[candidates.first.row, candidates.first.col];
      });
    }
    _projectilePosition = null;
    _projectileVelocity = null;
    _projectileBubble = null;
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
      if (r >= 0 && !_isCellOccupied(r, c)) {
        setState(() => grid[r][c] = _projectileBubble);
        context.read<GameCubit>().placeBubble(r, c, _projectileBubble!.color);
        _lastPlacedCell = <int>[r, c];
      } else {
        _snapProjectileToGrid();
        return;
      }
    } else {
      candidates.sort((a, b) => a.dist.compareTo(b.dist));
      setState(() {
        grid[candidates.first.row][candidates.first.col] = _projectileBubble;
        context.read<GameCubit>().placeBubble(
            candidates.first.row, candidates.first.col, _projectileBubble!.color);
        _lastPlacedCell = <int>[candidates.first.row, candidates.first.col];
      });
    }
    _projectilePosition = null;
    _projectileVelocity = null;
    _projectileBubble = null;
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
      context.read<GameCubit>().clearCells(cluster);
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
      if (_isCellOccupied(0, c)) {
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
        if (_isCellOccupied(nr, nc)) {
          visited[nr][nc] = true;
          stack.add(<int>[nr, nc]);
        }
      }
    }
    final List<List<int>> toRemove = <List<int>>[];
    final List<Point<int>> droppedObstacles = <Point<int>>[];
    for (int r = 0; r < gridRows; r++) {
      for (int c = 0; c < gridCols; c++) {
        if (!_isCellOccupied(r, c)) continue;
        if (!visited[r][c]) {
          if (grid[r][c] != null) {
            toRemove.add(<int>[r, c]);
          }
          final Point<int> p = Point<int>(r, c);
          if (_obstacles.contains(p)) {
            droppedObstacles.add(p);
          }
        }
      }
    }
    if (toRemove.isNotEmpty || droppedObstacles.isNotEmpty) {
      setState(() {
        for (final List<int> p in toRemove) {
          grid[p[0]][p[1]] = null;
        }
        for (final Point<int> p in droppedObstacles) {
          _obstacles.remove(p);
        }
      });
    }
    _checkWin();
  }

  void _consumeActiveAndPrepareNext() {
    for (int r = 0; r < gridRows; r++) {
      for (int c = 0; c < gridCols; c++) {
        _lastKnownGridState[r][c] = grid[r][c] != null ? grid[r][c]!.copy() : null;
      }
    }
    // Do NOT shift active/next here. We already shifted when firing.
  }

  bool _isCellOccupied(int r, int c) {
    if (grid[r][c] != null) return true;
    return _obstacles.contains(Point<int>(r, c));
  }

  void _checkWin() {
    if (_won) return;
    if (widget.config.winMode == LevelWinMode.clearAll) {
      for (int r = 0; r < gridRows; r++) {
        for (int c = 0; c < gridCols; c++) {
          if (grid[r][c] != null) return;
        }
      }
      _won = true;
      widget.onWin?.call();
    } else {
      if (_obstacles.isEmpty) {
        _won = true;
        widget.onWin?.call();
      }
    }
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
      _projectileBubble = activeBubble;
      // shift via cubit to maintain single source of truth
      context.read<GameCubit>().onShootConsumedShift();
      final GameState gs = context.read<GameCubit>().state;
      activeBubble = gs.active != null ? Bubble(color: gs.active!) : null;
      _nextBubble = gs.next != null ? Bubble(color: gs.next!) : null;
      _shootEffectT = 1.0;
    });
    SystemSound.play(SystemSoundType.click);
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
                projectileBubble: _projectileBubble,
                shooterPos: _shooterPosition,
                aimAngle: _aimAngle,
                nextBubble: _nextBubble,
                fieldOffsetX: _fieldOffsetX,
                fieldWidth: _fieldWidth,
                activeBubble: activeBubble,
                shootEffectT: _shootEffectT,
                popEffects: const <_PopEffect>[],
                eggImages: _eggImages,
                obstacles: _obstacles,
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
    final String asset = _assetForColor(b.color);
    return SizedBox(
      width: 40,
      height: 40,
      child: Image.asset(
        asset,
        fit: BoxFit.contain,
        errorBuilder: (BuildContext context, Object error, StackTrace? stack) {
          return Container(
            decoration: BoxDecoration(shape: BoxShape.circle, color: b.color),
          );
        },
      ),
    );
  }

  String _assetForColor(Color color) {
    final int idx = _indexForColor(color);
    return eggAssets[idx];
  }

  int _indexForColor(Color color) {
    for (int i = 0; i < palette.length; i++) {
      if (palette[i].value == color.value) return i;
    }
    return 0;
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
  final Bubble? activeBubble;
  final double shootEffectT;
  final List<_PopEffect> popEffects;
  final List<ui.Image>? eggImages;
  final Set<Point<int>> obstacles;

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
    required this.activeBubble,
    required this.shootEffectT,
    required this.popEffects,
    required this.eggImages,
    required this.obstacles,
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

    // Draw obstacles
    for (final Point<int> obstacle in obstacles) {
      final Offset center = gridCellCenter(obstacle.x, obstacle.y);
      _drawObstacle(canvas, center);
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

    if (activeBubble != null) {
      _drawBubble(canvas, shooterPos + const Offset(0, -60), activeBubble!.color,
          scale: 0.9);
    }

    // Pop effects
    for (final _PopEffect e in popEffects) {
      final double rr = bubbleRadius * (1 + (1 - e.t) * 0.8);
      final Paint ring = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2 * e.t
        ..color = Colors.white.withOpacity(0.7 * e.t);
      canvas.drawCircle(e.center, rr, ring);
    }
  }

  void _drawBubble(Canvas canvas, Offset center, Color color,
      {double scale = 1.0}) {
    final int idx = _paletteIndex(color);
    final double size = bubbleRadius * 2 * scale;
    if (eggImages != null && eggImages!.length >= idx + 1) {
      final ui.Image img = eggImages![idx];
      final Rect dst = Rect.fromCenter(center: center, width: size, height: size);
      final Paint p = Paint();
      canvas.drawImageRect(
        img,
        Rect.fromLTWH(0, 0, img.width.toDouble(), img.height.toDouble()),
        dst,
        p,
      );
      return;
    }
    // Fallback circle if images not yet loaded
    final double r = bubbleRadius * scale;
    final Paint fallback = Paint()
      ..shader = RadialGradient(
        colors: <Color>[color.withOpacity(0.95), color.withOpacity(0.7)],
      ).createShader(Rect.fromCircle(center: center, radius: r));
    canvas.drawCircle(center, r, fallback);
    final Paint edge = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.black26;
    canvas.drawCircle(center, r, edge);
  }

  void _drawObstacle(Canvas canvas, Offset center) {
    final double size = bubbleRadius * 2;
    final Rect rect = Rect.fromCenter(center: center, width: size, height: size);
    
    // Draw main obstacle body (dark gray)
    final Paint obstaclePaint = Paint()..color = Colors.grey.shade700;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      obstaclePaint,
    );
    
    // Draw border
    final Paint borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.grey.shade500;
    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(8)),
      borderPaint,
    );
    
    // Draw X pattern inside
    final Paint xPaint = Paint()
      ..strokeWidth = 3
      ..color = Colors.grey.shade400;
    final double margin = size * 0.25;
    canvas.drawLine(
      Offset(rect.left + margin, rect.top + margin),
      Offset(rect.right - margin, rect.bottom - margin),
      xPaint,
    );
    canvas.drawLine(
      Offset(rect.right - margin, rect.top + margin),
      Offset(rect.left + margin, rect.bottom - margin),
      xPaint,
    );
  }

  int _paletteIndex(Color color) {
    for (int i = 0; i < palette.length; i++) {
      if (palette[i].value == color.value) return i;
    }
    return 0;
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

class _PopEffect {
  final Offset center;
  final double t; // 1 -> 0
  const _PopEffect({required this.center, required this.t});

  _PopEffect decayed(double dt) =>
      _PopEffect(center: center, t: (t - dt).clamp(0.0, 1.0));
}



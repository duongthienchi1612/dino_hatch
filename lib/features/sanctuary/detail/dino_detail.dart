import 'package:dino_hatch/flutter_cube/flutter_cube.dart';
import 'package:flutter/material.dart';

class DinoDetail extends StatefulWidget {
  const DinoDetail({super.key});

  @override
  State<DinoDetail> createState() => _DinoDetailState();
}

class _DinoDetailState extends State<DinoDetail> {
  void _onSceneCreated(Scene scene) {
    scene.camera.position.z = 10;
    scene.camera.target.y = 2;

    scene.world.add(Object(scale: Vector3(6.0, 6.0, 6.0), fileName: 'assets/cube/dino.obj'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(32),
        color: Colors.white,
        child: Stack(
          children: [
            Center(child: Cube(onSceneCreated: _onSceneCreated)),
            IconButton(onPressed: () {
              Navigator.of(context).pop();
            }, icon: const Icon(Icons.close)),
          ],
        ),
      ),
    );
  }
}

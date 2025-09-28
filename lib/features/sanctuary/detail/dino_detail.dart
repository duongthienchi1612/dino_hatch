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

    scene.world.add(Object(scale: Vector3(10.0, 10.0, 10.0), fileName: 'assets/cube/dino.obj'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: const EdgeInsets.all(32),
        color: Colors.white,
        child: Stack(
          alignment: Alignment.topRight,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Align(
                            alignment: Alignment.center,
                          child: Text('Coelophysis', style: Theme.of(context).textTheme.bodyLarge,)),
                          Text('🌍 Kỷ: Triassic (210 triệu năm trước)', style: Theme.of(context).textTheme.bodyLarge,),
                          Text('🍖/🌿 Type: Carnivore', style: Theme.of(context).textTheme.bodyLarge,),
                          Text('Kích cỡ: ~3m dài', style: Theme.of(context).textTheme.bodyLarge,),
                          Text('⚖️ Nặng: ~20kg', style: Theme.of(context).textTheme.bodyLarge,),
                          Text('Phát hiện tại Mỹ, 1881', style: Theme.of(context).textTheme.bodyLarge),
                          Text(
                            style: Theme.of(context).textTheme.bodyLarge,
                            'Coelophysis là một trong những loài khủng long ăn thịt đầu tiên được biết đến. Với thân hình nhỏ, nhẹ và nhanh nhẹn, chúng thường săn những con mồi nhỏ như bò sát, côn trùng, và thậm chí là đồng loại khi khan hiếm thức ăn. Đây là loài khủng long tiêu biểu cho giai đoạn sơ khai.',
                          ),
                           Text('💡 Fun fact: Hóa thạch Coelophysis thường được tìm thấy theo bầy lớn – có thể là bằng chứng của tập tính sống bầy đàn.', style: Theme.of(context).textTheme.bodyLarge),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 330,
                  // color: Colors.red,
                  child: Cube(onSceneCreated: _onSceneCreated),
                ),
              ],
            ),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.close),
            ),
          ],
        ),
      ),
    );
  }
}

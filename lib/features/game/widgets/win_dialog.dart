import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dino_hatch/utilities/router.dart';

class WinDialog extends StatelessWidget {
  final String eraName;
  final int levelId;

  const WinDialog({
    super.key,
    required this.eraName,
    required this.levelId,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Chúc mừng!'),
      content: Text('Bạn đã hoàn thành $eraName Level $levelId!'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.go(Routes.dnaMap);
          },
          child: const Text('Về bản đồ'),
        ),
      ],
    );
  }

  static void show(BuildContext context, String eraName, int levelId) {
    showDialog(
      context: context,
      builder: (context) => WinDialog(
        eraName: eraName,
        levelId: levelId,
      ),
    );
  }
}

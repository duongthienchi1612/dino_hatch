import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dino_hatch/app/router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dino Hatch – Home')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Wrap(
            spacing: 24,
            runSpacing: 24,
            alignment: WrapAlignment.center,
            children: <Widget>[
              _HomeCard(
                title: 'Thu thập DNA',
                icon: Icons.biotech,
                color: Colors.teal,
                onTap: () => context.go(Routes.dnaMap),
              ),
              _HomeCard(
                title: 'Khu nghiên cứu',
                icon: Icons.science,
                color: Colors.indigo,
                onTap: () => _comingSoon(context),
              ),
              _HomeCard(
                title: 'Khu bảo tồn',
                icon: Icons.forest,
                color: Colors.green,
                onTap: () => context.go(Routes.sanctuary),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _comingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sắp ra mắt!')),
    );
  }
}

class _HomeCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HomeCard({
    required this.title,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 260,
        height: 160,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.5)),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 12),
            Text(title, style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}



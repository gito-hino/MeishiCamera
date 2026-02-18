import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meishi Camera'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: 設定画面へ
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Spacer(),
            _MenuButton(
              icon: Icons.camera_alt,
              label: '名刺を撮影',
              onPressed: () {
                // TODO: カメラ起動
              },
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 16),
            _MenuButton(
              icon: Icons.photo_library,
              label: 'ギャラリーから取り込み',
              onPressed: () {
                // TODO: ギャラリー起動
              },
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 16),
            _MenuButton(
              icon: Icons.list_alt,
              label: '登録済み名刺',
              onPressed: () {
                // TODO: 一覧画面へ
              },
              color: Colors.orange,
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _MenuButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  final Color color;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.onPressed,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 20),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
    );
  }
}


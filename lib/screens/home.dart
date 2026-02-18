import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../providers/config.dart';
import 'camera.dart';
import 'settings.dart';
import 'list.dart';
import 'confirm.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(configProvider);
    final isConfigMissing =
        config.gasUrl.isEmpty || config.geminiApiKey.isEmpty;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meishi Camera'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (isConfigMissing)
            Container(
              color: Colors.amber.shade100,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const Icon(Icons.warning, color: Colors.orange),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      '設定（GAS URL / Gemini API Key）が未完了です。設定画面から入力してください。',
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    },
                    child: const Text('設定へ'),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),
                  _MenuButton(
                    icon: Icons.camera_alt,
                    label: '名刺を撮影',
                    onPressed:
                        isConfigMissing
                            ? () => _showConfigWarning(context)
                            : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const CameraScreen(),
                                ),
                              );
                            },
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  _MenuButton(
                    icon: Icons.photo_library,
                    label: 'ギャラリーから取り込み',
                    onPressed:
                        isConfigMissing
                            ? () => _showConfigWarning(context)
                            : () async {
                              final picker = ImagePicker();
                              final image = await picker.pickImage(
                                source: ImageSource.gallery,
                              );
                              if (image != null && context.mounted) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder:
                                        (context) => ConfirmScreen(
                                          imagePath: image.path,
                                        ),
                                  ),
                                );
                              }
                            },
                    color: Colors.blueGrey,
                  ),
                  const SizedBox(height: 16),
                  _MenuButton(
                    icon: Icons.list_alt,
                    label: '登録済み名刺',
                    onPressed:
                        isConfigMissing
                            ? () => _showConfigWarning(context)
                            : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder:
                                      (context) =>
                                          const BusinessCardListScreen(),
                                ),
                              );
                            },
                    color: Colors.orange,
                  ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showConfigWarning(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('先に設定画面から GAS URL と Gemini API Key を入力してください。'),
        backgroundColor: Colors.orange,
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 4,
      ),
    );
  }
}

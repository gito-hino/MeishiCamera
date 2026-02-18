import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/config.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _gasUrlController;
  late TextEditingController _geminiApiKeyController;

  @override
  void initState() {
    super.initState();
    final config = ref.read(configProvider);
    _gasUrlController = TextEditingController(text: config.gasUrl);
    _geminiApiKeyController = TextEditingController(text: config.geminiApiKey);
  }

  @override
  void dispose() {
    _gasUrlController.dispose();
    _geminiApiKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('設定')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Google Apps Script URL',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _gasUrlController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'https://script.google.com/macros/s/.../exec',
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Gemini API Key',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _geminiApiKeyController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'AIza...',
            ),
            obscureText: true,
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              ref
                  .read(configProvider.notifier)
                  .setGasUrl(_gasUrlController.text);
              ref
                  .read(configProvider.notifier)
                  .setGeminiApiKey(_geminiApiKeyController.text);

              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('設定を保存しました')));
            },
            child: const Text('保存する'),
          ),
        ],
      ),
    );
  }
}

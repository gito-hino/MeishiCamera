import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/business_card.dart';
import '../providers/cards.dart';
import '../providers/ocr.dart';

class ConfirmScreen extends ConsumerStatefulWidget {
  final String imagePath;

  const ConfirmScreen({super.key, required this.imagePath});

  @override
  ConsumerState<ConfirmScreen> createState() => _ConfirmScreenState();
}

class _ConfirmScreenState extends ConsumerState<ConfirmScreen> {
  bool _isLoading = false;
  String _loadingMessage = '';

  Future<void> _processRegistration() async {
    setState(() {
      _isLoading = true;
      _loadingMessage = 'AI解析中...';
    });

    try {
      final ocrService = ref.read(ocrProvider);
      final analyzedCard = await ocrService.analyzeImage(widget.imagePath);

      if (analyzedCard == null) {
        throw Exception('名刺情報の抽出に失敗しました');
      }

      if (!mounted) return;
      setState(() {
        _loadingMessage = '保存中...';
      });

      final success = await ref
          .read(cardsProvider.notifier)
          .saveCard(analyzedCard);

      if (!mounted) return;
      if (success) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('登録しました')));
        Navigator.of(context).popUntil((route) => route.isFirst);
      } else {
        throw Exception('データの保存に失敗しました');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('エラー: $e')));
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('撮影結果の確認')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(
                      File(widget.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed:
                            _isLoading
                                ? null
                                : () => Navigator.of(context).pop(),
                        child: const Text('撮り直し'),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _processRegistration,
                        child: const Text('登録する'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (_isLoading)
            Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircularProgressIndicator(color: Colors.white),
                    const SizedBox(height: 16),
                    Text(
                      _loadingMessage,
                      style: const TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

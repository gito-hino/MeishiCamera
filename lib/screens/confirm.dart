import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/business_card.dart';
import '../providers/cards.dart';

class ConfirmScreen extends ConsumerWidget {
  final String imagePath;

  const ConfirmScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('撮影結果の確認')),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(File(imagePath), fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('撮り直し'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // TODO: 後で Gemini OCR の結果を入れる
                      final dummyCard = BusinessCard(
                        name: '解析中...',
                        company: '',
                        email: '',
                        phone: '',
                        memo: 'Image Path: $imagePath',
                      );

                      final success = await ref
                          .read(cardsProvider.notifier)
                          .saveCard(dummyCard);

                      if (context.mounted) {
                        if (success) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('登録しました')),
                          );
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('登録に失敗しました')),
                          );
                        }
                      }
                    },
                    child: const Text('登録する'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

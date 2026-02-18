import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/cards.dart';
import '../models/business_card.dart';

class BusinessCardListScreen extends ConsumerWidget {
  const BusinessCardListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cardsAsync = ref.watch(cardsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('登録済み名刺'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(cardsProvider.notifier).fetchCards(),
          ),
        ],
      ),
      body: cardsAsync.when(
        data:
            (cards) =>
                cards.isEmpty
                    ? const Center(child: Text('登録された名刺はありません'))
                    : ListView.builder(
                      itemCount: cards.length,
                      itemBuilder: (context, index) {
                        final card = cards[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: ListTile(
                            title: Text(
                              card.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text('${card.company}\n${card.email}'),
                            isThreeLine: true,
                            onTap: () => _showCardDetail(context, card),
                          ),
                        );
                      },
                    ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラーが発生しました: $err')),
      ),
    );
  }

  void _showCardDetail(BuildContext context, BusinessCard card) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(card.name),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DetailRow(label: '会社名', value: card.company),
                  _DetailRow(label: 'メール', value: card.email),
                  _DetailRow(label: '電話', value: card.phone),
                  _DetailRow(label: 'メモ', value: card.memo),
                  if (card.timestamp != null)
                    _DetailRow(
                      label: '登録日時',
                      value: DateFormat(
                        'yyyy/MM/dd HH:mm',
                      ).format(card.timestamp!),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('閉じる'),
              ),
            ],
          ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
          Text(
            value.isEmpty ? '-' : value,
            style: const TextStyle(fontSize: 16),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

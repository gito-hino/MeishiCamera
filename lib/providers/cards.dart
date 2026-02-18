import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../models/business_card.dart';
import 'config.dart';

class CardsNotifier extends StateNotifier<AsyncValue<List<BusinessCard>>> {
  final Ref ref;

  CardsNotifier(this.ref) : super(const AsyncValue.loading()) {
    fetchCards();
  }

  Future<void> fetchCards() async {
    final config = ref.read(configProvider);
    if (config.gasUrl.isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    state = const AsyncValue.loading();
    try {
      final response = await http.get(Uri.parse(config.gasUrl));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        final cards = data.map((json) => BusinessCard.fromJson(json)).toList();
        state = AsyncValue.data(cards);
      } else {
        throw Exception('Failed to load cards: ${response.statusCode}');
      }
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<bool> saveCard(BusinessCard card) async {
    final config = ref.read(configProvider);
    if (config.gasUrl.isEmpty) return false;

    try {
      final response = await http.post(
        Uri.parse(config.gasUrl),
        body: json.encode(card.toJson()),
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'success') {
          await fetchCards();
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error saving card: $e');
      return false;
    }
  }
}

final cardsProvider =
    StateNotifierProvider<CardsNotifier, AsyncValue<List<BusinessCard>>>((ref) {
      return CardsNotifier(ref);
    });

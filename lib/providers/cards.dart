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
    if (config.gasUrl.isEmpty) {
      print('GAS URL is not set');
      return false;
    }

    try {
      final response = await http
          .post(
            Uri.parse(config.gasUrl),
            headers: {'Content-Type': 'application/json'},
            body: json.encode(card.toJson()),
          )
          .timeout(const Duration(seconds: 15));

      if (response.statusCode == 200 || response.statusCode == 302) {
        // GAS はリダイレクト (302) を返すことがあるが http パッケージはある程度自動で追従する
        // ただし、Content-Type の関係でうまくいかない場合があるため、入念にチェック
        final result = json.decode(response.body);
        if (result['status'] == 'success') {
          await fetchCards();
          return true;
        } else {
          print('GAS error: ${result['message']}');
        }
      } else {
        print('Server error: ${response.statusCode}');
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

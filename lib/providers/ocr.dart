import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/business_card.dart';
import 'config.dart';

final ocrProvider = Provider((ref) => OcrService(ref));

class OcrService {
  final Ref _ref;

  OcrService(this._ref);

  Future<BusinessCard?> analyzeImage(String imagePath) async {
    final config = _ref.read(configProvider);
    if (config.geminiApiKey.isEmpty) {
      throw Exception('Gemini API Key is not set');
    }

    // モデル名を 'gemini-1.5-flash' に戻す
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: config.geminiApiKey,
      generationConfig: GenerationConfig(responseMimeType: 'application/json'),
    );

    final imageBytes = await File(imagePath).readAsBytes();
    final prompt = TextPart('''
      提供された名刺画像から情報を抽出し、以下のJSON形式で出力してください。
      必ず有効なJSONのみを返し、解説などは含めないでください。
      不明な項目は空文字にしてください。
      {
        "name": "氏名",
        "company": "会社名",
        "email": "メールアドレス",
        "phone": "電話番号",
        "memo": "その他特記事項や役職など"
      }
    ''');

    final content = [
      Content.multi([prompt, DataPart('image/jpeg', imageBytes)]),
    ];

    try {
      final response = await model.generateContent(content);
      final text = response.text;
      if (text == null) {
        throw Exception('解析結果が空でした');
      }

      final jsonMap = json.decode(text) as Map<String, dynamic>;
      return BusinessCard.fromJson(jsonMap);
    } catch (e) {
      print('Gemini OCR Error: $e');
      rethrow;
    }
  }
}

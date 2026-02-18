import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppConfig {
  final String gasUrl;
  final String geminiApiKey;

  AppConfig({this.gasUrl = '', this.geminiApiKey = ''});

  AppConfig copyWith({String? gasUrl, String? geminiApiKey}) {
    return AppConfig(
      gasUrl: gasUrl ?? this.gasUrl,
      geminiApiKey: geminiApiKey ?? this.geminiApiKey,
    );
  }
}

class AppConfigNotifier extends StateNotifier<AppConfig> {
  AppConfigNotifier() : super(AppConfig());

  void setGasUrl(String url) => state = state.copyWith(gasUrl: url);
  void setGeminiApiKey(String key) => state = state.copyWith(geminiApiKey: key);
}

final configProvider = StateNotifierProvider<AppConfigNotifier, AppConfig>((
  ref,
) {
  return AppConfigNotifier();
});

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
  AppConfigNotifier()
    : super(
        AppConfig(
          gasUrl:
              'https://script.google.com/macros/s/AKfycbxLNIT_xEGE70Shh8-dt7y7i_n88cBYKhgsZARVBWI3tWVDOTCJ9Vwoz-zgnF6TO50a/exec',
        ),
      );

  void setGasUrl(String url) => state = state.copyWith(gasUrl: url);
  void setGeminiApiKey(String key) => state = state.copyWith(geminiApiKey: key);
}

final configProvider = StateNotifierProvider<AppConfigNotifier, AppConfig>((
  ref,
) {
  return AppConfigNotifier();
});

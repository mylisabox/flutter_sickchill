import 'package:sickchill/sickchill.dart';

class SickChillApiProvider {
  final SickChill api;
  static SickChillApiProvider? _instance;

  SickChillApiProvider._(this.api);

  factory SickChillApiProvider.setup({required String baseUrl, String? proxyUrl, required String apiKey, bool enableLogs = false}) {
    return _instance ??= SickChillApiProvider._(SickChill(apiKey: apiKey, proxyUrl: proxyUrl, baseUrl: baseUrl, enableLogs: enableLogs));
  }

  factory SickChillApiProvider() {
    if (_instance == null) {
      throw Exception('SickChill not initialized, call setup before');
    }
    return _instance!;
  }

  void dispose() {
    api.dispose();
  }
}

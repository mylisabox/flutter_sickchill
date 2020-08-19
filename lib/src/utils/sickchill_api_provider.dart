import 'package:flutter/foundation.dart';
import 'package:sickchill/sickchill.dart';

class SickChillApiProvider {
  final SickChill api;
  static SickChillApiProvider _instance;

  SickChillApiProvider._(this.api);

  factory SickChillApiProvider.setup({@required String baseUrl, @required String apiKey, bool enableLogs = false}) {
    return _instance ??= SickChillApiProvider._(SickChill(apiKey: apiKey, baseUrl: baseUrl, enableLogs: enableLogs));
  }

  factory SickChillApiProvider() {
    if (_instance == null) {
      throw Exception('SickChill not initialized, call setup before');
    }
    return _instance;
  }

  void dispose() {
    api.dispose();
  }
}

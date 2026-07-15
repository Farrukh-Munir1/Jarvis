import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final apiKeyProvider = Provider<String?>((ref) => null);

class ApiKeyNotifier extends StateNotifier<String?> {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _kKey = 'gemini_api_key';

  ApiKeyNotifier(): super(null) {
    _load();
  }

  Future<void> _load() async {
    final k = await _storage.read(key: _kKey);
    state = k;
  }

  Future<void> saveApiKey(String key) async {
    await _storage.write(key: _kKey, value: key);
    state = key;
  }

  Future<void> clear() async {
    await _storage.delete(key: _kKey);
    state = null;
  }
}

final apiKeyNotifierProvider = StateNotifierProvider<ApiKeyNotifier, String?>((ref) => ApiKeyNotifier());

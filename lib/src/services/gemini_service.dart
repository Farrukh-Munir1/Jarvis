import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';

/// Lightweight Gemini integration skeleton that requires caller to supply the API key.
/// This module focuses on a tiny, testable surface: text completion and function-call wrapper.
class GeminiService {
  final Dio _dio;

  GeminiService({Dio? dio}) : _dio = dio ?? Dio();

  Future<String> completeText({required String apiKey, required String prompt, CancelToken? cancelToken}) async {
    final endpoint = 'https://generativeai.googleapis.com/v1beta2/models/text-bison:generate';

    final body = {
      'prompt': {'text': prompt},
      'temperature': 0.2,
      'maxOutputTokens': 512,
    };

    final res = await _dio.post(endpoint,
        data: jsonEncode(body),
        options: Options(headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        }),
        cancelToken: cancelToken);

    if (res.statusCode != 200 && res.statusCode != 201) {
      throw Exception('Gemini request failed: ${res.statusCode} ${res.statusMessage}');
    }

    final data = res.data;
    // Defensive parsing
    if (data is Map && data.containsKey('candidates')) {
      final candidates = data['candidates'] as List<dynamic>;
      if (candidates.isNotEmpty) {
        final first = candidates.first;
        if (first is Map && first.containsKey('output')) {
          return first['output']?.toString() ?? '';
        }
      }
    }
    return data.toString();
  }

  /// Wrapper that expects the model to respond with JSON for function-calls.
  Future<Map<String, dynamic>> callFunction({required String apiKey, required String prompt}) async {
    final raw = await completeText(apiKey: apiKey, prompt: prompt);
    try {
      final parsed = _safeJsonParse(raw);
      if (parsed is Map<String, dynamic>) return parsed;
      return {'result': parsed};
    } catch (e) {
      return {'raw': raw};
    }
  }

  dynamic _safeJsonParse(String raw) {
    return raw.isEmpty ? {} : (raw.startsWith('{') || raw.startsWith('[') ? jsonDecode(raw) : raw);
  }
}

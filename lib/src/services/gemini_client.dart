import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

/// GeminiClient: lightweight client that sends requests to Gemini.
/// The client never stores the API key; callers must provide it at runtime.
class GeminiClient {
  final Dio _dio;

  GeminiClient({Dio? dio}) : _dio = dio ?? Dio();

  /// Sends a text prompt to Gemini and returns the response text.
  /// Throws on HTTP or parse errors.
  Future<String> completeText({
    required String apiKey,
    required String prompt,
    Map<String, dynamic>? params,
    CancelToken? cancelToken,
  }) async {
    final endpoint = 'https://generativeai.googleapis.com/v1beta2/models/text-bison:generate';

    final body = {
      'prompt': {
        'text': prompt,
      },
      'temperature': params?['temperature'] ?? 0.2,
      'maxOutputTokens': params?['maxOutputTokens'] ?? 512,
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
    // The exact response schema depends on API; we defensively find text.
    if (data is Map && data.containsKey('candidates')) {
      final candidates = data['candidates'];
      if (candidates is List && candidates.isNotEmpty) {
        final first = candidates.first;
        if (first is Map && first.containsKey('output')) {
          return first['output']?.toString() ?? '';
        }
      }
    }

    // Fallback: stringify entire response
    return jsonEncode(data);
  }

  /// Example function-calling support: send structured request and receive JSON response.
  Future<Map<String, dynamic>> callFunction({
    required String apiKey,
    required String prompt,
    String functionName = 'default_function',
    CancelToken? cancelToken,
  }) async {
    final text = await completeText(apiKey: apiKey, prompt: prompt, cancelToken: cancelToken);
    // Expect the model to return JSON; attempt to parse.
    try {
      final parsed = jsonDecode(text);
      if (parsed is Map<String, dynamic>) return parsed;
      return {'result': parsed};
    } catch (e) {
      // If parsing fails, return wrapper with raw text.
      return {'raw': text};
    }
  }
}

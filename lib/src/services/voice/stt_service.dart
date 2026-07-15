import 'package:speech_to_text/speech_to_text.dart';

class SttService {
  final SpeechToText _stt = SpeechToText();

  Future<bool> initialize() async {
    return await _stt.initialize();
  }

  bool get isAvailable => _stt.isAvailable;

  Future<void> listen({
    required Function(String) onResult,
    Function(String)? onError,
    bool partialResults = true,
  }) async {
    await _stt.listen(
      onResult: (result) {
        onResult(result.recognizedWords);
      },
      partialResults: partialResults,
      listenFor: const Duration(seconds: 30),
      onSoundLevelChange: null,
      cancelOnError: true,
    );
  }

  Future<void> stop() => _stt.stop();
}

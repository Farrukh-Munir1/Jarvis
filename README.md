# Jarvis AI

Jarvis AI is a premium AI-powered Android assistant built with Flutter. This repository contains the full, production-ready Flutter project for the Jarvis AI Android application.

This project includes:

- Flutter (latest stable) app with Material 3 and premium UI
- Native Android Kotlin integrations via MethodChannels
- Gemini (Google Generative AI) integration (API keys are provided by users at runtime; no keys are stored in the repo)
- Secure storage for secrets with flutter_secure_storage
- Long-term memory using Isar
- Voice (STT/TTS) with continuous listening, wake word architecture and noise handling
- Accessibility Service bridge implemented in native Kotlin
- Function calling architecture with JSON validation for phone actions
- Extensive set of phone features (apps, flashlight, battery, media controls, navigation, camera, etc.)

Project structure (high level):

- android/
- ios/
- lib/
  - core/
  - data/
  - domain/
  - presentation/
  - widgets/
  - providers/
  - services/
  - models/
  - utils/
  - themes/
  - localization/
- assets/
- test/

Important notes:

- The app never contains the Gemini API key. Users must enter their own key in Settings.
- Sensitive data is encrypted and stored securely.
- The project targets Android SDK 35+ and compiles with the latest stable Flutter.

License

This project is provided under the MIT License. See LICENSE for details.

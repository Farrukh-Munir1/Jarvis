import 'package:flutter/services.dart';
import 'constants.dart';

final MethodChannel nativeChannel = MethodChannel(AppConstants.methodChannelName);

class NativeMethods {
  static Future<String?> getClipboard() async {
    try {
      final res = await nativeChannel.invokeMethod<String>('getClipboard');
      return res;
    } on PlatformException {
      return null;
    }
  }

  static Future<bool> openApp(String packageName) async {
    try {
      final res = await nativeChannel.invokeMethod<bool>('openApp', {'package': packageName});
      return res ?? false;
    } on PlatformException {
      return false;
    }
  }
}

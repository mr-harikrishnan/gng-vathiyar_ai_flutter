// ===============================
// FULL UTILS WITH LONG PRINT
// ===============================

import 'dart:convert';

class Utils {
  // COMMON LONG PRINT FUNCTION

  static void longPrint(String title, String text) {
    if (text.isEmpty) {
      print("$title: empty");
      return;
    }

    print("========== $title ==========");

    const int chunkSize = 800;

    for (int i = 0; i < text.length; i += chunkSize) {
      final end = (i + chunkSize < text.length) ? i + chunkSize : text.length;

      print(text.substring(i, end));
    }

    print("========== END $title ==========");
  }

  // TOKEN VALIDATION

  static bool isValidToken(String token) {
    try {
      // Split JWT: header.payload.signature
      final parts = token.split('.');

      // JWT must have 3 parts
      if (parts.length != 3) {
        return false;
      }

      // Decode payload (base64)
      final payload = parts[1];
      final normalized = base64.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));

      // Convert JSON string to map
      final Map<String, dynamic> data = json.decode(decoded);

      // JWT exp time (seconds since epoch)
      final int exp = data['exp'];

      // Current time in seconds
      final int now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Token valid if now < exp
      return now < exp;
    } catch (e) {
      return false;
    }
  }
}

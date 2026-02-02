import 'dart:convert';

class Utils {
  static void safePrintJwt(String jwt) {
    const int chunkSize = 800;

    for (int i = 0; i < jwt.length; i += chunkSize) {
      int end = i + chunkSize;
      if (end > jwt.length) {
        end = jwt.length;
      }

      print("jwt :${jwt.substring(i, end)}");
    }
  }

  bool isValidToken(String token) {
    try {
      // Split JWT: header.payload.signature
      final parts = token.split('.');

      // JWT must have 3 parts
      if (parts.length != 3) {
        return false; // Bad format
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

      // Token is valid if now < exp
      return now < exp;
    } catch (e) {
      // Any error = invalid token
      return false;
    }
  }
}

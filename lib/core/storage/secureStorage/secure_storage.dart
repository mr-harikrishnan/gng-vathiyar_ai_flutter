import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create storage instance
final _storage = const FlutterSecureStorage();

// Save value
Future<void> writeSecureData(String key, String value) async {
  await _storage.write(key: key, value: value);
}

// Read value
Future<String?> readSecureData(String key) async {
  return await _storage.read(key: key);
}

// Delete one key
Future<void> deleteSecureData(String key) async {
  await _storage.delete(key: key);
}

// Delete all keys
Future<void> deleteAllSecureData() async {
  await _storage.deleteAll();
}

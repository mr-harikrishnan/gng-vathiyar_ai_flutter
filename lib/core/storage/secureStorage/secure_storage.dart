import 'package:flutter_secure_storage/flutter_secure_storage.dart';

// Create storage instance
final _storage = const FlutterSecureStorage();

// Function to write data
Future<void> writeSecureData(String key, String value) async {
  await _storage.write(key: key, value: value);
}

// Function to read data
Future<String?> readSecureData(String key) async {
  String? value = await _storage.read(key: key);
  return value;
}

// Function to delete data
Future<void> deleteSecureData(String key) async {
  await _storage.delete(key: key);
}

// Function to delete all data
Future<void> deleteAllSecureData() async {
  await _storage.deleteAll();
}

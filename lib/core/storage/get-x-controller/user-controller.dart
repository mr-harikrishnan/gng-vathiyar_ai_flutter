// lib/core/common/app_common.dart
import 'package:get/get.dart';
import 'package:amplify_flutter/amplify_flutter.dart';

class GetxUserController extends GetxService {
  // Observable values
  var userId = ''.obs;
  var username = ''.obs;
  var email = ''.obs;
  var phone = ''.obs;

  // Fetch logged-in user data
  Future<void> fetchUserData() async {
    try {
      // Get basic user info
      final user = await Amplify.Auth.getCurrentUser();
      userId.value = user.userId;
      username.value = user.username;

      // Get user attributes
      final attributes = await Amplify.Auth.fetchUserAttributes();

      for (final attr in attributes) {
        if (attr.userAttributeKey.key == 'email') {
          email.value = attr.value;
        }
        if (attr.userAttributeKey.key == 'phone_number') {
          phone.value = attr.value;
        }
      }
    } catch (e) {
      print("Fetch user error: $e");
    }
  }

  // You can add more common functions here
  void clearUserData() {
    userId.value = '';
    username.value = '';
    email.value = '';
    phone.value = '';
  }
}

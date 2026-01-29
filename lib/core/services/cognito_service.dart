import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:get/get.dart';
import 'package:vathiyar_ai_flutter/core/storage/getXController/userController.dart';
import 'package:vathiyar_ai_flutter/core/storage/secureStorage/secure_storage.dart';
import 'package:vathiyar_ai_flutter/widgets/show_pop.dart';
import '../../amplifyconfiguration.dart';

class CognitoService {
  static bool _configured = false;

  static final GetxUserController _userController =
      Get.find<GetxUserController>();

  // Setup Amplify once
  static Future<void> configure() async {
    if (_configured) return;

    try {
      final authPlugin = AmplifyAuthCognito();
      await Amplify.addPlugin(authPlugin);
      await Amplify.configure(amplifyconfig);

      _configured = true;
      print("Amplify configured");
    } catch (e) {
      print("Amplify error: $e");
    }
  }

  // Login function
  Future<bool> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      // Always logout before login
      await signOut();

      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      // If login success
      if (result.isSignedIn) {
        await _userController.fetchUserData();
        await fetchCognitoAuthSession();
      }

      return result.isSignedIn;
    } on AuthException catch (e) {
      if (context.mounted) {
        showPopError(context, e.message, "Error");
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        showPopError(
          context,
          "Unknown error during login",
          "Error",
        );
      }
      return false;
    }
  }

  // Logout function
  static Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();

      // Clear user data
      _userController.clearUserData();

      // Delete tokens
      await deleteAllSecureData();
    } catch (e) {
      print("Logout error: $e");
    }
  }

  // Save tokens in secure storage
  Future<void> fetchCognitoAuthSession() async {
    try {
      final cognitoPlugin = Amplify.Auth.getPlugin(
        AmplifyAuthCognito.pluginKey,
      );

      final result = await cognitoPlugin.fetchAuthSession();

      final accessToken =
          result.userPoolTokensResult.value.accessToken.raw;
      final idToken =
          result.userPoolTokensResult.value.idToken.raw;
      final refreshToken =
          result.userPoolTokensResult.value.refreshToken;

      // Store tokens securely
      await writeSecureData("accessToken", accessToken);
      await writeSecureData("idToken", idToken);
      await writeSecureData("refreshToken", refreshToken);
    } catch (e) {
      print("Token fetch error: $e");
    }
  }
}

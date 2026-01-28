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

  // Setup Amplify once when app starts
  static Future<void> configure() async {
    if (_configured) return;

    try {
      final authPlugin = AmplifyAuthCognito();
      await Amplify.addPlugin(authPlugin);
      await Amplify.configure(amplifyconfig);

      _configured = true;
      print('Amplify configured');
    } catch (e) {
      print('Amplify error: $e');
    }
  }

  // Login
  Future<bool> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      signOut();
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        await _userController.fetchUserData();
        await fetchCognitoAuthSession();
      }

      return result.isSignedIn;
    } on AuthException catch (e) {
      if (context.mounted) {
        showPopError(context, e.message, "Error");
      }
      print('Login error: ${e.message}');
      return false;
    } catch (e) {
      print('Login error: $e');
      if (context.mounted) {
        showPopError(
          context,
          'An unknown error occurred during sign in.',
          "Error",
        );
      }
      return false;
    }
  }

  // Logout
  static Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
      _userController.clearUserData();
    } catch (e) {
      print('Logout error: $e');
    }
  }

  void safePrint(String label, String text) {
    final int chunkSize = 800;
    print('--- START $label ---');

    // Loop through the string and print it in chunks
    for (int i = 0; i < text.length; i += chunkSize) {
      int end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
      print(text.substring(i, end));
    }

    print('--- END $label ---');
  }

  // Get Cognito tokens
  Future<void> fetchCognitoAuthSession() async {
    try {
      final cognitoPlugin = Amplify.Auth.getPlugin(
        AmplifyAuthCognito.pluginKey,
      );
      final result = await cognitoPlugin.fetchAuthSession();

      // Get tokens
      final accessToken = result.userPoolTokensResult.value.accessToken.raw;
      final idToken = result.userPoolTokensResult.value.idToken.raw;
      final refreshToken = result.userPoolTokensResult.value.refreshToken;

      // Store tokens
      await writeSecureData('accessToken', accessToken);
      await writeSecureData('idToken', idToken);
      await writeSecureData('refreshToken', refreshToken);

      // --- USE THE SAFE PRINT FUNCTION HERE ---
      safePrint("ACCESS TOKEN", accessToken);
      safePrint("ID TOKEN", idToken);
      safePrint("REFRESH TOKEN", refreshToken);
      
    } catch (e) {
      print('Error retrieving auth session: $e');
    }
  }
}

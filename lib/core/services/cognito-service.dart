import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter/material.dart';

import '../../amplifyconfiguration.dart';
import '../storage/secure-storage/secure-storage.dart';
import '../../widgets/show-pop.dart';

class CognitoService {
  static bool _configured = false;

  // SETUP AMPLIFY (RUN ONCE)

  static Future<void> configure() async {
    if (_configured) return;

    try {
      final authPlugin = AmplifyAuthCognito();

      // Add plugin
      await Amplify.addPlugin(authPlugin);

      // Configure Amplify
      await Amplify.configure(amplifyconfig);

      _configured = true;
      debugPrint("Amplify ready");
    } on AmplifyAlreadyConfiguredException {
      _configured = true;
      debugPrint("Amplify already ready");
    } catch (e) {
      debugPrint("Amplify error: $e");
    }
  }

  // CHECK LOGIN STATUS

  Future<bool> isLoggedIn() async {
    try {
      // Ask Amplify for session
      final session = await Amplify.Auth.fetchAuthSession();

      // Return true if user signed in
      return session.isSignedIn;
    } catch (e) {
      debugPrint("Session check error: $e");
      return false;
    }
  }

  // SIGN IN

  Future<bool> signIn(
    BuildContext context,
    String email,
    String password,
  ) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      // If login success, save data
      if (result.isSignedIn) {
        await _saveTokens();
        await _saveUserData(email);
      }

      return result.isSignedIn;
    } on AuthException catch (e) {
      if (context.mounted) {
        showPopError(context, e.message, "Error");
      }
      return false;
    } catch (e) {
      if (context.mounted) {
        showPopError(context, "Login failed", "Error");
      }
      return false;
    }
  }

  // SIGN OUT

  static Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();

      // Clear secure storage
      await deleteAllSecureData();
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }

  // SAVE TOKENS

  Future<void> _saveTokens() async {
    try {
      final cognitoPlugin = Amplify.Auth.getPlugin(
        AmplifyAuthCognito.pluginKey,
      );

      // Get auth session
      final result = await cognitoPlugin.fetchAuthSession();

      // Read tokens
      final accessToken = result.userPoolTokensResult.value.accessToken.raw;
      final idToken = result.userPoolTokensResult.value.idToken.raw;
      final refreshToken = result.userPoolTokensResult.value.refreshToken;

      // Save in secure storage
      await writeSecureData("accessToken", accessToken);
      await writeSecureData("idToken", idToken);
      await writeSecureData("refreshToken", refreshToken);
    } catch (e) {
      debugPrint("Token save error: $e");
    }
  }

  // SAVE USER DATA

  Future<void> _saveUserData(usernameData) async {
    try {
      // Get current user
      final user = await Amplify.Auth.getCurrentUser();
      print("Current user: ${usernameData}");
      print("User ID: ${user.userId}");

      // Save user info
      await writeSecureData("userId", user.userId);
      await writeSecureData("username", usernameData);

      // Get attributes
      final attributes = await Amplify.Auth.fetchUserAttributes();

      for (final attr in attributes) {
        if (attr.userAttributeKey.key == 'email') {
          await writeSecureData("email", attr.value);
        }

        if (attr.userAttributeKey.key == 'phone_number') {
          await writeSecureData("phone_number", attr.value);
        }
      }
    } catch (e) {
      debugPrint("User data save error: $e");
    }
  }
}

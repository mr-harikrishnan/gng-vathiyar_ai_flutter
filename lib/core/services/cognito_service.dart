import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:get/get.dart';
import 'package:vathiyar_ai_flutter/core/storage/getXController/userController.dart';
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
  static Future<bool> signIn(
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
      print("signIn user data...  $result");

      if (result.isSignedIn) {
        await _userController.fetchUserData();
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

  static Future<void> getCognitoTokens() async {
    try {
      final result = await Amplify.Auth.fetchAuthSession(
        options: const FetchAuthSessionOptions(),
      );
      final cognitoSession = result as CognitoAuthSession;

      if (cognitoSession.isSignedIn) {
        final userPoolTokens = cognitoSession.userPoolTokensResult.value;

        final accessToken = userPoolTokens.accessToken;
        final refreshToken = userPoolTokens.refreshToken;
        final idToken = userPoolTokens.idToken;

        print('Access Token: $accessToken');
        print('Refresh Token: $refreshToken');
        print('ID Token: $idToken');
      }
    } on AuthException catch (e) {
      print('Error fetching auth session: ${e.message}');
    }
  }
}

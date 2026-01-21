import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:vathiyar_ai_flutter/widgets/show_pop_error.dart';
import '../../amplifyconfiguration.dart';

class CognitoService {
  static bool _configured = false;

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
  static Future<bool> signIn(BuildContext context, String email, String password) async {
    try {
      signOut();
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      print("signIn user data...  $result");
      
      return result.isSignedIn;
    } on AuthException catch (e) {
      if (context.mounted) {
        showPopError(context, e.message, "Error");
      }
      print('Login error: ${e.message}');
      return false;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  // Logout
  static Future<void> signOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      print('Logout error: $e');
    }
  }
}

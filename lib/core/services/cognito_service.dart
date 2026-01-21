import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
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
  static Future<bool> signIn(String email, String password) async {
    try {
      signOut();
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );
      print("signIn user data...  $result");
      
      return result.isSignedIn;
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

import 'package:flutter/material.dart';
import 'package:email_validator/email_validator.dart';
import '../../../core/services/cognito_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

  final emailOrmobileNoController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailOrmobileNoController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: emailOrmobileNoController,
                      decoration: const InputDecoration(
                        labelText: 'Email/Phone number',
                        labelStyle: TextStyle(fontSize: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email or phone number';
                        }
                        final isEmail = EmailValidator.validate(value);
                        final isPhone = RegExp(r'^\+?[0-9]+$').hasMatch(value);

                        if (!isEmail && !isPhone) {
                          return 'Please enter a valid email or phone number';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 6),
                    TextFormField(
                      controller: passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: const TextStyle(fontSize: 16),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }

                        // Check length
                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }

                        // Check uppercase
                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Add one uppercase letter';
                        }

                        // Check lowercase
                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Add one lowercase letter';
                        }

                        // Check number
                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Add one number';
                        }

                        // Check special character
                        if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                          return 'Add one special character';
                        }

                        return null;
                      },
                    ),
                    SizedBox(height: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF016A63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ), // Full width button
                      ),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          bool success = await CognitoService.signIn(
                            emailOrmobileNoController.text,
                            passwordController.text,
                          );
                          if (!mounted) return;
                          if (success) {
                            print('Login success');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Login failed')),
                            );
                          }
                        }
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ),
                    SizedBox(height: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide.none, // No border
                        elevation: 0, // Remove shadow
                        shadowColor: Colors.transparent, // Extra safety
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ), // Full width
                      ),
                      onPressed: () {
                        print("Forget Password");
                      },
                      child: const Text(
                        "Forget Password",
                        style: TextStyle(
                          fontSize: 18, // Text size
                          fontWeight: FontWeight.bold, // Text weight
                          color: Color(0xFF016A63), // Text color
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

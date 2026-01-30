import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:email_validator/email_validator.dart';
import 'package:vathiyar_ai_flutter/widgets/show-pop.dart';
import '../../../core/services/cognito-service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  final emailOrmobileNoController = TextEditingController();
  final passwordController = TextEditingController();

  bool showPrefix = false;

  @override
  void initState() {
    super.initState();

    emailOrmobileNoController.addListener(() {
      final text = emailOrmobileNoController.text;

      final startsWithTwoDigits = RegExp(r'^[0-9]{2}').hasMatch(text);

      final hasLetter = RegExp(r'[a-zA-Z]').hasMatch(text);

      bool shouldShow;

      if (startsWithTwoDigits && !hasLetter) {
        shouldShow = true;
      } else {
        shouldShow = false;
      }

      // Prevent extra rebuild
      if (showPrefix != shouldShow) {
        setState(() {
          showPrefix = shouldShow;
        });
      }
    });
  }

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
                      decoration: InputDecoration(
                        labelText: 'Email/Phone number',
                        labelStyle: const TextStyle(fontSize: 16),
                        prefixText: showPrefix ? '+91 ' : null,
                        prefixStyle: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),

                      // Validate email or phone
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email or phone number';
                        }

                        final isEmail = EmailValidator.validate(value);
                        final isPhone = RegExp(
                          r'^\+?[0-9]{10,12}$',
                        ).hasMatch(value);

                        if (!isEmail && !isPhone) {
                          return 'Please enter a valid email or phone number';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 6),

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

                      // Password rules
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }

                        if (value.length < 8) {
                          return 'Password must be at least 8 characters';
                        }

                        if (!RegExp(r'[A-Z]').hasMatch(value)) {
                          return 'Add one uppercase letter';
                        }

                        if (!RegExp(r'[a-z]').hasMatch(value)) {
                          return 'Add one lowercase letter';
                        }

                        if (!RegExp(r'[0-9]').hasMatch(value)) {
                          return 'Add one number';
                        }

                        if (!RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                          return 'Add one special character';
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 6),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _isLoading
                            ? const Color.fromARGB(255, 102, 248, 238)
                            : const Color(0xFF016A63),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              setState(() {
                                _isLoading = true;
                              });

                              // Prepare login value
                              String loginValue =
                                  emailOrmobileNoController.text;

                              // Add +91 if it's a 10-digit phone number
                              if (RegExp(r'^[0-9]{10}$').hasMatch(loginValue)) {
                                loginValue = '+91$loginValue';
                              }

                              bool success = await CognitoService().signIn(
                                context,
                                loginValue,
                                passwordController.text,
                              );

                              if (!mounted) return;

                              setState(() {
                                _isLoading = false;
                              });

                              if (success) {
                                await showPopError(
                                  context,
                                  "Login successful",
                                  "success",
                                );

                                if (!mounted) return;

                                Navigator.pushReplacementNamed(
                                  context,
                                  '/dashboard',
                                );
                              }
                            },
                      child: _isLoading
                          ? const SizedBox(
                              height: 24,
                              width: 24,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                          : const Text(
                              "Login",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                    ),

                    const SizedBox(height: 6),
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

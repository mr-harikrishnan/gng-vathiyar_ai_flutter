import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;

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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Email/Phone number',
                        labelStyle: TextStyle(fontSize: 16),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 6),
                    TextFormField(
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
                        return null;
                      },
                    ),
                    SizedBox(height: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ), // Full width button
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process data
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logging In')),
                          );
                        }
                      },
                      child: Text("Login"),
                    ),
                    SizedBox(height: 6),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          width: 0,
                          color: Colors
                              .transparent, // or use any specific color and set width to 0
                        ),
                        minimumSize: const Size(
                          double.infinity,
                          50,
                        ), // Full width button
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Process data
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Forget Password')),
                          );
                        }
                      },
                      child: Text("Login"),
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

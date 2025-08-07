import 'package:ai_notes_app/services/auth_service.dart';
import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  const LoginSignupPage({super.key});

  @override
  State<LoginSignupPage> createState() => _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool _isLogin = true;
  String _email = '', _password = '';
  final AuthService _authService = AuthService();
  String? _errorMessage;
  bool _isLoading = false;

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });

      try {
        if (_isLogin) {
          await _authService.signInWithEmail(_email, _password);
        } else {
          await _authService.signUpWithEmail(_email, _password);
        }
        // Navigation is handled by the AuthWrapper, so we don't need to do anything here.
      } catch (e) {
        setState(() {
          // A simple way to make the error message more user-friendly
          _errorMessage = e.toString().split('] ')[1];
          _isLoading = false;
        });
      }
      // Don't set isLoading to false here if successful, as the screen will be replaced.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.note_alt, color: Colors.yellow, size: 80),
                const SizedBox(height: 20),
                const Text(
                  'AI Notes',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 40),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email', filled: true, fillColor: Colors.grey[850]),
                  validator: (value) => value!.isEmpty ? 'Please enter an email' : null,
                  onSaved: (value) => _email = value!,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  obscureText: true,
                  decoration: InputDecoration(labelText: 'Password', filled: true, fillColor: Colors.grey[850]),
                  validator: (value) => value!.length < 6 ? 'Password must be at least 6 characters' : null,
                  onSaved: (value) => _password = value!,
                ),
                const SizedBox(height: 24),
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Text(_errorMessage!, style: const TextStyle(color: Colors.red), textAlign: TextAlign.center),
                  ),
                if (_isLoading)
                  const Center(child: CircularProgressIndicator())
                else
                  ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow[700], padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: Text(_isLogin ? 'Login' : 'Sign Up', style: const TextStyle(fontSize: 18, color: Colors.black)),
                  ),
                TextButton(
                  onPressed: () => setState(() => _isLogin = !_isLogin),
                  child: Text(_isLogin ? 'Need an account? Sign Up' : 'Have an account? Login', style: TextStyle(color: Colors.yellow[700])),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
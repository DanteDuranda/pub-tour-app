import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';
import '../Lang.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  late TextEditingController _passwordAgainController;
  final List<String> _registrationErrorKeys = [];
  bool _isRegButtonEnabled = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordAgainController = TextEditingController();
  }

  Future<void> _changeLanguage() async {
    final lang = Provider.of<Lang>(context, listen: false);
    final newLang = lang.languageCode == 'en' ? 'hu' : 'en';
    await lang.setLanguage(newLang);

    setState(() {
      lang.loaded = true;
    });
  }

  void _onSignUpPressed() {
    setState(() {
      _isRegButtonEnabled = false;
    });

    final email = _emailController.text;
    final password = _passwordController.text;
    final passwordAgain = _passwordAgainController.text;

    _registrationErrorKeys.clear();

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'); // TODO: regex megturhatna a pw-t is

    if (email.isEmpty) {
      _registrationErrorKeys.add('login_empty_accountid_message');
    }
    else if (!emailRegex.hasMatch(email)) {
      _registrationErrorKeys.add('invalid_email_message');
    }

    if (password != passwordAgain &&
        password.isNotEmpty &&
        passwordAgain.isNotEmpty)
    {
      _registrationErrorKeys.add('password_mismatch_message');
    }
    else
    {
      if (password.isEmpty) {
        _registrationErrorKeys.add('login_empty_password_message');
      }
      if (passwordAgain.isEmpty && password.isNotEmpty) {
        _registrationErrorKeys.add('password_again_message');
      }
    }

    if (_registrationErrorKeys.isEmpty) {
      _signUp(email, password);
    }
    else {
      setState(() {
        _isRegButtonEnabled = true; // triggereli az errorMes rendert is
      });
    }
  }

  Future<void> _signUp(String email, String password) async {
    try {
      final response = await Supabase.instance.client.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Successfully! Please verify your email.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('sign up failed.')),
        );
      }
    } on AuthException catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: kDebugMode ? Text('sign up error: ${error.message}') : Text('sign up error.')) // TODO: debug mod konstansba indulas elejen beleverve
      );
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: kDebugMode ? Text('unexpected error: $error') : Text('unexpected error.'))
      );
    }

    setState(() {
      _isRegButtonEnabled = true;
    });
  }

  Widget _buildErrorMessages(Lang lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 25),
      child: Text(
        _registrationErrorKeys.map(lang.translate).join('\n'),
        style: const TextStyle(
          fontSize: 15,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildRegUpButton(String text) {
    final lang = Provider.of<Lang>(context);

    return ElevatedButton(
      onPressed: _isRegButtonEnabled ? _onSignUpPressed : null,
      child: Text(lang.translate(text)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);

    return Scaffold(
      appBar: AppBar(title: Text(lang.translate('title_registration'))),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 300),
                child: Column(
                  children: [
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: lang.translate('account_id'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: lang.translate('password_field'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _passwordAgainController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: lang.translate('password_field_again'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (_registrationErrorKeys.isNotEmpty) _buildErrorMessages(lang),
                    buildRegUpButton('registration_button'),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: _changeLanguage,
                      child: Text(lang.translate('change_language_button')),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
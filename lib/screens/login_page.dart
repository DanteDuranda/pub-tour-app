import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

import '../Lang.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final List<String> _loginErrorKeys = [];
  late TextEditingController _accountIdController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    _accountIdController = TextEditingController();
    _passwordController = TextEditingController();
    _loadLangFile();
  }

  @override
  void dispose() {
    _accountIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loadLangFile() async {
    final lang = Provider.of<Lang>(context, listen: false);

    await lang.loadLanguage();

    setState(() {
      lang.loaded = true;
    });
  }

  Future<void> _changeLanguage() async {
    final lang = Provider.of<Lang>(context, listen: false);
    final newLang = lang.languageCode == 'en' ? 'hu' : 'en';
    await lang.setLanguage(newLang);

    setState(() {
      lang.loaded = true;
    });
  }

  void _onLoginPressed() {
    final accountId = _accountIdController.text;
    final password = _passwordController.text;

    _loginErrorKeys.clear();

    if (accountId.isEmpty) {
      _loginErrorKeys.add('login_empty_accountid_message');
    }
    if (password.isEmpty) {
      _loginErrorKeys.add('login_empty_password_message');
    }

    if (_loginErrorKeys.isEmpty) {
      _login(accountId, password);
    } else {
      setState(() {});
    }
  }

  bool _login(String accointId, String password) {
    return false;
  }

  Widget _buildTextFields(Lang lang) {
    return Column(
      spacing: 3,
      children: [
        TextField(
          controller: _accountIdController,
          decoration: InputDecoration(
            labelText: lang.translate('account_id'),
            border: const OutlineInputBorder(),
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: lang.translate('password_field'),
            border: const OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessages(Lang lang) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Text(
        _loginErrorKeys.map(lang.translate).join('\n'),
        style: const TextStyle(
          fontSize: 15,
          color: Colors.red,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);

    if (!lang.loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Builder(
      builder: (BuildContext context) => Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(30),
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTextFields(lang),

                    const SizedBox(height: 15),

                    ElevatedButton(
                      onPressed: _onLoginPressed,
                      child: Text(lang.translate('login_button')),
                    ),

                    ElevatedButton(
                      onPressed: _changeLanguage,
                      child: Text(lang.translate('change_language_button')),
                    ),

                    if (_loginErrorKeys.isNotEmpty) _buildErrorMessages(lang),
                  ],
                ),
              ),
            ),
          ),
        ),
      )
    );
  }
}

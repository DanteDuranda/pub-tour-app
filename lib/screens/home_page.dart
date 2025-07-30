import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Lang.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  bool _loaded = false;
  List<String> loginErrorKeys = [];
  int navigationIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadLangFile();
  }

  Future<void> _loadLangFile() async {
    final lang = Provider.of<Lang>(context, listen: false);

    await lang.loadLanguage();

    setState(() {
      _loaded = true;
    });
  }

  void _incrementCounter() => setState(() => _counter++);

  Future<void> _changeLanguage() async {
    final lang = Provider.of<Lang>(context, listen: false);
    final newLang = lang.languageCode == 'en' ? 'hu' : 'en';
    await lang.setLanguage(newLang);

    setState(() {
      _loaded = true;
    });
  }

  void _onLoginPressed(String accountId, String password) {
    loginErrorKeys.clear();

    if (accountId.isEmpty) {
      loginErrorKeys.add('login_empty_accountid_message');
    }
    if (password.isEmpty) {
      loginErrorKeys.add('login_empty_password_message');
    }

    if (loginErrorKeys.isEmpty) {
      _login(accountId, password);
    } else {
      setState(() {});
    }
  }

  bool _login(String accointId, String password) {
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);

    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    String accountId = "";
    String password = "";

    return Scaffold(
      appBar: AppBar(title: Text(lang.translate('title'))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 300,
                height: 130,
                child: Column(
                  children: [
                    TextField(
                      onChanged: (value) {accountId = value;},
                      decoration: InputDecoration(
                        labelText: lang.translate('account_id'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      obscureText: true,
                      onChanged: (value) {password = value;},
                      decoration: InputDecoration(
                        labelText: lang.translate('password_field'),
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ),
              if (loginErrorKeys.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    loginErrorKeys.map((k) => lang.translate(k)).join('\n'),
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ElevatedButton(
                onPressed: () => _onLoginPressed(accountId, password),
                child: Text(lang.translate('login_button')),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _changeLanguage,
                child: Text(lang.translate('change_language_button')),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            navigationIndex = index;
          });
        },
          currentIndex: navigationIndex,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home"
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              label: "Profile"
            )
          ]),
    );
  }
}

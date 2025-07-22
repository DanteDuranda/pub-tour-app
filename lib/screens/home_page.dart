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

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);

    if (!_loaded) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(lang.translate('title'))),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(lang.translate('counter', args: {'count': _counter.toString()})),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _changeLanguage,
              child: Text(lang.translate('change_language_button')), // lang valtas test only
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        child: const Icon(Icons.add),
      ),
    );
  }
}

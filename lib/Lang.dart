import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:shared_preferences/shared_preferences.dart';

class Lang extends ChangeNotifier {
  bool loaded = false;
  String _langCode = 'en';
  Map<String, String> _currentTranslations = {};

  Future<void> loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    _langCode = prefs.getString('language_code') ?? 'en';

    await loadTranslations(_langCode);
    notifyListeners();
  }

  Future<void> loadTranslations(String languageCode) async {
    final path = 'assets/lang/messages_$languageCode.txt';
    final fileContent = await rootBundle.loadString(path);
    final lines = fileContent.split('\n');
    final Map<String, String> translations = {};

    for (var line in lines) {
      if (line.trim().isEmpty || !line.contains('=')) continue;
      var parts = line.split('=');
      translations[parts[0].trim()] = parts[1].trim();
    }

    _langCode = languageCode;
    _currentTranslations = translations;
    notifyListeners();
  }

  Future<void> setLanguage(String newLangCode) async {
    await loadTranslations(newLangCode);
    await saveLanguageCode(newLangCode);
  }

  String translate(String key, {Map<String, String>? args}) {
    String? value = _currentTranslations[key];
    if (value == null) return key;

    if (args != null) {
      args.forEach((argKey, argValue) {
        value = value!.replaceAll('{$argKey}', argValue);
      });
    }

    return value!;
  }

  String get languageCode {
    return _langCode;
  }

  Future<void> saveLanguageCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', code);
  }
}

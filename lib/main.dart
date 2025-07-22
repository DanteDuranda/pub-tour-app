import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app.dart';
import 'Lang.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final lang = Lang();
  await lang.setLanguage('hu'); // ez eleg dummy, kikene szedni a device lang-jat

  runApp(
    ChangeNotifierProvider.value(
      value: lang,
      child: const MyApp(),
    ),
  );
}

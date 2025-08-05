import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'app.dart';
import 'Lang.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final lang = Lang();
  await lang.setLanguage('hu'); // ez eleg dummy, kikene szedni a device lang-jat

  await Supabase.initialize(
    url: 'https://yilzznqwghmlqwzmtdnn.supabase.co',
    anonKey: 'sb_publishable_EcDx6CWa59W-NP9mAxG2FQ_uDN2Es10',
  );

  runApp(
    ChangeNotifierProvider.value(
      value: lang,
      child: const MyApp(),
    ),
  );
}

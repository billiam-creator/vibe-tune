import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/app_shell.dart';
import 'services/app_state.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await AppState.instance.init();
  runApp(const VibeTuneApp());
}

class VibeTuneApp extends StatelessWidget {
  const VibeTuneApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VibeTune',
      debugShowCheckedModeBanner: false,
      theme: VibeTuneTheme.theme,
      home: const AppShell(),
    );
  }
}
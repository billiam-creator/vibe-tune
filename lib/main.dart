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
  runApp(const VibeTuneApp());
  // Don't block the first frame on the network — load data in the
  // background so the app always renders even if the API is slow,
  // unreachable, or a single record fails to parse.
  AppState.instance.init();
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
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:traccar_client/geolocation_service.dart';
import 'package:traccar_client/quick_actions.dart';

import 'l10n/app_localizations.dart';
import 'main_screen.dart';
import 'panic_screen.dart';
import 'preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await Preferences.init();
  await Preferences.migrate();
  await GeolocationService.init();
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  RateMyApp rateMyApp = RateMyApp(minDays: 0, minLaunches: 0);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await rateMyApp.init();
      if (mounted && rateMyApp.shouldOpenDialog) {
        rateMyApp.showRateDialog(context);
      }
      await _ensurePassword();
    });
  }

  Future<void> _ensurePassword() async {
    final current = Preferences.instance.getString(Preferences.password);
    if (current == null || current.isEmpty) {
      final controller = TextEditingController();
      final result = await showDialog<String>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.setPasswordTitle),
          content: TextField(
            controller: controller,
            obscureText: true,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.passwordHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(AppLocalizations.of(context)!.cancelButton),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: Text(AppLocalizations.of(context)!.saveButton),
            ),
          ],
        ),
      );
      if (result != null && result.isNotEmpty) {
        await Preferences.instance.setString(Preferences.password, result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
      ),
      home: Stack(
        children: const [
          QuickActionsInitializer(),
          PanicScreen(),
        ],
      ),
    );
  }
}

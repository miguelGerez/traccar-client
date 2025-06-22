import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import 'l10n/app_localizations.dart';
import 'main_screen.dart';
import 'preferences.dart';

class PanicScreen extends StatelessWidget {
  const PanicScreen({super.key});

  Future<void> _sendSos(BuildContext context) async {
    try {
      await bg.BackgroundGeolocation.getCurrentPosition(
        samples: 1,
        persist: true,
        extras: {'alarm': 'sos'},
      );
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.sosSentMessage)),
        );
      }
    } catch (error) {
      developer.log('Failed to send alert', error: error);
    }
  }

  Future<void> _openMainScreen(BuildContext context) async {
    final stored = Preferences.instance.getString(Preferences.password);
    if (stored != null && stored.isNotEmpty) {
      final controller = TextEditingController();
      final result = await showDialog<String>(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(AppLocalizations.of(context)!.passwordPrompt),
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
              child: Text(AppLocalizations.of(context)!.okButton),
            ),
          ],
        ),
      );
      if (result == stored) {
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const MainScreen()),
          );
        }
      } else if (result != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.invalidPassword)),
        );
      }
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const MainScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _openMainScreen(context),
          ),
        ],
      ),
      body: Center(
        child: FilledButton(
          onPressed: () => _sendSos(context),
          child: Text(AppLocalizations.of(context)!.sosAction),
        ),
      ),
    );
  }
}

import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import 'l10n/app_localizations.dart';
import 'main_screen.dart';

class PanicScreen extends StatelessWidget {
  const PanicScreen({super.key});

  Future<void> _sendSos() async {
    try {
      await bg.BackgroundGeolocation.getCurrentPosition(
        samples: 1,
        persist: true,
        extras: {'alarm': 'sos'},
      );
    } catch (error) {
      developer.log('Failed to send alert', error: error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MainScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: FilledButton(
          onPressed: _sendSos,
          child: Text(AppLocalizations.of(context)!.sosAction),
        ),
      ),
    );
  }
}

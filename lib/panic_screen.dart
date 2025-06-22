import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart' as bg;

import 'l10n/app_localizations.dart';
import 'main_screen.dart';
import 'preferences.dart';
import 'quick_call_section.dart';

class PanicScreen extends StatefulWidget {
  const PanicScreen({super.key});

  @override
  State<PanicScreen> createState() => _PanicScreenState();
}

class _PanicScreenState extends State<PanicScreen> {
  double _scale = 1.0;
  bool _hovering = false;

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: MouseRegion(
              onEnter: (_) => setState(() {
                _hovering = true;
                _scale = 1.05;
              }),
              onExit: (_) => setState(() {
                _hovering = false;
                _scale = 1.0;
              }),
              child: GestureDetector(
                onLongPress: () => _sendSos(context),
                onTapDown: (_) => setState(() => _scale = 0.95),
                onTapUp: (_) => setState(() => _scale = _hovering ? 1.05 : 1.0),
                onTapCancel: () => setState(() => _scale = _hovering ? 1.05 : 1.0),
                child: AnimatedScale(
                  scale: _scale,
                  duration: const Duration(milliseconds: 200),
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Color(0xffef4444), Color(0xffdc2626)],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          offset: Offset(0, 8),
                          blurRadius: 20,
                        ),
                      ],
                    ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.warning_amber_rounded, size: 64, color: Colors.white),
                    SizedBox(height: 16),
                    Text(
                      'EMERGENCIA',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Opacity(
                      opacity: 0.7,
                      child: Text(
                        'Mantén presionado',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24.0),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: QuickCallSection(),
          ),
        ],
      ),
    );
  }
}

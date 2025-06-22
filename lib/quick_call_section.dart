import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class QuickCallSection extends StatelessWidget {
  const QuickCallSection({Key? key}) : super(key: key);

  Future<void> _callEmergency() async {
    final Uri uri = Uri(scheme: 'tel', path: '911');
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      color: isDark ? const Color(0xff1f2937) : const Color(0xfff9fafb),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.phone, size: 24, color: isDark ? Colors.white : Colors.black87),
                const SizedBox(width: 8),
                Text(
                  'Llamada Rápida',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: isDark ? Colors.white : Colors.black87,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Toca para llamar directamente al 911.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: isDark ? Colors.grey[300] : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xffef4444), // rojo de alerta
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                ),
                onPressed: _callEmergency,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.shield, size: 20),
                    SizedBox(width: 10),
                    Text(
                      'Llamar al 911',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

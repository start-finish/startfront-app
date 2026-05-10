import 'package:flutter/material.dart';
import '../../core/components/glass_card.dart';
import '../../core/constants/theme.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SETTINGS',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.5)),
          const SizedBox(height: 8),
          Text('Configure application preferences',
              style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5))),
          const SizedBox(height: 32),
          _section('General', [
            _toggle('Dark Mode', true),
            _toggle('Enable Notifications', true),
            _toggle('Auto-save', false),
          ]),
          const SizedBox(height: 20),
          _section('Security', [
            _toggle('Two-Factor Authentication', true),
            _toggle('Session Timeout', true),
          ]),
          const SizedBox(height: 20),
          _section('About', [
            _info('Version', '0.0.1'),
            _info('Environment', const String.fromEnvironment('FLAVOR', defaultValue: 'dev').toUpperCase()),
            _info('Flutter', 'Web SPA'),
          ]),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white)),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _toggle(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          Switch(value: value, onChanged: (_) {}, activeThumbColor: AppTheme.primaryColor),
        ],
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14)),
          Text(value, style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 14)),
        ],
      ),
    );
  }
}

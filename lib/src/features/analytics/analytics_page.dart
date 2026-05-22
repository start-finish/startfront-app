import 'package:flutter/material.dart';
import '../../core/components/glass_card.dart';
import '../../core/constants/theme.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'ANALYTICS',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 1.5),
          ),
          const SizedBox(height: 8),
          Text(
            'Monitor performance metrics and trends',
            style: TextStyle(fontSize: 14, color: Colors.white.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 32),
          LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth > 700;
              if (wide) {
                return Row(
                  children: [
                    Expanded(
                      child: _metricCard(
                        'Conversion Rate',
                        '3.24%',
                        '+0.8%',
                        Icons.trending_up_rounded,
                        AppTheme.primaryColor,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _metricCard('Avg Session', '4m 32s', '+12%', Icons.timer_rounded, const Color(0xFF8A2BE2)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _metricCard(
                        'Bounce Rate',
                        '24.1%',
                        '-3.2%',
                        Icons.exit_to_app_rounded,
                        const Color(0xFFFFA726),
                      ),
                    ),
                  ],
                );
              } else {
                return Column(
                  children: [
                    _metricCard('Conversion Rate', '3.24%', '+0.8%', Icons.trending_up_rounded, AppTheme.primaryColor),
                    const SizedBox(height: 16),
                    _metricCard('Avg Session', '4m 32s', '+12%', Icons.timer_rounded, const Color(0xFF8A2BE2)),
                    const SizedBox(height: 16),
                    _metricCard('Bounce Rate', '24.1%', '-3.2%', Icons.exit_to_app_rounded, const Color(0xFFFFA726)),
                  ],
                );
              }
            },
          ),
          const SizedBox(height: 28),
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Traffic Overview',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [0.5, 0.65, 0.45, 0.8, 0.7, 0.9, 0.6, 0.75, 0.55, 0.85, 0.7, 0.95].map((h) {
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: FractionallySizedBox(
                            alignment: Alignment.bottomCenter,
                            heightFactor: h,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    AppTheme.primaryColor.withValues(alpha: 0.15),
                                    AppTheme.primaryColor.withValues(alpha: 0.5),
                                  ],
                                ),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _metricCard(String title, String value, String change, IconData icon, Color color) {
    final positive = change.startsWith('+');
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const Spacer(),
              Text(
                change,
                style: TextStyle(
                  color: positive ? Colors.greenAccent : Colors.redAccent,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 13, color: Colors.white.withValues(alpha: 0.5))),
        ],
      ),
    );
  }
}

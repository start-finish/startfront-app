import 'dart:ui';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/layout_provider.dart';
import '../../core/components/glass_card.dart';
import '../../core/constants/theme.dart';
import 'components/stats_card.dart';
import 'components/dashboard_chart.dart';
import '../../core/components/hoverable_text_button.dart';

/// Main dashboard page with stats grid, chart areas, and activity log.
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  @override
  void initState() {
    super.initState();
    // Update the layout title when the page is mounted.
    Future.microtask(() {
      ref.read(pageTitleProvider.notifier).state = 'ADMIN DASHBOARD';
      ref.read(pageSubtitleProvider.notifier).state = '';
      ref.read(headerActionsProvider.notifier).state = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          // ── Stats Grid ──
          _buildStatsGrid(),

          // ── Charts Row ──
          _buildChartsRow(),

          // ── Activity Log ──
          _buildActivityLog(),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            SizedBox(
              width: (constraints.maxWidth - 48) / 4 > 240
                  ? (constraints.maxWidth - 48) / 4
                  : (constraints.maxWidth - 16) / 2,
              height: 180,
              child: const StatsCard(
                title: 'Total Users',
                value: '1,247',
                change: '+12.5%',
                iconPath: 'assets/icons/users.svg',
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 48) / 4 > 240
                  ? (constraints.maxWidth - 48) / 4
                  : (constraints.maxWidth - 16) / 2,
              height: 180,
              child: const StatsCard(
                title: 'Active Sessions',
                value: '48',
                change: '+8.3%',
                iconPath: 'assets/icons/active chart.svg',
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 48) / 4 > 240
                  ? (constraints.maxWidth - 48) / 4
                  : (constraints.maxWidth - 16) / 2,
              height: 180,
              child: const StatsCard(
                title: 'Page Views',
                value: '11,332',
                change: '+23.1%',
                iconPath: 'assets/icons/eye.svg',
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 48) / 4 > 240
                  ? (constraints.maxWidth - 48) / 4
                  : (constraints.maxWidth - 16) / 2,
              height: 180,
              child: const StatsCard(
                title: 'Growth Rate',
                value: '4.6%',
                change: '+2.4%',
                iconPath: 'assets/icons/chart.svg',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChartsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 800) {
          return Row(
            spacing: 24,
            children: [
              Expanded(
                child: _HoverableChartCard(
                  title: 'Recently Register',
                  subtitle: 'Last 7 days',
                  color: const Color(0xFF3B82F6),
                  spots: const [
                    FlSpot(0, 3),
                    FlSpot(1, 4),
                    FlSpot(2, 3.5),
                    FlSpot(3, 5),
                    FlSpot(4, 4),
                    FlSpot(5, 6),
                    FlSpot(6, 5.5),
                  ],
                ),
              ),
              Expanded(
                child: _HoverableChartCard(
                  title: 'Recently Subscription',
                  subtitle: 'This month',
                  color: AppTheme.primaryColor,
                  spots: const [
                    FlSpot(0, 2),
                    FlSpot(1, 3),
                    FlSpot(2, 2.5),
                    FlSpot(3, 4),
                    FlSpot(4, 3.5),
                    FlSpot(5, 5),
                    FlSpot(6, 4.5),
                  ],
                ),
              ),
            ],
          );
        } else {
          return Column(
            spacing: 16,
            children: [
              _HoverableChartCard(
                height: 300,
                title: 'Recently Register',
                subtitle: 'Last 7 days',
                color: const Color(0xFF3B82F6),
                spots: const [
                  FlSpot(0, 3),
                  FlSpot(1, 4),
                  FlSpot(2, 3.5),
                  FlSpot(3, 5),
                  FlSpot(4, 4),
                  FlSpot(5, 6),
                  FlSpot(6, 5.5),
                ],
              ),
              _HoverableChartCard(
                height: 300,
                title: 'Recently Subscription',
                subtitle: 'This month',
                color: const Color(0xFF6366F1),
                spots: const [
                  FlSpot(0, 2),
                  FlSpot(1, 3),
                  FlSpot(2, 2.5),
                  FlSpot(3, 4),
                  FlSpot(4, 3.5),
                  FlSpot(5, 5),
                  FlSpot(6, 4.5),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildActivityLog() {
    return GlassCard(
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          // Background Glows
          Positioned(
            bottom: -20,
            left: 20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: const Color(0xFF8A2BE2).withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),
          Positioned(
            bottom: -40,
            right: 60,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 50, sigmaY: 50),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recently Action Log',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                    HoverableTextButton(
                      text: 'View All',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.4),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                _LogItem(
                  action: 'Update user details',
                  target: 'alex@mail.com',
                  time: '2 min ago',
                  type: 'Update',
                  color: const Color(0xFF3B82F6),
                ),
                _LogItem(
                  action: 'Delete user permanently',
                  target: 'jane.doe@site.io',
                  time: '15 min ago',
                  type: 'Delete',
                  color: const Color(0xFFEF4444),
                ),
                _LogItem(
                  action: 'Create new subscription plan',
                  target: 'System',
                  time: '1 hr ago',
                  type: 'Create',
                  color: const Color(0xFF10B981),
                ),
                _LogItem(
                  action: 'Change system settings',
                  target: 'Admin',
                  time: '3 hr ago',
                  type: 'Update',
                  color: const Color(0xFF3B82F6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HoverableChartCard extends StatefulWidget {
  final double height;
  final String title;
  final String subtitle;
  final Color color;
  final List<FlSpot> spots;

  const _HoverableChartCard({
    this.height = 350,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.spots,
  });

  @override
  State<_HoverableChartCard> createState() => _HoverableChartCardState();
}

class _HoverableChartCardState extends State<_HoverableChartCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GlassCard(
        height: widget.height,
        padding: const EdgeInsets.all(24),
        backgroundOpacity: _hovering ? 0.15 : 0.1,
        boxShadow: _hovering
            ? [
                BoxShadow(
                  color: widget.color.withValues(alpha: 0.05),
                  blurRadius: 20,
                  spreadRadius: 2,
                ),
              ]
            : null,
        child: DashboardChart(
          title: widget.title,
          subtitle: widget.subtitle,
          color: widget.color,
          spots: widget.spots,
        ),
      ),
    );
  }
}

class _LogItem extends StatefulWidget {
  final String action;
  final String target;
  final String time;
  final String type;
  final Color color;

  const _LogItem({
    required this.action,
    required this.target,
    required this.time,
    required this.type,
    required this.color,
  });

  @override
  State<_LogItem> createState() => _LogItemState();
}

class _LogItemState extends State<_LogItem> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        decoration: BoxDecoration(
          color: _hovering ? Colors.white.withValues(alpha: 0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            AnimatedScale(
              scale: _hovering ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.color.withValues(alpha: _hovering ? 0.2 : 0.1),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: _hovering
                      ? [
                          BoxShadow(
                            color: widget.color.withValues(alpha: 0.1),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ]
                      : null,
                ),
                child: Icon(
                  widget.type == 'Update'
                      ? Icons.edit_rounded
                      : widget.type == 'Delete'
                      ? Icons.delete_outline_rounded
                      : Icons.add_rounded,
                  color: widget.color,
                  size: 22,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.action,
                    style: TextStyle(
                      color: _hovering ? Colors.white : Colors.white.withValues(alpha: 0.9),
                      fontSize: 13,
                      fontWeight: _hovering ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.target,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: _hovering ? 0.6 : 0.4),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              widget.time,
              style: TextStyle(
                color: Colors.white.withValues(alpha: _hovering ? 0.5 : 0.3),
                fontSize: 11,
              ),
            ),
            const SizedBox(width: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: widget.color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                widget.type,
                style: TextStyle(color: widget.color, fontSize: 10, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

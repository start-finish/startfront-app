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
import '../../core/components/skeleton_loader.dart';
import 'dashboard_provider.dart';

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
    final dashboardAsync = ref.watch(dashboardDataProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 24,
        children: [
          // ── Stats Grid ──
          dashboardAsync.when(
            data: (data) => _buildStatsGrid(data),
            loading: () => _buildStatsGridSkeleton(),
            error: (err, stack) => _buildErrorState(err),
          ),

          // ── Charts Row ──
          dashboardAsync.when(
            data: (data) => _buildChartsRow(data),
            loading: () => _buildChartsRowSkeleton(),
            error: (err, stack) => const SizedBox.shrink(),
          ),

          // ── Activity Log ──
          dashboardAsync.when(
            data: (data) => _buildActivityLog(data),
            loading: () => _buildActivityLogSkeleton(),
            error: (err, stack) => const SizedBox.shrink(),
          ),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      final str = number.toString();
      final buffer = StringBuffer();
      for (int i = 0; i < str.length; i++) {
        if (i > 0 && (str.length - i) % 3 == 0) {
          buffer.write(',');
        }
        buffer.write(str[i]);
      }
      return buffer.toString();
    }
    return number.toString();
  }

  Color _parseHexColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF3B82F6);
    }
  }

  Widget _buildErrorState(dynamic error) {
    return Center(
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.error_outline_rounded, color: Colors.redAccent, size: 40),
            const SizedBox(height: 12),
            Text(
              'Failed to load dashboard metrics: $error',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGridSkeleton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: List.generate(4, (index) {
            return SizedBox(
              width: (constraints.maxWidth - 48) / 4 > 240
                  ? (constraints.maxWidth - 48) / 4
                  : (constraints.maxWidth - 16) / 2,
              height: 180,
              child: const GlassCard(
                padding: EdgeInsets.all(24),
                borderRadius: 16,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SkeletonLoader(width: 48, height: 48, borderRadius: BorderRadius.all(Radius.circular(10))),
                        SkeletonLoader(width: 48, height: 16),
                      ],
                    ),
                    Spacer(),
                    SkeletonLoader(width: 100, height: 36),
                    SizedBox(height: 8),
                    SkeletonLoader(width: 80, height: 12),
                  ],
                ),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildChartsRowSkeleton() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 800;
        final cardHeight = isWide ? 350.0 : 300.0;
        final child = GlassCard(
          height: cardHeight,
          padding: const EdgeInsets.all(24),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SkeletonLoader(width: 150, height: 16),
                  SkeletonLoader(width: 60, height: 12),
                ],
              ),
              SizedBox(height: 24),
              Expanded(
                child: SkeletonLoader(
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                ),
              ),
            ],
          ),
        );

        if (isWide) {
          return Row(
            spacing: 24,
            children: [
              Expanded(child: child),
              Expanded(child: child),
            ],
          );
        } else {
          return Column(
            spacing: 16,
            children: [
              child,
              child,
            ],
          );
        }
      },
    );
  }

  Widget _buildActivityLogSkeleton() {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SkeletonLoader(width: 180, height: 18),
              SkeletonLoader(width: 60, height: 12),
            ],
          ),
          const SizedBox(height: 24),
          ...List.generate(4, (index) {
            return const Padding(
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
              child: Row(
                children: [
                  SkeletonLoader(width: 44, height: 44, borderRadius: BorderRadius.all(Radius.circular(10))),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonLoader(width: 180, height: 13),
                        SizedBox(height: 6),
                        SkeletonLoader(width: 120, height: 11),
                      ],
                    ),
                  ),
                  SkeletonLoader(width: 60, height: 11),
                  SizedBox(width: 24),
                  SkeletonLoader(width: 50, height: 20, borderRadius: BorderRadius.all(Radius.circular(6))),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStatsGrid(DashboardData data) {
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
              child: StatsCard(
                title: 'Total Users',
                value: _formatNumber(data.totalUsers),
                change: '+12.5%',
                iconPath: 'assets/icons/users.svg',
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 48) / 4 > 240
                  ? (constraints.maxWidth - 48) / 4
                  : (constraints.maxWidth - 16) / 2,
              height: 180,
              child: StatsCard(
                title: 'Active Sessions',
                value: _formatNumber(data.activeUsers),
                change: '+8.3%',
                iconPath: 'assets/icons/active chart.svg',
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 48) / 4 > 240
                  ? (constraints.maxWidth - 48) / 4
                  : (constraints.maxWidth - 16) / 2,
              height: 180,
              child: StatsCard(
                title: 'Page Views',
                value: _formatNumber(data.pageViews),
                change: '+23.1%',
                iconPath: 'assets/icons/eye.svg',
              ),
            ),
            SizedBox(
              width: (constraints.maxWidth - 48) / 4 > 240
                  ? (constraints.maxWidth - 48) / 4
                  : (constraints.maxWidth - 16) / 2,
              height: 180,
              child: StatsCard(
                title: 'Growth Rate',
                value: data.growthRate,
                change: '+2.4%',
                iconPath: 'assets/icons/chart.svg',
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildChartsRow(DashboardData data) {
    final dynamicOffset = (data.totalUsers % 5) * 0.2;

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
                  spots: [
                    FlSpot(0, 3 + dynamicOffset),
                    FlSpot(1, 4 + dynamicOffset),
                    FlSpot(2, 3.5 + dynamicOffset),
                    FlSpot(3, 5 + dynamicOffset),
                    FlSpot(4, 4 + dynamicOffset),
                    FlSpot(5, 6 + dynamicOffset),
                    FlSpot(6, 5.5 + dynamicOffset),
                  ],
                ),
              ),
              Expanded(
                child: _HoverableChartCard(
                  title: 'Recently Subscription',
                  subtitle: 'This month',
                  color: AppTheme.primaryColor,
                  spots: [
                    FlSpot(0, 2 + dynamicOffset),
                    FlSpot(1, 3 + dynamicOffset),
                    FlSpot(2, 2.5 + dynamicOffset),
                    FlSpot(3, 4 + dynamicOffset),
                    FlSpot(4, 3.5 + dynamicOffset),
                    FlSpot(5, 5 + dynamicOffset),
                    FlSpot(6, 4.5 + dynamicOffset),
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
                spots: [
                  FlSpot(0, 3 + dynamicOffset),
                  FlSpot(1, 4 + dynamicOffset),
                  FlSpot(2, 3.5 + dynamicOffset),
                  FlSpot(3, 5 + dynamicOffset),
                  FlSpot(4, 4 + dynamicOffset),
                  FlSpot(5, 6 + dynamicOffset),
                  FlSpot(6, 5.5 + dynamicOffset),
                ],
              ),
              _HoverableChartCard(
                height: 300,
                title: 'Recently Subscription',
                subtitle: 'This month',
                color: const Color(0xFF6366F1),
                spots: [
                  FlSpot(0, 2 + dynamicOffset),
                  FlSpot(1, 3 + dynamicOffset),
                  FlSpot(2, 2.5 + dynamicOffset),
                  FlSpot(3, 4 + dynamicOffset),
                  FlSpot(4, 3.5 + dynamicOffset),
                  FlSpot(5, 5 + dynamicOffset),
                  FlSpot(6, 4.5 + dynamicOffset),
                ],
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildActivityLog(DashboardData data) {
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
                ...data.activityLog.map((item) {
                  return _LogItem(
                    action: item.action,
                    target: item.target,
                    time: item.time,
                    type: item.type,
                    color: _parseHexColor(item.color),
                  );
                }),
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

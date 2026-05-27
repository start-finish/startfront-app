import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/base_service.dart';

class DashboardActivityLog {
  final String action;
  final String target;
  final String time;
  final String type;
  final String color;

  DashboardActivityLog({
    required this.action,
    required this.target,
    required this.time,
    required this.type,
    required this.color,
  });

  factory DashboardActivityLog.fromJson(Map<String, dynamic> json) {
    return DashboardActivityLog(
      action: json['action'] ?? '',
      target: json['target'] ?? '',
      time: json['time'] ?? '',
      type: json['type'] ?? '',
      color: json['color'] ?? '',
    );
  }
}

class DashboardData {
  final int totalUsers;
  final int activeUsers;
  final int pageViews;
  final String growthRate;
  final List<DashboardActivityLog> activityLog;

  DashboardData({
    required this.totalUsers,
    required this.activeUsers,
    required this.pageViews,
    required this.growthRate,
    required this.activityLog,
  });

  factory DashboardData.fromJson(Map<String, dynamic> json) {
    final list = json['activity_log'] as List? ?? [];
    return DashboardData(
      totalUsers: (json['total_users'] as num? ?? 0).toInt(),
      activeUsers: (json['active_users'] as num? ?? 0).toInt(),
      pageViews: (json['page_views'] as num? ?? 0).toInt(),
      growthRate: json['growth_rate'] ?? '0%',
      activityLog: list.map((e) => DashboardActivityLog.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}

final dashboardDataProvider = FutureProvider.autoDispose<DashboardData>((ref) async {
  final baseService = ref.watch(baseServiceProvider);
  final response = await baseService.getDashboardData();
  return DashboardData.fromJson(response as Map<String, dynamic>);
});

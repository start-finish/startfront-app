import 'dart:async';
import 'package:flutter/material.dart';
import 'glass_card.dart';
import '../constants/theme.dart';

enum NotificationType { success, error, info }

class NotificationData {
  final String id;
  final String title;
  final String message;
  final NotificationType type;

  NotificationData({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
  });
}

class AppNotification {
  static final List<NotificationData> _activeNotifications = [];
  static OverlayEntry? _overlayEntry;
  static final _streamController = StreamController<List<NotificationData>>.broadcast();

  static void show(
    BuildContext context, {
    required String title,
    required String message,
    NotificationType type = NotificationType.success,
  }) {
    final data = NotificationData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      message: message,
      type: type,
    );

    _activeNotifications.add(data);

    if (_overlayEntry == null) {
      _overlayEntry = OverlayEntry(
        builder: (context) => _NotificationContainer(
          stream: _streamController.stream,
          initialData: _activeNotifications,
          onRemove: (id) => _removeNotification(id),
        ),
      );
      Overlay.of(context).insert(_overlayEntry!);
    }

    _streamController.add(List.from(_activeNotifications));
  }

  static void _removeNotification(String id) {
    _activeNotifications.removeWhere((n) => n.id == id);
    if (_activeNotifications.isEmpty) {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } else {
      _streamController.add(List.from(_activeNotifications));
    }
  }
}

class _NotificationContainer extends StatelessWidget {
  final Stream<List<NotificationData>> stream;
  final List<NotificationData> initialData;
  final Function(String) onRemove;

  const _NotificationContainer({
    required this.stream,
    required this.initialData,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<NotificationData>>(
      stream: stream,
      initialData: initialData,
      builder: (context, snapshot) {
        final notifications = snapshot.data ?? [];
        return Positioned(
          top: 40,
          right: 40,
          child: SizedBox(
            width: 320,
            height: MediaQuery.of(context).size.height - 80,
            child: Stack(
              clipBehavior: Clip.none,
              children: notifications.asMap().entries.map((entry) {
                final index = entry.key;
                final data = entry.value;
                return AnimatedPositioned(
                  key: ValueKey(data.id),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutQuart,
                  top: index * 96.0, // Height + Spacing
                  right: 0,
                  left: 0,
                  child: _NotificationWidget(
                    data: data,
                    onDismiss: () => onRemove(data.id),
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class _NotificationWidget extends StatefulWidget {
  final NotificationData data;
  final VoidCallback onDismiss;

  const _NotificationWidget({
    required this.data,
    required this.onDismiss,
    super.key,
  });

  @override
  State<_NotificationWidget> createState() => _NotificationWidgetState();
}

class _NotificationWidgetState extends State<_NotificationWidget> with TickerProviderStateMixin {
  late AnimationController _entranceController;
  late AnimationController _timerController;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _opacityAnimation;
  bool _isExiting = false;

  @override
  void initState() {
    super.initState();
    _entranceController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _timerController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _offsetAnimation =
        Tween<Offset>(
          begin: const Offset(1.2, 0.0),
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutBack,
          ),
        );

    _opacityAnimation =
        Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeIn,
          ),
        );

    _entranceController.forward();
    _timerController.forward().then((_) {
      if (mounted && !_isExiting) {
        _dismiss();
      }
    });
  }

  void _dismiss() {
    if (_isExiting) return;
    setState(() => _isExiting = true);

    _offsetAnimation =
        Tween<Offset>(
          begin: Offset.zero,
          end: const Offset(0.0, -1.2),
        ).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeInBack,
          ),
        );

    _entranceController.reverse().then((_) {
      if (mounted) widget.onDismiss();
    });
  }

  @override
  void dispose() {
    _entranceController.dispose();
    _timerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color accentColor = switch (widget.data.type) {
      NotificationType.success => AppTheme.primaryColor,
      NotificationType.error => Colors.redAccent,
      NotificationType.info => Colors.blueAccent,
    };

    final IconData icon = switch (widget.data.type) {
      NotificationType.success => Icons.check_circle_rounded,
      NotificationType.error => Icons.error_rounded,
      NotificationType.info => Icons.info_rounded,
    };

    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Material(
          color: Colors.transparent,
          child: GlassCard(
            backgroundOpacity: 0.18,
            borderOpacity: 0.25,
            borderRadius: 16,
            padding: EdgeInsets.zero,
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: accentColor.withValues(alpha: 0.2),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Icon(icon, color: accentColor, size: 24),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              widget.data.title.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.0,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              widget.data.message,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white24, size: 16),
                        onPressed: _dismiss,
                      ),
                    ],
                  ),
                ),
                // Timer Progress Bar
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: AnimatedBuilder(
                    animation: _timerController,
                    builder: (context, child) {
                      return FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: 1.0 - _timerController.value,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.4),
                            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                            boxShadow: [
                              BoxShadow(
                                color: accentColor.withValues(alpha: 0.2),
                                blurRadius: 4,
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

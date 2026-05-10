import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../core/components/glass_card.dart';

/// Animated stats card with icon, value, change indicator, and hover effect.
class StatsCard extends StatefulWidget {
  final String title;
  final String value;
  final String change;
  final String iconPath;
  final Color? accentColor;

  const StatsCard({
    super.key,
    required this.title,
    required this.value,
    required this.change,
    required this.iconPath,
    this.accentColor,
  });

  @override
  State<StatsCard> createState() => _StatsCardState();
}

class _StatsCardState extends State<StatsCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GlassCard(
        padding: const EdgeInsets.all(24),
        backgroundOpacity: _hovering ? 0.45 : 0.35,
        borderRadius: 16,
        boxShadow: _hovering
            ? [
                BoxShadow(
                  color: Colors.white.withValues(alpha: 0.08),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ]
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AnimatedScale(
                  scale: _hovering ? 1.2 : 1.0,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOutBack,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    transform: Matrix4.translationValues(0, _hovering ? -4 : 0, 0),
                    width: 48,
                    height: 48,
                    child: SvgPicture.asset(
                      widget.iconPath,
                      colorFilter: ColorFilter.mode(
                        _hovering ? Colors.white : Colors.white.withValues(alpha: 0.8),
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: const Color(0xFF10B981),
                    fontWeight: _hovering ? FontWeight.w800 : FontWeight.w700,
                    fontSize: 16,
                  ),
                  child: Text(widget.change),
                ),
              ],
            ),
            const Spacer(),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: -1,
                height: 1,
              ),
              child: Text(widget.value),
            ),
            const SizedBox(height: 8),
            Text(
              widget.title,
              style: TextStyle(
                fontSize: 13,
                color: Colors.white.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

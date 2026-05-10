import 'package:flutter/material.dart';

/// A text button that changes color and cursor on hover.
class HoverableTextButton extends StatefulWidget {
  final String text;
  final TextStyle style;
  final VoidCallback? onTap;

  const HoverableTextButton({
    super.key,
    required this.text,
    required this.style,
    this.onTap,
  });

  @override
  State<HoverableTextButton> createState() => _HoverableTextButtonState();
}

class _HoverableTextButtonState extends State<HoverableTextButton> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 200),
          style: widget.style.copyWith(
            color: _hovering ? Colors.white : widget.style.color,
          ),
          child: Text(widget.text),
        ),
      ),
    );
  }
}

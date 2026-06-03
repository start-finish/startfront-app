import 'package:flutter/material.dart';
import '../constants/theme.dart';

class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalItems;
  final int pageSize;
  final ValueChanged<int> onPageChanged;

  const PaginationBar({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.totalItems,
    required this.pageSize,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (totalItems == 0 || totalPages <= 1) {
      return const SizedBox.shrink();
    }

    final startItem = (currentPage - 1) * pageSize + 1;
    var endItem = currentPage * pageSize;
    if (endItem > totalItems) {
      endItem = totalItems;
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 650;

        final infoText = Text(
          'Showing $startItem - $endItem of $totalItems entries',
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 13,
            fontWeight: FontWeight.w400,
          ),
        );

        final controls = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Previous Button
            _NavigationButton(
              icon: Icons.chevron_left_rounded,
              isEnabled: currentPage > 1,
              onTap: () => onPageChanged(currentPage - 1),
            ),
            const SizedBox(width: 8),

            // Page Numbers
            ..._buildPageNumbers(),

            const SizedBox(width: 8),
            // Next Button
            _NavigationButton(
              icon: Icons.chevron_right_rounded,
              isEnabled: currentPage < totalPages,
              onTap: () => onPageChanged(currentPage + 1),
            ),
          ],
        );

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: AppTheme.glassDecoration(
            borderRadius: 12,
            opacity: 0.03,
            borderOpacity: 0.05,
          ),
          child: isMobile
              ? Column(
                  spacing: 12,
                  children: [
                    infoText,
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: controls,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    infoText,
                    controls,
                  ],
                ),
        );
      },
    );
  }

  List<Widget> _buildPageNumbers() {
    final List<Widget> widgets = [];
    final List<int> pages = [];

    if (totalPages <= 5) {
      for (var i = 1; i <= totalPages; i++) {
        pages.add(i);
      }
    } else {
      pages.add(1);
      var start = currentPage - 1;
      var end = currentPage + 1;

      if (start <= 1) {
        start = 2;
        end = 4;
      } else if (end >= totalPages) {
        end = totalPages - 1;
        start = totalPages - 3;
      }

      if (start > 2) {
        pages.add(-1); // represent ellipsis ...
      }

      for (var i = start; i <= end; i++) {
        pages.add(i);
      }

      if (end < totalPages - 1) {
        pages.add(-2); // represent ellipsis ...
      }

      pages.add(totalPages);
    }

    for (var i = 0; i < pages.length; i++) {
      final page = pages[i];
      if (page < 0) {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              '...',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      } else {
        widgets.add(
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _PagePill(
              page: page,
              isSelected: page == currentPage,
              onTap: () => onPageChanged(page),
            ),
          ),
        );
      }
    }

    return widgets;
  }
}

class _PagePill extends StatefulWidget {
  final int page;
  final bool isSelected;
  final VoidCallback onTap;

  const _PagePill({
    required this.page,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<_PagePill> createState() => _PagePillState();
}

class _PagePillState extends State<_PagePill> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: widget.isSelected ? AppTheme.primaryGradient : null,
              color: widget.isSelected
                  ? null
                  : _isHovered
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.white.withValues(alpha: 0.03),
              border: Border.all(
                color: widget.isSelected
                    ? Colors.transparent
                    : _isHovered
                        ? AppTheme.primaryColor.withValues(alpha: 0.4)
                        : Colors.white.withValues(alpha: 0.05),
              ),
              boxShadow: widget.isSelected ? AppTheme.glowShadow : null,
            ),
            child: Text(
              '${widget.page}',
              style: TextStyle(
                color: widget.isSelected ? Colors.white : Colors.white.withValues(alpha: _isHovered ? 0.9 : 0.6),
                fontSize: 13,
                fontWeight: widget.isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationButton extends StatefulWidget {
  final IconData icon;
  final bool isEnabled;
  final VoidCallback onTap;

  const _NavigationButton({
    required this.icon,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  State<_NavigationButton> createState() => _NavigationButtonState();
}

class _NavigationButtonState extends State<_NavigationButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.isEnabled) {
      return Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.01),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.white.withValues(alpha: 0.02)),
        ),
        child: Icon(
          widget.icon,
          color: Colors.white.withValues(alpha: 0.15),
          size: 20,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.1 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: _isHovered ? Colors.white.withValues(alpha: 0.1) : Colors.white.withValues(alpha: 0.03),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isHovered ? AppTheme.primaryColor.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.05),
              ),
            ),
            child: Icon(
              widget.icon,
              color: _isHovered ? Colors.white : Colors.white.withValues(alpha: 0.6),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}

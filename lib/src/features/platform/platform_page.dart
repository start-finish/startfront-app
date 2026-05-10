import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/components/glass_card.dart';
import '../../core/constants/theme.dart';
import '../../core/providers/layout_provider.dart';

class PlatformPage extends ConsumerStatefulWidget {
  const PlatformPage({super.key});

  @override
  ConsumerState<PlatformPage> createState() => _PlatformPageState();
}

class _PlatformPageState extends ConsumerState<PlatformPage> {
  String _selectedStatus = 'All Status';

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(pageTitleProvider.notifier).state = 'PLATFORM SCREENS';
      ref.read(pageSubtitleProvider.notifier).state = '';
      ref.read(headerActionsProvider.notifier).state = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Actions Row
          _buildTopActions(),
          const SizedBox(height: 24),

          // Cards Grid
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 1200 ? 3 : (constraints.maxWidth > 800 ? 2 : 1);
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 24,
                  mainAxisSpacing: 24,
                  childAspectRatio: 1.25,
                ),
                itemCount: _screens.length,
                itemBuilder: (context, index) {
                  return _ScreenCard(screen: _screens[index]);
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildStatusFilter() {
    return PopupMenuButton<String>(
      offset: const Offset(0, 50),
      color: const Color(0xFF1E293B).withValues(alpha: 0.95),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
      ),
      elevation: 20,
      onSelected: (String value) {
        setState(() {
          _selectedStatus = value;
        });
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        _buildPopupItem('All Status', Icons.filter_list_rounded),
        _buildPopupItem('Published', Icons.check_circle_outline_rounded),
        _buildPopupItem('Draft', Icons.edit_document),
      ],
      child: _buildHeaderButton(
        label: _selectedStatus,
        icon: Icons.filter_list_rounded,
        onTap: null,
        isDropdown: true,
      ),
    );
  }

  PopupMenuItem<String> _buildPopupItem(String value, IconData icon) {
    final bool isSelected = _selectedStatus == value;
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        children: [
          Icon(
            icon,
            size: 18,
            color: isSelected ? AppTheme.primaryColor : Colors.white.withValues(alpha: 0.6),
          ),
          const SizedBox(width: 12),
          Text(
            value,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.white.withValues(alpha: 0.8),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
          if (isSelected) ...[
            const Spacer(),
            Icon(Icons.check, size: 16, color: AppTheme.primaryColor),
          ],
        ],
      ),
    );
  }

  Widget _buildTopActions() {
    final isSmall = MediaQuery.of(context).size.width < 1200;

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      alignment: WrapAlignment.start,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        // New Screen Button
        _buildHeaderButton(
          label: 'New Screen',
          icon: Icons.add,
          onTap: () {},
          isPrimary: true,
        ),

        // Count (Only show if not too small)
        if (!isSmall)
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              '${_screens.length} screens found',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

        // All Status Dropdown
        _buildStatusFilter(),

        // Search Bar
        Container(
          constraints: const BoxConstraints(maxWidth: 320),
          width: isSmall ? double.infinity : 280,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.05),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
          ),
          child: Row(
            children: [
              Icon(Icons.search, color: Colors.white.withValues(alpha: 0.4), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  style: const TextStyle(color: Colors.white, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'Search Screen...',
                    hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
                    border: InputBorder.none,
                    isDense: true,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderButton({
    required String label,
    required IconData icon,
    VoidCallback? onTap,
    bool isPrimary = false,
    bool isDropdown = false,
  }) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        final content = AnimatedScale(
          scale: isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutBack,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              gradient: isPrimary ? AppTheme.primaryGradient : null,
              color: isPrimary ? null : Colors.white.withValues(alpha: isHovered ? 0.1 : 0.05),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.white.withValues(alpha: isHovered ? 0.2 : 0.1)),
              boxShadow: isPrimary
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: isHovered ? 0.5 : 0.3),
                        blurRadius: isHovered ? 16 : 12,
                        spreadRadius: isHovered ? 2 : 1,
                      ),
                    ]
                  : isHovered
                  ? [
                      BoxShadow(
                        color: Colors.white.withValues(alpha: 0.05),
                        blurRadius: 8,
                        spreadRadius: 0,
                      ),
                    ]
                  : null,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
                if (isDropdown) ...[
                  const SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white.withValues(alpha: 0.5), size: 18),
                ],
              ],
            ),
          ),
        );

        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: (onTap != null || isDropdown) ? SystemMouseCursors.click : SystemMouseCursors.basic,
          child: onTap != null ? GestureDetector(onTap: onTap, child: content) : content,
        );
      },
    );
  }
}

class _ScreenCard extends StatefulWidget {
  final ScreenData screen;
  const _ScreenCard({required this.screen});

  @override
  State<_ScreenCard> createState() => _ScreenCardState();
}

class _ScreenCardState extends State<_ScreenCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GlassCard(
        padding: EdgeInsets.zero,
        backgroundOpacity: _isHovered ? 0.15 : 0.08,
        borderRadius: 16,
        child: Column(
          children: [
            // Preview Area
            Expanded(
              flex: 5,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.03),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(
                              widget.screen.icon1,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(Colors.white.withValues(alpha: 0.5), BlendMode.srcIn),
                            ),
                            const SizedBox(width: 12),
                            SvgPicture.asset(
                              widget.screen.icon2,
                              width: 24,
                              height: 24,
                              colorFilter: ColorFilter.mode(Colors.white.withValues(alpha: 0.5), BlendMode.srcIn),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.screen.title.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 16,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          widget.screen.path,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.3),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (_isHovered)
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.2),
                          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        child: Center(
                          child: Icon(Icons.play_circle_filled_rounded, color: Colors.white, size: 48),
                        ),
                      ),
                    ),
                ],
              ),
            ),

            // Content Area
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.screen.title.toUpperCase(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              widget.screen.category,
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.4),
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: widget.screen.status == 'Published'
                                ? const Color(0xFF10B981).withValues(alpha: 0.2)
                                : const Color(0xFFF59E0B).withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            widget.screen.status,
                            style: TextStyle(
                              color: widget.screen.status == 'Published'
                                  ? const Color(0xFF34D399)
                                  : const Color(0xFFFBBF24),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          'Modified ',
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.3), fontSize: 11),
                        ),
                        Text(
                          widget.screen.modifiedAt,
                          style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 11),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _buildActionButton(
                            iconPath: 'assets/icons/edit.svg',
                            label: 'Edit',
                            onTap: () {},
                          ),
                        ),
                        const SizedBox(width: 8),
                        _buildSmallAction('assets/icons/eye.svg', () {}),
                        const SizedBox(width: 8),
                        _buildSmallAction('assets/icons/copy.svg', () {}),
                        const SizedBox(width: 8),
                        _buildSmallAction('assets/icons/delete.svg', () {}, isDestructive: true),
                      ],
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

  Widget _buildActionButton({required String iconPath, required String label, required VoidCallback onTap}) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedScale(
              scale: isHovered ? 1.02 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: isHovered ? 0.12 : 0.05),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white.withValues(alpha: isHovered ? 0.25 : 0.1)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      iconPath,
                      colorFilter: ColorFilter.mode(
                        Colors.white.withValues(alpha: isHovered ? 1.0 : 0.7),
                        BlendMode.srcIn,
                      ),
                      width: 32,
                      height: 32,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        label,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: isHovered ? 1.0 : 0.8),
                          fontSize: 12,
                          fontWeight: isHovered ? FontWeight.w700 : FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmallAction(String iconPath, VoidCallback onTap, {bool isDestructive = false}) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: AnimatedScale(
              scale: isHovered ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOutBack,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: isDestructive
                      ? Colors.red.withValues(alpha: isHovered ? 0.2 : 0.1)
                      : Colors.white.withValues(alpha: isHovered ? 0.12 : 0.05),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: isDestructive
                        ? Colors.red.withValues(alpha: isHovered ? 0.4 : 0.2)
                        : Colors.white.withValues(alpha: isHovered ? 0.25 : 0.1),
                  ),
                ),
                child: SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    isDestructive
                        ? Colors.redAccent.withValues(alpha: isHovered ? 1.0 : 0.7)
                        : Colors.white.withValues(alpha: isHovered ? 1.0 : 0.7),
                    BlendMode.srcIn,
                  ),
                  width: 20,
                  height: 20,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class ScreenData {
  final String title;
  final String path;
  final String category;
  final String status;
  final String modifiedAt;
  final String icon1;
  final String icon2;

  const ScreenData({
    required this.title,
    required this.path,
    required this.category,
    required this.status,
    required this.modifiedAt,
    required this.icon1,
    required this.icon2,
  });
}

const _screens = [
  ScreenData(
    title: 'Dashboard',
    path: '/dashboard',
    category: 'Main',
    status: 'Published',
    modifiedAt: 'Just now',
    icon1: 'assets/icons/global.svg',
    icon2: 'assets/icons/chart.svg',
  ),
  ScreenData(
    title: 'Login',
    path: '/login',
    category: 'Auth',
    status: 'Draft',
    modifiedAt: '1 day ago',
    icon1: 'assets/icons/global.svg',
    icon2: 'assets/icons/settings.svg',
  ),
  ScreenData(
    title: 'Editor',
    path: '/editor',
    category: 'Tool',
    status: 'Published',
    modifiedAt: '3 days ago',
    icon1: 'assets/icons/global.svg',
    icon2: 'assets/icons/action.svg',
  ),
  ScreenData(
    title: 'Profile',
    path: '/profile',
    category: 'User',
    status: 'Published',
    modifiedAt: 'Just now',
    icon1: 'assets/icons/global.svg',
    icon2: 'assets/icons/users.svg',
  ),
];

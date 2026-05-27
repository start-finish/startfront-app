import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../core/components/glass_card.dart';
import '../../core/constants/theme.dart';
import '../../core/providers/layout_provider.dart';
import '../../core/components/confirm_dialog.dart';
import '../../core/components/app_notification.dart';
import '../../core/services/base_service.dart';
import '../auth/auth_provider.dart';
import '../../core/components/skeleton_loader.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  final Map<String, String> _settings = {
    'Platform Name': 'StartFront',
    'Default Language': 'English',
    'Timezone': 'UTC-8',
    'Connection Pool Size': '20',
    'Query Timeout': '30s',
    'Backup Frequency': 'Daily',
    'SMTP Server': 'smtp.startfront.com',
    'From Address': 'noreply@startfront.com',
    'Daily Limit': '10000',
    'Session Timeout': '24 hours',
    'Password Policy': 'Strong',
  };

  bool _is2FARequired = false;

  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isUpdatingPassword = false;

  final Map<String, TextEditingController> _controllers = {};
  final Map<String, int> _settingIds = {};
  bool _isLoadingSettings = false;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    _controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize default controllers
    _settings.forEach((key, val) {
      _controllers[key] = TextEditingController(text: val);
    });

    Future.microtask(() {
      if (!mounted) return;
      ref.read(pageTitleProvider.notifier).state = 'SETTINGS';
      ref.read(headerActionsProvider.notifier).state = [];
      _loadSettingsFromDB();
    });
  }

  void _loadSettingsFromDB() async {
    setState(() {
      _isLoadingSettings = true;
    });

    try {
      final baseService = ref.read(baseServiceProvider);
      final response = await baseService.listSettings();

      if (response != null && response is List) {
        final List<dynamic> list = response;
        for (var item in list) {
          final String key = item['key'] ?? '';
          final int id = item['id'] ?? 0;
          final dynamic valData = item['value'];

          if (key.isNotEmpty && id > 0) {
            _settingIds[key] = id;
            String valStr = '';
            if (valData is Map) {
              valStr = valData['value']?.toString() ?? '';
            } else {
              valStr = valData?.toString() ?? '';
            }

            if (key == '2FA Required') {
              setState(() {
                _is2FARequired = (valStr.toLowerCase() == 'true');
              });
            } else if (_controllers.containsKey(key)) {
              _controllers[key]?.text = valStr;
            }
          }
        }
      }
    } catch (e) {
      debugPrint('Error loading settings: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSettings = false;
        });
      }
    }
  }

  void _saveSettings() async {
    final confirmed = await showGeneralDialog<bool>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Save Settings',
      barrierColor: Colors.black.withValues(alpha: 0.6),
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, anim1, anim2) => const ConfirmDialog(
        title: 'Save Changes',
        message: 'Are you sure you want to apply these global settings? Some changes may require a platform restart.',
      ),
      transitionBuilder: (context, anim1, anim2, child) => FadeTransition(
        opacity: anim1,
        child: ScaleTransition(scale: anim1, child: child),
      ),
    );

    if (confirmed != true || !mounted) return;

    setState(() {
      _isLoadingSettings = true;
    });

    try {
      final baseService = ref.read(baseServiceProvider);

      // Compile settings to update
      final Map<String, String> valuesToUpdate = {};
      _controllers.forEach((key, controller) {
        valuesToUpdate[key] = controller.text.trim();
      });
      valuesToUpdate['2FA Required'] = _is2FARequired.toString();

      for (var entry in valuesToUpdate.entries) {
        final String key = entry.key;
        final String val = entry.value;
        final int? id = _settingIds[key];

        if (id != null && id > 0) {
          await baseService.updateSetting(id, key, val);
        } else {
          final createRes = await baseService.createSetting(key, val);
          if (createRes != null && createRes is Map) {
            final id = (createRes['id'] as num?)?.toInt();
            if (id != null) {
              _settingIds[key] = id;
            }
          }
        }
      }

      AppNotification.show(
        context,
        title: 'Success',
        message: 'Settings updated successfully.',
        type: NotificationType.success,
      );
    } catch (e) {
      AppNotification.show(
        context,
        title: 'Error',
        message: 'Failed to update settings: $e',
        type: NotificationType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingSettings = false;
        });
      }
    }
  }

  Widget _buildSaveButton() {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: _isLoadingSettings ? null : _saveSettings,
            child: AnimatedScale(
              scale: isHovered ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  gradient: AppTheme.primaryGradient,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                  boxShadow: isHovered
                      ? [
                          BoxShadow(
                            color: AppTheme.primaryColor.withValues(alpha: 0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : [],
                ),
                child: Row(
                  children: [
                    _isLoadingSettings
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : SvgPicture.asset(
                            'assets/icons/save.svg',
                            width: 32,
                            height: 32,
                            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                          ),
                    const SizedBox(width: 8),
                    Text(
                      _isLoadingSettings ? 'Saving...' : 'Save Changes',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
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

  @override
  Widget build(BuildContext context) {
    if (_isLoadingSettings && _settingIds.isEmpty) {
      final screenWidth = MediaQuery.of(context).size.width;
      final isMobile = screenWidth < 802;
      return SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SkeletonLoader(width: 140, height: 40, borderRadius: BorderRadius.circular(10)),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildSettingsSectionSkeleton(
                    title: 'General Settings',
                    icon: Icons.language_rounded,
                    fieldCount: 3,
                  ),
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSettingsSectionSkeleton(
                      title: 'Database Configuration',
                      icon: Icons.cloud_queue_rounded,
                      fieldCount: 3,
                    ),
                  ),
                ],
              ],
            ),
            if (isMobile) ...[
              const SizedBox(height: 16),
              _buildSettingsSectionSkeleton(
                title: 'Database Configuration',
                icon: Icons.cloud_queue_rounded,
                fieldCount: 3,
              ),
            ],
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildSettingsSectionSkeleton(
                    title: 'Email Settings',
                    icon: Icons.send_rounded,
                    fieldCount: 3,
                  ),
                ),
                if (!isMobile) ...[
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildSettingsSectionSkeleton(
                      title: 'Security Settings',
                      icon: Icons.security_rounded,
                      fieldCount: 2,
                      show2FA: true,
                    ),
                  ),
                ],
              ],
            ),
            if (isMobile) ...[
              const SizedBox(height: 16),
              _buildSettingsSectionSkeleton(
                title: 'Security Settings',
                icon: Icons.security_rounded,
                fieldCount: 2,
                show2FA: true,
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Local Toolbar
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildSaveButton(),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: _buildSettingsSection(
                  title: 'General Settings',
                  icon: Icons.language_rounded,
                  fieldKeys: ['Platform Name', 'Default Language', 'Timezone'],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSettingsSection(
                  title: 'Database Configuration',
                  icon: Icons.cloud_queue_rounded,
                  fieldKeys: ['Connection Pool Size', 'Query Timeout', 'Backup Frequency'],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSettingsSection(
                  title: 'Email Settings',
                  icon: Icons.send_rounded,
                  fieldKeys: ['SMTP Server', 'From Address', 'Daily Limit'],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSettingsSection(
                  title: 'Security Settings',
                  icon: Icons.security_rounded,
                  fieldKeys: ['Session Timeout', 'Password Policy'],
                  show2FA: true,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildChangePasswordSection(),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: SizedBox(),
              ),
            ],
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required IconData icon,
    required List<String> fieldKeys,
    bool show2FA = false,
  }) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...fieldKeys.map((key) => _buildEditableField(key)),
          if (show2FA) _buildToggleRow('2FA Required'),
        ],
      ),
    );
  }

  Widget _buildEditableField(String label) {
    bool isFocused = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Focus(
                  onFocusChange: (focus) => setState(() => isFocused = focus),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: isFocused ? 0.08 : 0.04),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isFocused
                            ? AppTheme.primaryColor.withValues(alpha: 0.4)
                            : Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: TextField(
                      controller: _controllers[label],
                      style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildToggleRow(String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 3,
            child: Align(
              alignment: Alignment.centerLeft,
              child: _buildSwitch(
                value: _is2FARequired,
                onChanged: (val) => setState(() => _is2FARequired = val),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitch({required bool value, required ValueChanged<bool> onChanged}) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 36,
        height: 20,
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: value ? AppTheme.primaryColor.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: value ? AppTheme.primaryColor.withValues(alpha: 0.4) : Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: AnimatedAlign(
          duration: const Duration(milliseconds: 200),
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              color: value ? Colors.white : Colors.white.withValues(alpha: 0.4),
              shape: BoxShape.circle,
              boxShadow: value
                  ? [
                      BoxShadow(
                        color: AppTheme.primaryColor.withValues(alpha: 0.5),
                        blurRadius: 4,
                      ),
                    ]
                  : [],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildChangePasswordSection() {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lock_outline_rounded, color: AppTheme.primaryColor, size: 16),
              ),
              const SizedBox(width: 10),
              const Text(
                'Change Password',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPasswordInputField(
            label: 'Current Password',
            controller: _currentPasswordController,
          ),
          _buildPasswordInputField(
            label: 'New Password',
            controller: _newPasswordController,
          ),
          _buildPasswordInputField(
            label: 'Confirm New Password',
            controller: _confirmPasswordController,
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: _buildActionBtn(
              label: 'Update Password',
              onTap: _changePassword,
              isLoading: _isUpdatingPassword,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordInputField({
    required String label,
    required TextEditingController controller,
  }) {
    bool isFocused = false;
    bool obscureText = true;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  label,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 3,
                child: Focus(
                  onFocusChange: (focus) => setState(() => isFocused = focus),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: isFocused ? 0.08 : 0.04),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(
                        color: isFocused
                            ? AppTheme.primaryColor.withValues(alpha: 0.4)
                            : Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: controller,
                            obscureText: obscureText,
                            style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () => setState(() => obscureText = !obscureText),
                            child: Icon(
                              obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                              color: Colors.white.withValues(alpha: 0.4),
                              size: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionBtn({
    required String label,
    required VoidCallback onTap,
    required bool isLoading,
  }) {
    bool isHovered = false;
    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() => isHovered = true),
          onExit: (_) => setState(() => isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: isLoading ? null : onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(8),
                boxShadow: isHovered
                    ? [
                        BoxShadow(
                          color: AppTheme.primaryColor.withValues(alpha: 0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [],
              ),
              child: isLoading
                  ? const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : Text(
                      label,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  void _changePassword() async {
    final currentPassword = _currentPasswordController.text.trim();
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (currentPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      AppNotification.show(
        context,
        title: 'Validation Error',
        message: 'All fields are required.',
        type: NotificationType.error,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      AppNotification.show(
        context,
        title: 'Validation Error',
        message: 'New password and confirmation do not match.',
        type: NotificationType.error,
      );
      return;
    }

    if (newPassword.length < 6) {
      AppNotification.show(
        context,
        title: 'Validation Error',
        message: 'New password must be at least 6 characters.',
        type: NotificationType.error,
      );
      return;
    }

    final authState = ref.read(authProvider);
    final email = authState.email ?? 'admin';

    setState(() {
      _isUpdatingPassword = true;
    });

    try {
      final baseService = ref.read(baseServiceProvider);
      await baseService.changePassword(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      AppNotification.show(
        context,
        title: 'Success',
        message: 'Password updated successfully.',
        type: NotificationType.success,
      );
    } catch (e) {
      AppNotification.show(
        context,
        title: 'Error',
        message: e.toString().replaceFirst('Exception: ', ''),
        type: NotificationType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isUpdatingPassword = false;
        });
      }
    }
  }

  Widget _buildSettingsSectionSkeleton({
    required String title,
    required IconData icon,
    required int fieldCount,
    bool show2FA = false,
  }) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: AppTheme.primaryColor.withValues(alpha: 0.3), size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white.withValues(alpha: 0.3),
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...List.generate(
            fieldCount,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Expanded(flex: 2, child: SkeletonLoader(width: 100, height: 12)),
                  const SizedBox(width: 16),
                  Expanded(flex: 3, child: SkeletonLoader(height: 32, borderRadius: BorderRadius.circular(6))),
                ],
              ),
            ),
          ),
          if (show2FA) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SkeletonLoader(width: 120, height: 12),
                SkeletonLoader(width: 44, height: 24, borderRadius: BorderRadius.circular(12)),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

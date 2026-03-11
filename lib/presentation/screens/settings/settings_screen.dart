import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/theme/app_theme.dart';
import '../../controllers/auth_controller.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Obx(() {
        final user = controller.user.value;
        if (user == null) return const SizedBox.shrink();

        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          children: [
            // ── Profile Card ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppTheme.primaryColor, AppTheme.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  // Avatar
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                        width: 3,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white.withOpacity(0.2),
                      backgroundImage: user.image != null
                          ? CachedNetworkImageProvider(user.image!)
                          : null,
                      child: user.image == null
                          ? Text(
                              user.firstName.isNotEmpty
                                  ? user.firstName[0].toUpperCase()
                                  : '?',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.fullName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '@${user.username}',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.email_outlined,
                              size: 13,
                              color: Colors.white.withOpacity(0.7),
                            ),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                user.email,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 12,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ── Appearance Section ────────────────────────────────
            _sectionHeader('Appearance', theme),
            const SizedBox(height: 8),
            _settingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.dark_mode_outlined,
                  title: 'Dark Mode',
                  subtitle: controller.isDarkMode.value
                      ? 'Currently dark'
                      : 'Currently light',
                  trailing: Switch.adaptive(
                    value: controller.isDarkMode.value,
                    onChanged: (_) => controller.toggleTheme(),
                    activeColor: AppTheme.primaryColor,
                  ),
                  theme: theme,
                ),
              ],
              theme: theme,
            ),
            const SizedBox(height: 20),

            // ── Account Section ───────────────────────────────────
            _sectionHeader('Account', theme),
            const SizedBox(height: 8),
            _settingsCard(
              children: [
                _InfoTile(
                  icon: Icons.badge_outlined,
                  label: 'User ID',
                  value: '#${user.id}',
                  theme: theme,
                ),
                Divider(
                  color: theme.dividerTheme.color,
                  height: 1,
                  indent: 52,
                ),
                _InfoTile(
                  icon: Icons.person_outline_rounded,
                  label: 'Full Name',
                  value: user.fullName,
                  theme: theme,
                ),
                Divider(
                  color: theme.dividerTheme.color,
                  height: 1,
                  indent: 52,
                ),
                _InfoTile(
                  icon: Icons.alternate_email_rounded,
                  label: 'Username',
                  value: user.username,
                  theme: theme,
                ),
                Divider(
                  color: theme.dividerTheme.color,
                  height: 1,
                  indent: 52,
                ),
                _InfoTile(
                  icon: Icons.email_outlined,
                  label: 'Email',
                  value: user.email,
                  theme: theme,
                ),
              ],
              theme: theme,
            ),
            const SizedBox(height: 20),

            // ── Logout ────────────────────────────────────────────
            _sectionHeader('Session', theme),
            const SizedBox(height: 8),
            _settingsCard(
              children: [
                ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppTheme.errorColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      color: AppTheme.errorColor,
                      size: 18,
                    ),
                  ),
                  title: Text(
                    'Logout',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: AppTheme.errorColor,
                      fontSize: 15,
                    ),
                  ),
                  subtitle: Text(
                    'Sign out of your account',
                    style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppTheme.errorColor,
                  ),
                  onTap: () => _showLogoutDialog(controller),
                ),
              ],
              theme: theme,
            ),
            const SizedBox(height: 40),

            Center(
              child: Text(
                'Taghyeer Technologies v1.0.0',
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
              ),
            ),
            const SizedBox(height: 20),
          ],
        );
      }),
    );
  }

  Widget _sectionHeader(String title, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.bodyMedium?.copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _settingsCard({
    required List<Widget> children,
    required ThemeData theme,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.transparent,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(children: children),
      ),
    );
  }

  void _showLogoutDialog(AuthController controller) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to sign out of your account?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              controller.logout();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.errorColor,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final ThemeData theme;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: AppTheme.primaryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: AppTheme.primaryColor, size: 18),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleMedium?.copyWith(fontSize: 15),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12),
      ),
      trailing: trailing,
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final ThemeData theme;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppTheme.primaryColor, size: 17),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodyMedium?.copyWith(fontSize: 11),
              ),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(fontSize: 14),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

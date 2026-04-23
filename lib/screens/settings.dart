import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import '../providers/theme_provider.dart';
import '../services/storage.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final StorageService _storage = StorageService();

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(authProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Profile
            Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.blue,
                    child: Text(
                      Helpers.getInitials(currentUser?.name ?? 'U'),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentUser?.name ?? '未登录',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          currentUser?.email ?? '',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditProfileDialog(currentUser),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Theme Settings
            _buildSection(
              '外观设置',
              [
                _buildListItem(
                  '主题模式',
                  Icons.palette,
                  trailing: DropdownButton<ThemeMode>(
                    value: themeMode,
                    items: const [
                      DropdownMenuItem(
                        value: ThemeMode.system,
                        child: Text('跟随系统'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.light,
                        child: Text('浅色'),
                      ),
                      DropdownMenuItem(
                        value: ThemeMode.dark,
                        child: Text('深色'),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) {
                        ref.read(themeProvider.notifier).setTheme(value);
                      }
                    },
                  ),
                ),
                _buildListItem(
                  '主色调',
                  Icons.color_lens,
                  trailing: Row(
                    children: [
                      _buildColorChoice(Colors.blue, onTap: () {
                        ref.read(colorSchemeProvider.notifier).setPrimaryColor(Colors.blue);
                      }),
                      const SizedBox(width: 8),
                      _buildColorChoice(Colors.purple, onTap: () {
                        ref.read(colorSchemeProvider.notifier).setPrimaryColor(Colors.purple);
                      }),
                      const SizedBox(width: 8),
                      _buildColorChoice(Colors.green, onTap: () {
                        ref.read(colorSchemeProvider.notifier).setPrimaryColor(Colors.green);
                      }),
                      const SizedBox(width: 8),
                      _buildColorChoice(Colors.orange, onTap: () {
                        ref.read(colorSchemeProvider.notifier).setPrimaryColor(Colors.orange);
                      }),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Notification Settings
            _buildSection(
              '通知设置',
              [
                _buildSwitchItem(
                  '启用通知',
                  Icons.notifications,
                  true,
                  (value) {},
                ),
                _buildSwitchItem(
                  '每日汇总',
                  Icons.today,
                  false,
                  (value) {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Data Management
            _buildSection(
              '数据管理',
              [
                _buildListItem(
                  '备份数据',
                  Icons.backup,
                  onTap: () => _backupData(),
                ),
                _buildListItem(
                  '恢复数据',
                  Icons.restore,
                  onTap: () => _restoreData(),
                ),
                _buildListItem(
                  '清除所有数据',
                  Icons.delete_forever,
                  onTap: () => _clearAllData(),
                  textColor: Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),
            // About
            _buildSection(
              '关于',
              [
                _buildListItem(
                  '版本',
                  Icons.info,
                  trailing: Text(AppConstants.appVersion),
                ),
                _buildListItem(
                  '帮助文档',
                  Icons.help_outline,
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
        ),
        Card(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: items,
          ),
        ),
      ],
    );
  }

  Widget _buildListItem(
    String title,
    IconData icon, {
    Widget? trailing,
    VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(
        title,
        style: textColor != null ? TextStyle(color: textColor) : null,
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }

  Widget _buildSwitchItem(
    String title,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(icon, color: Colors.grey[600]),
      title: Text(title),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildColorChoice(Color color, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(currentUser) {
    final nameController = TextEditingController(text: currentUser?.name ?? '');
    final emailController = TextEditingController(text: currentUser?.email ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('编辑个人信息'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: '姓名',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: '邮箱',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(authProvider.notifier).updateProfile(
                nameController.text.trim(),
                email: emailController.text.trim(),
              );
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('个人信息已更新')),
              );
            },
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }

  void _backupData() async {
    try {
      final data = await _storage.exportData();
      // In a real app, you would save to a file
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('数据备份成功')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('备份失败: $e')),
      );
    }
  }

  void _restoreData() async {
    // In a real app, you would show a file picker
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('恢复功能开发中...')),
    );
  }

  void _clearAllData() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除所有数据'),
        content: const Text('此操作不可恢复，确定要清除所有数据吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              await _storage.clearAllData();
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('所有数据已清除')),
              );
            },
            child: const Text('清除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

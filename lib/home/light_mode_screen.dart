import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/database/user_db.dart';
import 'package:flutter_todo_app/provider/theme_provider.dart';
import 'package:provider/provider.dart';

enum AppThemeMode { light, dark }

class LightModeSettingScreen extends StatefulWidget {
  const LightModeSettingScreen({super.key});

  @override
  State<LightModeSettingScreen> createState() => _LightModeSettingScreenState();
}

class _LightModeSettingScreenState extends State<LightModeSettingScreen> {
  late AppThemeMode _selectedMode;

  @override
  void initState() {
    super.initState();
    final isDark = context.read<ThemeNotifier>().isDarkMode();
    _selectedMode = isDark ? AppThemeMode.dark : AppThemeMode.light;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;
    final iconColor = Theme.of(context).iconTheme.color;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Light mode'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        iconTheme: IconThemeData(color: iconColor),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildOptionTile(AppThemeMode.dark, 'Turn on'.tr(), textColor),
            _buildOptionTile(AppThemeMode.light, 'Turn off'.tr(), textColor),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(AppThemeMode value, String label, Color? textColor) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(color: textColor),
      ),
      trailing: Radio<AppThemeMode>(
        value: value,
        groupValue: _selectedMode,
        activeColor: Theme.of(context).colorScheme.primary,
        onChanged: (val) {
          if (val != null) {
            _updateTheme(val);
          }
        },
      ),
      onTap: () => _updateTheme(value),
    );
  }

  void _updateTheme(AppThemeMode mode) async {
    setState(() {
      _selectedMode = mode;
    });

    final themeNotifier = context.read<ThemeNotifier>();
    final isDark = mode == AppThemeMode.dark;
    themeNotifier.toggleTheme(isDark);

    final savedLogin = await UserDatabase.instance.getSavedLogin();
    if (savedLogin != null) {
      final username = savedLogin['username']!;
      await UserDatabase.instance.updateUserTheme(username, isDark);
    }
  }
}

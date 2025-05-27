import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';

enum AppThemeMode { light, dark }

class LightModeSettingScreen extends StatefulWidget {
  const LightModeSettingScreen({super.key});

  @override
  State<LightModeSettingScreen> createState() => _LightModeSettingScreenState();
}

class _LightModeSettingScreenState extends State<LightModeSettingScreen> {
  AppThemeMode _selectedMode = AppThemeMode.dark;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: AppBar(
        backgroundColor: tdBgColor,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Light mode',
          style: TextStyle(color: tdWhite),
        ),
        iconTheme: const IconThemeData(color: tdWhite),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildOptionTile(AppThemeMode.light, 'Turn on'),
            _buildOptionTile(AppThemeMode.dark, 'Turn off'),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionTile(AppThemeMode value, String label) {
    return ListTile(
      title: Text(
        label,
        style: const TextStyle(color: tdWhite),
      ),
      trailing: Radio<AppThemeMode>(
        value: value,
        groupValue: _selectedMode,
        activeColor: tdPurple,
        onChanged: (val) {
          setState(() {
            _selectedMode = val!;
            // TODO: xử lý khi chuyển theme
          });
        },
      ),
      onTap: () {
        setState(() {
          _selectedMode = value;
        });
      },
    );
  }
}

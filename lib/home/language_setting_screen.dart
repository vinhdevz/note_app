import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_todo_app/constants/color.dart';



class LanguageSettingScreen extends StatelessWidget {
  const LanguageSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: AppBar(
        title: Text('Change app language'.tr()),
        backgroundColor: tdBgColor,
        foregroundColor: tdWhite,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListView(
          children: [
            ListTile(
  title: const Text("English", style: TextStyle(color: tdWhite)),
  trailing: context.locale.languageCode == 'en'
      ? const Icon(Icons.check, color: tdWhite)
      : null,
  onTap: () async {
    await context.setLocale(const Locale('en'));
    await Future.delayed(const Duration(milliseconds: 100));
    if (context.mounted) {
      Navigator.pop(context);
    }
  },
),
ListTile(
  title: const Text("Tiếng Việt", style: TextStyle(color: tdWhite)),
  trailing: context.locale.languageCode == 'vi'
      ? const Icon(Icons.check, color: tdWhite)
      : null,
  onTap: () async {
    await context.setLocale(const Locale('vi'));
    await Future.delayed(const Duration(milliseconds: 100));
    if (context.mounted) {
      Navigator.pop(context);
    }
  },
),

          ],
        ),
      ),
    );
  }
}

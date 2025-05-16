import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_todo_app/constants/color.dart';

class LanguageSettingScreen extends StatelessWidget {
  const LanguageSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languages = [
      {'name': 'English', 'locale': const Locale('en')},
      {'name': 'Tiếng Việt', 'locale': const Locale('vi')},
    ];

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
          children: languages.map((lang) {
            final isSelected = context.locale == lang['locale'];
            return ListTile(
              title: Text(
                lang['name'] as String,
                style: const TextStyle(color: tdWhite),
              ),
              trailing: isSelected
                  ? const Icon(Icons.check, color: tdWhite)
                  : null,
              onTap: () async {
                await context.setLocale(lang['locale'] as Locale);
                await Future.delayed(const Duration(milliseconds: 100));
                if (context.mounted) Navigator.pop(context);
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}

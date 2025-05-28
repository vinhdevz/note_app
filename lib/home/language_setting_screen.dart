import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class LanguageSettingScreen extends StatelessWidget {
  const LanguageSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final iconColor = theme.iconTheme.color;

    final languages = [
      {'name': 'English', 'locale': const Locale('en')},
      {'name': 'Tiếng Việt', 'locale': const Locale('vi')},
    ];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Change app language'.tr(),
          style: TextStyle(color: textColor),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: iconColor,
        elevation: 0,
        leading: BackButton(color: iconColor),
      ),
      body: SafeArea(
        child: ListView(
          children: languages.map((lang) {
            final isSelected = context.locale == lang['locale'];
            return ListTile(
              title: Text(
                lang['name'] as String,
                style: TextStyle(color: textColor),
              ),
              trailing: isSelected
                  ? Icon(Icons.check, color: iconColor)
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

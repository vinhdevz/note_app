import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'about_us'.tr(),
        ),
        backgroundColor: tdBgColor,
      ),
      backgroundColor: tdBgColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'faq3'.tr(),
              style: const TextStyle(
                color: tdWhite,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'faq4'.tr(),
              style: const TextStyle(
                color: tdWhite,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

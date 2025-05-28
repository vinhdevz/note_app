import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class FAQScreen extends StatelessWidget {
  FAQScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> faqList = [
      {
        'question': 'faq_q1'.tr(),
        'answer': 'faq_a1'.tr(),
      },
      {
        'question': 'faq_q2'.tr(),
        'answer': 'faq_a2'.tr(),
      },
    ];

    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.background;
    final titleColor = theme.colorScheme.onBackground;
    final answerColor = theme.colorScheme.onBackground.withOpacity(0.7);
    final iconColor = theme.colorScheme.primary;

    return Scaffold(
      appBar: AppBar(
        title: Text('faq'.tr()),
        backgroundColor: backgroundColor,
        foregroundColor: titleColor,
      ),
      backgroundColor: backgroundColor,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final faq = faqList[index];
          return ExpansionTile(
            collapsedIconColor: iconColor.withOpacity(0.7),
            iconColor: iconColor,
            title: Text(
              faq['question']!,
              style: TextStyle(
                color: titleColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  faq['answer']!,
                  style: TextStyle(color: answerColor),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

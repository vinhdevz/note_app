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

    return Scaffold(
      appBar: AppBar(
        title: Text('faq'.tr()),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: faqList.length,
        itemBuilder: (context, index) {
          final faq = faqList[index];
          return ExpansionTile(
            collapsedIconColor: Colors.white70,
            iconColor: Colors.white,
            title: Text(
              faq['question']!,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  faq['answer']!,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

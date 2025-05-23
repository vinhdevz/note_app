import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';

class HelpFeedBackScreen extends StatelessWidget {
  const HelpFeedBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'help_feedback'.tr(),
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
              'help_feedback_hint'.tr(),
              style: const TextStyle(
                color: tdWhite,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 6,
              style: const TextStyle(color: tdWhite),
              decoration: InputDecoration(
                hintText: 'type_here'.tr(),
                hintStyle: const TextStyle(color: tdWhite),
                filled: true,
                fillColor: tdGrey,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final message = _controller.text;
                if (message.isNotEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'thank_you'.tr(),
                      ),
                    ),
                  );
                  _controller.clear();
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: tdRed),
              child: Text(
                'send'.tr(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

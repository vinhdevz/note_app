import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class HelpFeedBackScreen extends StatelessWidget {
  const HelpFeedBackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _controller = TextEditingController();
    final theme = Theme.of(context);

    final backgroundColor = theme.colorScheme.background;
    final textColor = theme.colorScheme.onBackground;
    final hintTextColor = textColor.withOpacity(0.7);
    final fillColor = theme.colorScheme.surfaceVariant; 
    final buttonColor = theme.colorScheme.error; 

    return Scaffold(
      appBar: AppBar(
        title: Text('help_feedback'.tr()),
        backgroundColor: backgroundColor,
        foregroundColor: textColor,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'help_feedback_hint'.tr(),
              style: TextStyle(
                color: textColor,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 6,
              style: TextStyle(color: textColor),
              decoration: InputDecoration(
                hintText: 'type_here'.tr(),
                hintStyle: TextStyle(color: hintTextColor),
                filled: true,
                fillColor: fillColor,
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
          content: Text('thank_you'.tr()),
        ),
      );
      _controller.clear();
    }
  },
  style: ElevatedButton.styleFrom(backgroundColor: buttonColor),
  child: Text(
    'send'.tr(),
    style: TextStyle(color: Colors.white),
  ),
),

          ],
        ),
      ),
    );
  }
}

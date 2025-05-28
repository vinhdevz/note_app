import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportUsScreen extends StatelessWidget {
  const SupportUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final backgroundColor = theme.colorScheme.background;
    final textColor = theme.colorScheme.onBackground.withOpacity(0.7);
    final buttonTextColor = theme.colorScheme.onPrimary;
    final rateButtonColor = theme.colorScheme.primary;
    final donateButtonColor = Colors.pinkAccent; // bạn có thể thay đổi thành màu theme nếu muốn
    final shareButtonColor = Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: Text('support_us'.tr()),
        backgroundColor: backgroundColor,
        foregroundColor: theme.colorScheme.onBackground,
      ),
      backgroundColor: backgroundColor,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'support_us_desc'.tr(),
              style: TextStyle(color: textColor, fontSize: 16),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                _launchURL(context, "https://your-app-rating-link.com");
              },
              icon: const Icon(Icons.star),
              label: Text('rate_us'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: rateButtonColor,
                foregroundColor: buttonTextColor,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                _launchURL(context, "https://your-donation-link.com");
              },
              icon: const Icon(Icons.favorite),
              label: Text('donate'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: donateButtonColor,
                foregroundColor: buttonTextColor,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () {
                _launchURL(context, "https://your-share-app-link.com");
              },
              icon: const Icon(Icons.share),
              label: Text('share_app'.tr()),
              style: ElevatedButton.styleFrom(
                backgroundColor: shareButtonColor,
                foregroundColor: buttonTextColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    try {
      final Uri uri = Uri.parse(url);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
      } else {
        _showError(context, 'Could not launch URL');
      }
    } catch (e) {
      _showError(context, 'Something went wrong');
    }
  }

  void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.redAccent,
      ),
    );
  }
}

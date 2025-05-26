import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/language_setting_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_todo_app/home/light_mode_screen.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: tdBgColor,
        elevation: 0,
        title: Text(
          'Settings'.tr(),
          style: const TextStyle(
            color: tdWhite,
            fontSize: 20,
            fontWeight: FontWeight.w400,
            fontFamily: 'Lato',
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios, color: tdWhite),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 2.0, vertical: 4.0),
        child: ListView(
          children: [
            _buildSettingTitle('Settings'.tr()),
            _buildSettingOptions(
              context,
              'Change app color'.tr(),
              'assets/icons/brush.svg',
              onTap: () {},
            ),
            _buildSettingOptions(
              context,
              'Change app typography'.tr(),
              'assets/icons/text.svg',
              onTap: () {},
            ),_buildSettingOptions(
              context,
              'Change light mode'.tr(),
              'assets/icons/sun-svgrepo-com.svg',
               onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LightModeSettingScreen()),
                );
                setState(() {}); 
              },
            ),
            _buildSettingOptions(
              context,
              'Change app language'.tr(),
              'assets/icons/language_square.svg',
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LanguageSettingScreen()),
                );
                setState(() {}); 
              },
            ),
            _buildSettingTitle('Import'.tr()),
            _buildSettingOptions(
              context,
              'Import from Google calendar'.tr(),
              'assets/icons/import.svg',
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOptions(
  BuildContext context,
  String title,
  String iconPath, {
  VoidCallback? onTap,
}) {
  return ListTile(
    leading: SvgPicture.asset(
      iconPath,
      width: 24,
      height: 24,
      colorFilter: const ColorFilter.mode(tdWhite, BlendMode.srcIn), 
    ),
    title: Text(
      title,
      style: const TextStyle(
        color: tdWhite,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        fontFamily: 'Lato',
      ),
    ),
    trailing: const Icon(Icons.arrow_forward_ios, color: tdWhite, size: 20),
    onTap: onTap,
  );
}

  Widget _buildSettingTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          color: tdWhite,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Lato',
        ),
      ),
    );
  }
}

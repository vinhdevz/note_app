import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_todo_app/constants/color.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: tdBgColor,
        elevation: 0,
        title: Text(
          'Settings',
          style: TextStyle(
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
          icon: Icon(Icons.arrow_back_ios, color: tdWhite),
        ),
      ),
      body: Padding(
        padding: EdgeInsetsGeometry.symmetric(horizontal: 2.0, vertical: 4.0),
        child: ListView(
          children: [
            _buildSettingTitle('Settings'),
            _buildSettingOptions(context, 'Change app color', 'assets/icons/brush.svg'),
            _buildSettingOptions(context, 'Change app typography', 'assets/icons/text.svg'),
            _buildSettingOptions(context, 'Change app language', 'assets/icons/language-square.svg'),
            _buildSettingTitle('Import'),
            _buildSettingOptions(context, 'Import from Google calendar', 'assets/icons/import.svg'),
          ],
        ),
      ),
    );
  }
  
  _buildSettingOptions(BuildContext context, String title, String icon) {
    return ListTile(
      leading: SvgPicture.asset(icon, width: 24, height: 24),
      title: Text(
        title,
        style: TextStyle(
          color: tdWhite, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Lato',
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: tdWhite, size: 20),
      onTap: () {},
    );
  }
  
  _buildSettingTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(
          color: tdWhite,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          fontFamily: 'Lato',
        ),
      ),
    );
  }
}

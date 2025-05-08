import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';

class ProfileScreen extends StatelessWidget {
  final String? username;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: tdBgColor,
        elevation: 0,
        title: Text(
          'Profile',
          style: TextStyle(color: tdText, fontSize: 20, fontWeight: FontWeight.bold, fontFamily: 'Lato',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
              radius: 50,
            ),

            SizedBox(height: 10),
            Text(
              username ?? 'Dovinh',
              style: TextStyle(color: tdWhite, fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Lato',
              ),
            ),

            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    '10 Task left',
                    style: TextStyle(color: tdWhite, fontSize: 14, fontFamily: 'Lato',
                    ),
                  ),
                ),

                SizedBox(width: 20),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(2),
                  ),
                  child: Text(
                    '5 Task done',
                    style: TextStyle(color: tdWhite, fontSize: 14, fontFamily: 'Lato',
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _buildSectionTitle('Settings'),
                  _buildProfileOption(context, 'App Settings', 'assets/icons/setting.svg'),

                  _buildSectionTitle('Account'),
                  _buildProfileOption(context, 'Change account name', 'assets/icons/user.svg'),
                  _buildProfileOption(context, 'Change account password', 'assets/icons/key.svg'),
                  _buildProfileOption(context, 'Change account image', 'assets/icons/camera.svg'),

                  _buildSectionTitle('Uptodo'),
                  _buildProfileOption(context, 'About Us', 'assets/icons/menu.svg'),
                  _buildProfileOption(context, 'FAQ', 'assets/icons/info-circle.svg'),
                  _buildProfileOption(context, 'Help & Feedback', 'assets/icons/flash.svg'),
                  _buildProfileOption(context, 'Support Us', 'assets/icons/like.svg'),

                  ListTile(
                    leading: SvgPicture.asset(
                      'assets/icons/logout.svg',width: 24, height: 24,
                    ),
                    title: Text(
                      'Log out',
                      style: TextStyle(color: Colors.red, fontSize: 16, fontFamily: 'Lato',
                      ),
                    ),
                    onTap: onLogout,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildProfileOption(BuildContext context, String title, String iconPath) {
    return ListTile(
      leading: SvgPicture.asset(iconPath, width: 24, height: 24,
      ),
      title: Text(
        title,
        style: TextStyle(color: tdWhite, fontSize: 16, fontFamily: 'Lato'),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: tdWhite, size: 16,
      ),
      onTap: () {},
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0, top: 16.0, bottom: 8.0),
      child: Text(
        title,
        style: TextStyle(color: tdWhite, fontSize: 14, fontWeight: FontWeight.w400, fontFamily: 'Lato',
        ),
      ),
    );
  }
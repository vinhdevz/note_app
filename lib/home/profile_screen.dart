import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/database/user_db.dart';
import 'package:flutter_todo_app/database/task_database.dart';
import 'package:flutter_todo_app/home/setting_screen.dart';

class ProfileScreen extends StatefulWidget {
  final String? username;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _username;
  int _completedCount = 0;
  int _uncompletedCount = 0;

  @override
  void initState() {
    super.initState();
    _username = widget.username ?? 'Dovinh';
    _loadTaskStats();
  }

  Future<void> _loadTaskStats() async {
    final stats = await TaskDatabase.instance.loadTaskStats();
    setState(() {
      _completedCount = stats['completed'] ?? 0;
      _uncompletedCount = stats['uncompleted'] ?? 0;
    });
  }

  void _updateUsername(String newUsername) {
    setState(() {
      _username = newUsername;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: tdBgColor,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: tdText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
              radius: 50,
            ),
            const SizedBox(height: 10),
            Text(
              _username,
              style: const TextStyle(
                color: tdWhite,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Lato',
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildTaskStats(),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _buildSectionTitle('Settings'),
                  _buildProfileOption(
                    context,
                    'App Settings',
                    'assets/icons/setting.svg',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingScreen()),
                      );
                    },
                  ),
                  _buildSectionTitle('Account'),
                  _buildProfileOption(
                    context,
                    'Change account name',
                    'assets/icons/user.svg',
                    () => _showChangeNameDialog(context),
                  ),
                  _buildProfileOption(
                    context,
                    'Change account password',
                    'assets/icons/key.svg',
                    () => _showChangePassDialog(context),
                  ),
                  _buildProfileOption(
                    context,
                    'Change account image',
                    'assets/icons/camera.svg',
                    () {},
                  ),
                  _buildSectionTitle('Uptodo'),
                  _buildProfileOption(
                    context, 'About Us', 'assets/icons/menu.svg', () {}),
                  _buildProfileOption(
                    context, 'FAQ', 'assets/icons/info-circle.svg', () {}),
                  _buildProfileOption(
                    context, 'Help & Feedback', 'assets/icons/flash.svg', () {}),
                  _buildProfileOption(
                    context, 'Support Us', 'assets/icons/like.svg', () {}),
                  _buildLogout(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTaskStats() {
    return [
      _buildStatBox('$_uncompletedCount Task left'),
      const SizedBox(width: 20),
      _buildStatBox('$_completedCount Task done'),
    ];
  }

  Widget _buildStatBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: const TextStyle(color: tdWhite, fontSize: 14, fontFamily: 'Lato'),
      ),
    );
  }

  Widget _buildProfileOption(
      BuildContext context, String title, String iconPath, VoidCallback onTap) {
    return ListTile(
      leading: SvgPicture.asset(iconPath, width: 24, height: 24),
      title: Text(
        title,
        style: const TextStyle(color: tdWhite, fontSize: 16, fontFamily: 'Lato'),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: tdWhite, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildSectionTitle(String title) {
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

  Widget _buildLogout(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset('assets/icons/logout.svg', width: 24, height: 24),
      title: const Text(
        'Log out',
        style: TextStyle(color: Colors.red, fontSize: 16, fontFamily: 'Lato'),
      ),
      onTap: () => _showLogoutDialog(context),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Log out'),
        content: const Text('Choose how you want to log out.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: const Text('Keep login info'),
          ),
          TextButton(
            onPressed: () => _handleClearAndRestart(context),
            child: const Text('Clear & restart', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _handleClearAndRestart(BuildContext context) async {
    await UserDatabase.instance.clearLoginState();
    Navigator.of(context).pop();
    Navigator.of(context).pushNamedAndRemoveUntil('/intro', (route) => false);
  }

  void _showChangeNameDialog(BuildContext context) {
    final nameController = TextEditingController(text: _username);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Change account name',
          style: TextStyle(color: tdWhite, fontSize: 18, fontFamily: 'Lato'),
        ),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: tdWhite, fontFamily: 'Lato'),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            hintText: 'Enter new name',
            hintStyle: const TextStyle(color: Colors.grey, fontFamily: 'Lato'),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: tdWhite, fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () => _handleEditUserName(context, nameController),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Edit', style: TextStyle(color: tdWhite, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _handleEditUserName(BuildContext context, TextEditingController controller) async {
    final newUsername = controller.text.trim();
    if (newUsername.isNotEmpty && newUsername != _username) {
      await UserDatabase.instance.updateUserName(_username, newUsername);
      _updateUsername(newUsername);
    }
    Navigator.of(context).pop();
  }

  void _showChangePassDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text('Change account Password', style: TextStyle(color: tdWhite, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPasswordField(oldPasswordController, 'Enter old password'),
            const SizedBox(height: 12),
            _buildPasswordField(newPasswordController, 'Enter new password'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(color: tdWhite, fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () => _handleChangePassword(
              context,
              oldPasswordController,
              newPasswordController,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: tdDarkPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: const Text('Edit', style: TextStyle(color: tdWhite, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      style: const TextStyle(color: tdWhite),
      decoration: InputDecoration(
        labelText: label,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        labelStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[850],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: tdDarkPurple),
        ),
      ),
    );
  }

  void _handleChangePassword(
    BuildContext context,
    TextEditingController oldController,
    TextEditingController newController,
  ) async {
    final oldPass = oldController.text.trim();
    final newPass = newController.text.trim();

    if (oldPass.isEmpty || newPass.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in both fields')),
      );
      return;
    }

    final success = await UserDatabase.instance.updatePassWord(
      userName: _username,
      oldPassWord: oldPass,
      newPassWord: newPass,
    );

    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password changed successfully')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Old password is incorrect')),
      );
    }
  }
}

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/setting_screen.dart';
import 'package:image_picker/image_picker.dart';
import '../database/user_db.dart';

class ProfileScreen extends StatefulWidget {
  final String? username;
  final VoidCallback onLogout;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.onLogout,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _username;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _username = widget.username ?? 'Dovinh';
  }

  void _updateUsername(String newUsername) {
    setState(() {
      _username = newUsername;
    });
  }

  void _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  void _showImageSourceSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Change account Image',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: tdWhite),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: tdWhite),
                title: const Text('Take picture',
                    style: TextStyle(color: tdWhite)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: tdWhite),
                title: const Text('Import from gallery',
                    style: TextStyle(color: tdWhite)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.drive_folder_upload, color: tdWhite),
                title: const Text('Import from Google Drive',
                    style: TextStyle(color: tdWhite)),
                onTap: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text('Google Drive integration not implemented')),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
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
            CircleAvatar(
              backgroundImage: _selectedImage != null
                  ? FileImage(_selectedImage!)
                  : const AssetImage('assets/images/avatar.png')
                      as ImageProvider,
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
              children: [
                _buildInfoBox('10 Task left'),
                const SizedBox(width: 20),
                _buildInfoBox('5 Task done'),
              ],
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
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingScreen()),
                    ),
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
                    () => _showImageSourceSheet(context),
                  ),
                  _buildSectionTitle('Uptodo'),
                  _buildProfileOption(
                      context, 'About Us', 'assets/icons/menu.svg', () {}),
                  _buildProfileOption(
                      context, 'FAQ', 'assets/icons/info-circle.svg', () {}),
                  _buildProfileOption(context, 'Help & Feedback',
                      'assets/icons/flash.svg', () {}),
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

  Widget _buildInfoBox(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: tdWhite,
          fontSize: 14,
          fontFamily: 'Lato',
        ),
      ),
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

  Widget _buildProfileOption(
      BuildContext context, String title, String iconPath, VoidCallback onTap) {
    return ListTile(
      leading: SvgPicture.asset(iconPath, width: 24, height: 24),
      title: Text(
        title,
        style: const TextStyle(
          color: tdWhite,
          fontSize: 16,
          fontFamily: 'Lato',
        ),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: tdWhite, size: 16),
      onTap: onTap,
    );
  }

  Widget _buildLogout(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(
        'assets/icons/logout.svg',
        width: 24,
        height: 24,
      ),
      title: const Text(
        'Log out',
        style: TextStyle(
          color: Colors.red,
          fontSize: 16,
          fontFamily: 'Lato',
        ),
      ),
      onTap: () => _showLogoutDialog(context),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
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
              child: const Text(
                'Clear & restart',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void _handleClearAndRestart(BuildContext context) async {
    await UserDatabase.instance.clearLoginState();
    Navigator.of(context).pop();
    Navigator.of(context).pushNamedAndRemoveUntil('/intro', (route) => false);
  }

  void _showChangePassDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Change account Password',
              style: TextStyle(color: tdWhite, fontSize: 18)),
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
              child: const Text('Cancel', style: TextStyle(color: tdWhite)),
            ),
            ElevatedButton(
              onPressed: () => _handleChangePassword(
                context,
                oldPasswordController,
                newPasswordController,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: tdDarkPurple,
              ),
              child: const Text('Edit', style: TextStyle(color: tdWhite)),
            ),
          ],
        );
      },
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
    TextEditingController oldPasswordController,
    TextEditingController newPasswordController,
  ) async {
    final oldPass = oldPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();

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

  void _showChangeNameDialog(BuildContext context) {
    final nameController = TextEditingController(text: _username);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[900],
          title: const Text('Change account name',
              style: TextStyle(color: tdWhite, fontSize: 18)),
          content: TextField(
            controller: nameController,
            style: const TextStyle(color: tdWhite),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey[800],
              hintText: 'Enter new name',
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel', style: TextStyle(color: tdWhite)),
            ),
            ElevatedButton(
              onPressed: () => _handleEditUserName(context, nameController),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
              ),
              child: const Text('Edit', style: TextStyle(color: tdWhite)),
            ),
          ],
        );
      },
    );
  }

  void _handleEditUserName(
      BuildContext context, TextEditingController nameController) async {
    String newUsername = nameController.text.trim();
    if (newUsername.isNotEmpty && newUsername != _username) {
      await UserDatabase.instance.updateUserName(
        _username,
        newUsername,
      );
      _updateUsername(newUsername);
    }
    Navigator.of(context).pop();
  }
}

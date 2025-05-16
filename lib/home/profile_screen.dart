import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/setting_screen.dart';
import 'package:flutter_todo_app/database/task_database.dart';
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
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late String _username;
  int _completedCount = 0;
  int _uncompletedCount = 0;
   File? _selectedImage;

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
            Text(
                'Change account image'.tr(),
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold, color: tdWhite),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.camera_alt, color: tdWhite),
                title: Text('Take picture'.tr(),
                    style: const TextStyle(color: tdWhite)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library, color: tdWhite),
                title: Text('Import from gallery'.tr(),
                    style: const TextStyle(color: tdWhite)),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.drive_folder_upload, color: tdWhite),
                title: Text('Import from Google Drive'.tr(),
                    style: const TextStyle(color: tdWhite)),
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
        title: Text(
          'Profile'.tr(),
          style: const TextStyle(
            color: tdText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            fontFamily: 'Lato',
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20.0),
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
              children: _buildTaskStats(),
            ),
            const SizedBox(height: 32),
            Expanded(
              child: ListView(
                children: [
                  _buildSectionTitle('Settings'.tr()),
                  _buildProfileOption(
                    context,
                    'App Settings'.tr(),
                    'assets/icons/setting.svg',
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SettingScreen()),
                      );
                    },
                  ),
                  _buildSectionTitle('Account'.tr()),
                  _buildProfileOption(
                    context,
                    'Change account name'.tr(),
                    'assets/icons/user.svg',
                    () => _showChangeNameDialog(context),
                  ),
                  _buildProfileOption(
                    context,
                    'Change account password'.tr(),
                    'assets/icons/key.svg',
                    () => _showChangePassDialog(context),
                  ),
                  _buildProfileOption(
                    context,
                    'Change account image'.tr(),
                    'assets/icons/camera.svg',
                    () => _showImageSourceSheet(context),
                  ),
                  _buildSectionTitle('Uptodo'.tr()),
                  _buildProfileOption(
                    context,
                    'About Us'.tr(),
                    'assets/icons/menu.svg',
                    () {},
                  ),
                  _buildProfileOption(
                    context,
                    'FAQ'.tr(),
                    'assets/icons/info-circle.svg',
                    () {},
                  ),
                  _buildProfileOption(
                    context,
                    'Help & Feedback'.tr(),
                    'assets/icons/flash.svg',
                    () {},
                  ),
                  _buildProfileOption(
                    context,
                    'Support Us'.tr(),
                    'assets/icons/like.svg',
                    () {},
                  ),
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
      _buildStatBox('$_uncompletedCount ${'Task left'.tr()}'),
      const SizedBox(width: 20),
      _buildStatBox('$_completedCount ${'Task done'.tr()}'),
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
      title: Text(
        'Log out'.tr(),
        style: const TextStyle(color: Colors.red, fontSize: 16, fontFamily: 'Lato'),
      ),
      onTap: () => _showLogoutDialog(context),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Log out'.tr()),
        content: Text('Choose how you want to log out.'.tr()),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text('Keep login info'.tr()),
          ),
          TextButton(
            onPressed: () => _handleClearAndRestart(context),
            child: Text('Clear & restart'.tr(), style: const TextStyle(color: Colors.red)),
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
        title: Text(
          'Change account name'.tr(),
          style: const TextStyle(color: tdWhite, fontSize: 18, fontFamily: 'Lato'),
        ),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: tdWhite, fontFamily: 'Lato'),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            hintText: 'Enter new name'.tr(),
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
            child: Text('Cancel'.tr(), style: const TextStyle(color: tdWhite, fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () => _handleEditUserName(context, nameController),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
            ),
            child: Text('Edit'.tr(), style: const TextStyle(color: tdWhite, fontSize: 16)),
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
        title: Text('Change account Password'.tr(), style: const TextStyle(color: tdWhite, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPasswordField(oldPasswordController, 'Enter old password'.tr()),
            const SizedBox(height: 12),
            _buildPasswordField(newPasswordController, 'Enter new password'.tr()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'.tr(), style: const TextStyle(color: tdWhite, fontSize: 16)),
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
            child: Text('Edit'.tr(), style: const TextStyle(color: tdWhite, fontSize: 16)),
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
        SnackBar(content: Text('Please fill in both fields'.tr())),
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
        SnackBar(content: Text('Password changed successfully'.tr())),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Old password is incorrect'.tr())),
      );
    }
  }
}

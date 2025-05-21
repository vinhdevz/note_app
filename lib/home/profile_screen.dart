import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/about_us_screen.dart';
import 'package:flutter_todo_app/home/faq_screen.dart';
import 'package:flutter_todo_app/home/setting_screen.dart';
import 'package:flutter_todo_app/database/task_database.dart';
import 'package:image_picker/image_picker.dart';
import '../database/user_db.dart';
import 'dart:developer' as developer;

class ProfileScreen extends StatefulWidget {
  final String? username;
  final void Function() onLogout;

  const ProfileScreen({
    super.key,
    required this.username,
    required this.onLogout,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _fullname = 'Guest';
  int _completedCount = 0;
  int _uncompletedCount = 0;
  File? _selectedImage;
  String? _imagePath;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final fullnameFuture =
          UserDatabase.instance.getFullName(widget.username ?? '');
      final statsFuture = TaskDatabase.instance.loadTaskStats();
      final imagePathFuture =
          UserDatabase.instance.getProfileImage(widget.username ?? '');

      final results =
          await Future.wait([fullnameFuture, statsFuture, imagePathFuture]);

      setState(() {
        _fullname = results[0] as String? ?? 'Guest';
        final stats = results[1] as Map<String, int>;
        _completedCount = stats['completed'] ?? 0;
        _uncompletedCount = stats['uncompleted'] ?? 0;
        final imagePath = results[2] as String?;
        if (imagePath != null &&
            imagePath.isNotEmpty &&
            File(imagePath).existsSync()) {
          _imagePath = imagePath;
        }
      });
    } catch (e) {
      developer.log('Error loading user data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profile data'.tr())),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
        _imagePath = pickedImage.path;
      });
      await UserDatabase.instance
          .updateProfileImage(widget.username ?? '', pickedImage.path);
      developer.log('Image saved to database for user: ${widget.username}');
    }
  }

  Future<void> _removeProfileImage() async {
    await UserDatabase.instance.updateProfileImage(widget.username ?? '', '');
    setState(() {
      _selectedImage = null;
      _imagePath = null;
    });
    developer.log('Profile image removed for user: ${widget.username}');
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
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: tdWhite,
                ),
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
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: Text('Remove profile image'.tr(),
                    style: const TextStyle(color: Colors.red)),
                onTap: () {
                  Navigator.pop(context);
                  _removeProfileImage();
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: tdPurple))
          : Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => _showImageSourceSheet(context),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: _getProfileImage(),
                      child: _getProfileImage() == null
                          ? const Icon(Icons.person,
                              size: 50, color: Colors.grey)
                          : null,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _fullname,
                    style: const TextStyle(
                      color: tdWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Lato',
                    ),
                  ),
                  const SizedBox(height: 20),
                  TaskStats(
                    uncompletedCount: _uncompletedCount,
                    completedCount: _completedCount,
                  ),
                  const SizedBox(height: 32),
                  Expanded(
                    child: ListView(
                      children: [
                        SectionTitle(title: 'Settings'.tr()),
                        ProfileOption(
                          title: 'App Settings'.tr(),
                          iconPath: 'assets/icons/setting.svg',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const SettingScreen()),
                            );
                          },
                        ),
                        SectionTitle(title: 'Account'.tr()),
                        ProfileOption(
                          title: 'Change full name'.tr(),
                          iconPath: 'assets/icons/user.svg',
                          onTap: () => _showChangeNameDialog(context),
                        ),
                        ProfileOption(
                          title: 'Change account password'.tr(),
                          iconPath: 'assets/icons/key.svg',
                          onTap: () => _showChangePassDialog(context),
                        ),
                        ProfileOption(
                          title: 'Change account image'.tr(),
                          iconPath: 'assets/icons/camera.svg',
                          onTap: () => _showImageSourceSheet(context),
                        ),
                        SectionTitle(title: 'Uptodo'.tr()),
                        ProfileOption(
                          title: 'About Us'.tr(),
                          iconPath: 'assets/icons/menu.svg',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AboutUsScreen(),
                              ),
                            );
                          },
                        ),
                        ProfileOption(
                          title: 'FAQ'.tr(),
                          iconPath: 'assets/icons/info_circle.svg',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => FAQScreen()),
                            );
                          },
                        ),
                        ProfileOption(
                          title: 'Help & Feedback'.tr(),
                          iconPath: 'assets/icons/flash.svg',
                          onTap: () {},
                        ),
                        ProfileOption(
                          title: 'Support Us'.tr(),
                          iconPath: 'assets/icons/like.svg',
                          onTap: () {},
                        ),
                        ListTile(
                          leading: SvgPicture.asset('assets/icons/logout.svg',
                              width: 24, height: 24),
                          title: Text(
                            'Log out'.tr(),
                            style: const TextStyle(
                                color: Colors.red,
                                fontSize: 16,
                                fontFamily: 'Lato'),
                          ),
                          onTap: () => _showLogoutDialog(context),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  ImageProvider? _getProfileImage() {
    if (_selectedImage != null) {
      return FileImage(_selectedImage!);
    }
    if (_imagePath != null &&
        _imagePath!.isNotEmpty &&
        File(_imagePath!).existsSync()) {
      return FileImage(File(_imagePath!));
    }
    return const AssetImage('assets/images/avatar.png');
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
            onPressed: () async {
              await UserDatabase.instance.saveLoginState(widget.username ?? '');
              Navigator.of(context).pop();
              widget.onLogout();
              Navigator.of(context).pushReplacementNamed('/login');
            },
            child: Text('Keep login info'.tr()),
          ),
          TextButton(
            onPressed: () async {
              await UserDatabase.instance.clearLoginState();
              Navigator.of(context).pop();
              widget.onLogout();
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/intro', (route) => false);
            },
            child: Text('Clear & restart'.tr(),
                style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChangeNameDialog(BuildContext context) {
    final nameController = TextEditingController(text: _fullname);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Change full name'.tr(),
          style:
              const TextStyle(color: tdWhite, fontSize: 18, fontFamily: 'Lato'),
        ),
        content: TextField(
          controller: nameController,
          style: const TextStyle(color: tdWhite, fontFamily: 'Lato'),
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey[800],
            hintText: 'Enter new full name'.tr(),
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
            child: Text('Cancel'.tr(),
                style: const TextStyle(color: tdWhite, fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () async {
              final newFullname = nameController.text.trim();
              if (newFullname.isNotEmpty && newFullname != _fullname) {
                await UserDatabase.instance
                    .updateFullName(widget.username ?? '', newFullname);
                setState(() {
                  _fullname = newFullname;
                });
              }
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: Text('Edit'.tr(),
                style: const TextStyle(color: tdWhite, fontSize: 16)),
          ),
        ],
      ),
    );
  }

  void _showChangePassDialog(BuildContext context) {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text('Change account Password'.tr(),
            style: const TextStyle(color: tdWhite, fontSize: 18)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildPasswordField(
                oldPasswordController, 'Enter old password'.tr()),
            const SizedBox(height: 12),
            _buildPasswordField(
                newPasswordController, 'Enter new password'.tr()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'.tr(),
                style: const TextStyle(color: tdWhite, fontSize: 16)),
          ),
          ElevatedButton(
            onPressed: () async {
              final oldPass = oldPasswordController.text.trim();
              final newPass = newPasswordController.text.trim();

              if (oldPass.isEmpty || newPass.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Please fill in both fields'.tr())),
                );
                return;
              }

              final success = await UserDatabase.instance.updatePassWord(
                userName: widget.username ?? '',
                oldPassWord: oldPass,
                newPassWord: newPass,
              );

              if (success) {
                await UserDatabase.instance
                    .saveLoginState(widget.username ?? '');
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Password changed successfully'.tr())),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Old password is incorrect'.tr())),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: tdDarkPurple,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6)),
            ),
            child: Text('Edit'.tr(),
                style: const TextStyle(color: tdWhite, fontSize: 16)),
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
}

class TaskStats extends StatelessWidget {
  final int uncompletedCount;
  final int completedCount;

  const TaskStats({
    super.key,
    required this.uncompletedCount,
    required this.completedCount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StatBox(text: '$uncompletedCount ${'Task left'.tr()}'),
        const SizedBox(width: 20),
        StatBox(text: '$completedCount ${'Task done'.tr()}'),
      ],
    );
  }
}

class StatBox extends StatelessWidget {
  final String text;

  const StatBox({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style:
            const TextStyle(color: tdWhite, fontSize: 14, fontFamily: 'Lato'),
      ),
    );
  }
}

class ProfileOption extends StatelessWidget {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.title,
    required this.iconPath,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SvgPicture.asset(iconPath, width: 24, height: 24),
      title: Text(
        title,
        style:
            const TextStyle(color: tdWhite, fontSize: 16, fontFamily: 'Lato'),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, color: tdWhite, size: 16),
      onTap: onTap,
    );
  }
}

class SectionTitle extends StatelessWidget {
  final String title;

  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
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

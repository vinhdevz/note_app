import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/profile_screen.dart';
import 'package:flutter_todo_app/home/widgets/bottom_appbar.dart';
import 'package:flutter_todo_app/home/widgets/index_page.dart';
import 'package:flutter_todo_app/home/widgets/add_button.dart';
import 'package:flutter_todo_app/home/widgets/add_task_screen.dart';
import 'package:flutter_todo_app/database/user_db.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required String username});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  final GlobalKey<IndexPageState> _indexPageKey = GlobalKey<IndexPageState>();
  int _currentIndex = 0;
  List<String> tasks = [];
  String? _userName;

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final savedLogin = await UserDatabase.instance.getSavedLogin();
    setState(() {
      _userName = savedLogin?['username'] ?? 'Guest';
    });
  }

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return IndexPage(key: _indexPageKey);
      case 1:
        return const Center(
          child: Text('Calendar page', style: TextStyle(color: Colors.white)),
        );
      case 2:
        return const Center(
          child: Text('Focus page', style: TextStyle(color: Colors.white)),
        );
      case 3:
        return ProfileScreen(
          username: _userName ?? 'Guest',
          onLogout: _handleLogout,
        );
      default:
        return const Center(
          child: Text('Page not found', style: TextStyle(color: tdWhite)),
        );
    }
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    extendBody: true, 
    backgroundColor: tdBgColor,
    body: _getCurrentPage(),

   
    bottomNavigationBar: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        BottomAppbar(
          currentIndex: _currentIndex,
          onTabSelected: _onTabSelected,
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 76), 
          child: FloatingAddButton(
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: tdGrey,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                builder: (context) => AddTaskBottomSheet(
                 onTaskAdded: () {
    _indexPageKey.currentState?.refreshAll(); 
  },

                ),
              );
            },
          ),
        ),
      ],
    ),
  );
}

  void _handleLogout() async {
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }
}

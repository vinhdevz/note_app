import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/widgets/bottom_appbar.dart';
import 'package:flutter_todo_app/home/widgets/index_page.dart';
import 'package:flutter_todo_app/home/widgets/add_button.dart';
import 'package:flutter_todo_app/home/widgets/add_task_screen.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/database/user_db.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> _titles = ['Index', 'Calendar', 'Focus', 'Profile'];
  List<String> tasks = [];
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUsername();
  }

  Future<void> _loadUsername() async {
    String? username = await UserDatabase.instance.getSavedLogin();
    setState(() {
      _username = username ?? 'Guest';
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
         return const IndexPage(); 
      case 1:
        return const Center(child: Text('Calendar page', style: TextStyle(color: Colors.white)));
      case 2:
        return const Center(child: Text('Focus page', style: TextStyle(color: Colors.white)));
      case 3:
        return const Center(child: Text('Profile page', style: TextStyle(color: Colors.white)));
      default:
        return const Center(
            child: Text('Page not found', style: TextStyle(color: tdWhite)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
     
      body: _getCurrentPage(),
      floatingActionButton: FloatingAddButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            backgroundColor: tdGrey,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
           builder: (context) => const AddTaskBottomSheet(),

          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppbar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
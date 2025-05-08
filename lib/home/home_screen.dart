import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/database/user_db.dart';
import 'package:flutter_todo_app/home/profile_screen.dart';
import 'package:flutter_todo_app/home/widgets/botton_bar.dart';
import 'package:flutter_todo_app/home/widgets/index_page.dart';
import 'package:flutter_todo_app/home/widgets/add_button.dart';
import 'package:flutter_todo_app/home/widgets/addTask_screen.dart';

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

  void _addTask(String task) {
    setState(() {
      tasks.add(task);
    });
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return IndexPage(tasks: tasks, addTaskCallback: _addTask);
      case 1:
        return const Center(
            child: Text('Calendar Page', style: TextStyle(color: tdWhite)));
      case 2:
        return const Center(
            child: Text('Focus Page', style: TextStyle(color: tdWhite)));
      case 3:
        return ProfileScreen(
          username: _username,
          onLogout: () {
            Navigator.pushReplacementNamed(context, '/login');
          },
        );
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
          showAddTaskModal(context, (newTask) {
            _addTask(newTask);
          });
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/widgets/botton_bar.dart'; 
import 'package:flutter_todo_app/home/widgets/index_page.dart';
import 'package:flutter_todo_app/home/widgets/add_button.dart';
import  'package:flutter_todo_app/home/widgets/addTask_screen.dart'; 
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  int _currentIndex = 0;
  final List<String> _titles = ['Index', 'Calendar', 'Focus', 'Profile'];
  List<String> tasks = [];

  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return IndexPage(tasks: tasks);
      case 1:
        // return const CalendarPage();
      case 2:
        // return const FocusPage();
      case 3:
        // return const ProfilePage();
      default:
        return const Center(child: Text('Page not found', style: TextStyle(color: Colors.white)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: tdBgColor,
        elevation: 0,
        title: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/Home.svg',
              width: 42,
              height: 42,
            ),
            Expanded(
              child: Center(
                child: Text(
                  _titles[_currentIndex],
                  style: TextStyle(
                    color: tdText,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
              radius: 21,
            ),
          ],
        ),
      ),
      body: _getCurrentPage(),
      floatingActionButton: FloatingAddButton(
        onPressed: () {
          showAddTaskModal(context);
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

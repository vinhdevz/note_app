import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/widgets/botton_bar.dart'; // Import file bottom bar
import 'package:flutter_todo_app/home/widgets/index_page.dart';
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<String> _titles = ['Index', 'Calendar', 'Focus', 'Profile'];
  List<String> tasks= [];
  void _onTabSelected(int index) {
    setState(() {
      _currentIndex = index;
      // Nếu bạn muốn đổi màn hình theo tab, xử lý ở đây
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
        backgroundColor: tdBgColor,
        elevation: 0,
        title: Row(
          children: [
            SvgPicture.asset(
              '/Users/admin/note_app/assets/icons/Home.svg',
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
              backgroundImage: AssetImage('/Users/admin/note_app/assets/images/avatar.png'),
              radius: 21,
            ),
          ],
        ),
      ),
      body: _getCurrentPage(),
      floatingActionButton: 
      SizedBox(
        height: 64,
        width: 64,
        child:FloatingActionButton(
        backgroundColor: tdPurple,
        onPressed: () {
          // Thêm action khi nhấn nút +
        },
        shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(50), 
    
  ),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),),
      
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomBar(
        currentIndex: _currentIndex,
        onTabSelected: _onTabSelected,
      ),
    );
  }
}

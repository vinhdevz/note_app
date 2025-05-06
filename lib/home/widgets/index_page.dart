import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';

class IndexPage extends StatelessWidget {
  final List<String>? tasks; // Bạn có thể thay String bằng model Task nếu cần

  const IndexPage({super.key, this.tasks});

  @override
  Widget build(BuildContext context) {
    final isEmpty = tasks == null || tasks!.isEmpty;

    return Scaffold(
      backgroundColor: tdBgColor,
      body: Center(
        child: isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty.png', 
                    width: 227,
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'What do you want to do today?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap + to add your tasks',
                    style: TextStyle(
                      color: tdText,
                      fontSize: 16,
                    ),
                  ),
                ],
                
              )
              
            : const Text(
                'Tasks sẽ hiển thị ở đây khi có dữ liệu.',
                style: TextStyle(color: Colors.white),
              ),
           
      ),
      
    );
  }
}

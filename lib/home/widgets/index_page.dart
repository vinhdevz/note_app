import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_todo_app/constants/color.dart';

class IndexPage extends StatelessWidget {
  final List<String> tasks;
  final Function(String) addTaskCallback;

  const IndexPage({super.key, required this.tasks, required this.addTaskCallback});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: tdBgColor,
       appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: tdBlack,
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
                  'Index',
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
      body: tasks.isEmpty? 
      
      _buildEmpty()
        : ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return Card(
                color: tdBlack,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(
                    tasks[index],
                    style: const TextStyle(color: tdWhite, fontSize: 16),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: tdPurple),
                    onPressed: () {
                    },
                  ),
                ),
              );
            },
          )
    ); 
  }

  Widget _buildEmpty() {
    return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/empty.png', 
                height: 200,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 20),
              const Text(
                'What do you want to do today?',
                style: TextStyle(color: tdWhite, fontSize: 18, fontFamily: 'Lato'),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Tap + to add your tasks',
                style: TextStyle(color: tdGrey, fontSize: 14, fontFamily: 'Lato'),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
  }
}
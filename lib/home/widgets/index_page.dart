import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/home/widgets/task_card.dart';
import 'package:flutter_todo_app/database/task_database.dart';
class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  
 
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  late Future<List<TaskModel>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = TaskDatabase.instance.readAllTasks();
  }

  
  void _loadTasks() {
    setState(() {
      _tasksFuture = TaskDatabase.instance.readAllTasks();
    });
  }

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
            const Expanded(
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
      
      body: FutureBuilder<List<TaskModel>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmpty();
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.only(top: 20),
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return TaskCard(
                  task: tasks[index],
                  onDelete: _loadTasks,
                );
              },
            );
          }
        },
      ),
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
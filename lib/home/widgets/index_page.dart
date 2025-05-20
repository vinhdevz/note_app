// index_page.dart
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/widgets/create_category_screen.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/home/widgets/task_card.dart';
import 'package:flutter_todo_app/database/task_database.dart';
import 'package:flutter_todo_app/models/category_model.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  IndexPageState createState() => IndexPageState();
}

class IndexPageState extends State<IndexPage> {
  late Future<List<TaskModel>> _tasksFuture;
   List<CategoryModel> _categories = []; 


void refreshAll() {
  loadTasks();
  loadCategories();
}


  @override
  void initState() {
    super.initState();
    loadTasks(); 
     loadCategories(); 
  }

  
  void loadTasks() {
    setState(() {
      _tasksFuture = TaskDatabase.instance.readAllTasks();
    });
  }
  void loadCategories() async {
    final cats = await TaskDatabase.instance.readAllCategories(); 
    setState(() {
      _categories = cats;
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
            SvgPicture.asset('assets/icons/Home.svg', width: 42, height: 42),
             Expanded(
              child: Center(
                child: Text(
                  'Index'.tr(),
                  style: const TextStyle(
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
  final task = tasks[index];

  CategoryModel? category;
  for (var c in _categories) {
    if (c.id == task.categoryId) {
      category = c;
      break;
    }
  }

  return TaskCard(
    task: task,
    onDelete: loadTasks,
    category: category,
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
          Image.asset('assets/images/empty.png', height: 200, fit: BoxFit.contain),
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

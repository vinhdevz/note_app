import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: colorScheme.onPrimary, 
        elevation: 0,
        title: Row(
          children: [
            SvgPicture.asset('assets/icons/Home.svg', width: 42, height: 42, color: colorScheme.primary),
            Expanded(
              child: Center(
                child: Text(
                  'Index'.tr(),
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
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
            return Center(child: CircularProgressIndicator(color: colorScheme.primary));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: textTheme.bodyMedium));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildEmpty(context);
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

  Widget _buildEmpty(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/empty.png', height: 200, fit: BoxFit.contain),
          const SizedBox(height: 20),
          Text(
            'What do you want to do today?',
            style: textTheme.bodyLarge?.copyWith(color: colorScheme.onBackground),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Tap + to add your tasks',
            style: textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

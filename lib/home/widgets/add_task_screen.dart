import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/widgets/select_date_dialog.dart';
import 'package:flutter_todo_app/home/widgets/select_priority_dialog.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/database/task_database.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_todo_app/home/widgets/select_category_dialog.dart';

class AddTaskBottomSheet extends StatefulWidget {
  final VoidCallback onTaskAdded;
  final TaskModel? existingTask;
  const AddTaskBottomSheet({
    super.key,
    required this.onTaskAdded,
    this.existingTask,
  });

  @override
  State<AddTaskBottomSheet> createState() => _AddTaskBottomSheetState();
}

class _AddTaskBottomSheetState extends State<AddTaskBottomSheet> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDateTime;
  int _priority = 1;
  int? _selectedCategoryId;
  String? _categoryName;

  @override
  void initState() {
    super.initState();
    final task = widget.existingTask;
    if (task != null) {
      _titleController.text = task.title;
      _descController.text = task.description ?? '';
      _selectedDateTime = task.dateTime;
      _priority = task.priority;
      _selectedCategoryId = task.categoryId;
    }
  }

  InputDecoration _inputDecoration(String hint) => InputDecoration(
        hintText: hint.tr(),
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: tdGrey,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.white, width: 1.5),
        ),
      );

  Future<void> _submitTask() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PleaseCompleteTitleAndTime'.tr())),
      );
      return;
    }

    final task = TaskModel(
      id: widget.existingTask?.id,
      title: title,
      description: _descController.text.trim(),
      dateTime: _selectedDateTime!,
      priority: _priority,
      categoryId: _selectedCategoryId,
    );

    try {
      if (widget.existingTask != null) {
        await TaskDatabase.instance.updateTask(task);
      } else {
        await TaskDatabase.instance.createTask(task);
      }
      widget.onTaskAdded();
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('ErrorSavingTask'.tr(args: [e.toString()]))),
      );
    }
  }

  void _handleIconTap(String action) {
    switch (action) {
      case 'date':
        showDialog(
          context: context,
          builder: (_) => SelectDateDialog(onDateTimeSelected: (value) {
            setState(() => _selectedDateTime = value);
          }),
        );
        break;
      case 'priority':
        showDialog(
          context: context,
          builder: (_) => SelectPriorityDialog(
            selectedPriority: _priority,
            onSave: (value) => setState(() => _priority = value),
          ),
        );
        break;
      case 'tag':
        showDialog(
          context: context,
          builder: (_) => SelectCategoryDialog(
            selectedCategoryId: _selectedCategoryId,
            onSave: (cat) => setState(() {
              _selectedCategoryId = cat.id;
              _categoryName = cat.label;
            }),
          ),
        );
        break;
    }
  }

  Widget _iconButton(String iconPath, String action) => GestureDetector(
        onTap: () => _handleIconTap(action),
        child: Padding(
          padding: const EdgeInsets.only(right: 26),
          child: SvgPicture.asset(iconPath, width: 24, height: 24),
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        top: 24,
        left: 20,
        right: 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.existingTask == null ? 'Add Task'.tr() : 'Edit Task'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _titleController,
            decoration: _inputDecoration('Enter task title'),
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            decoration: _inputDecoration('Description'),
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _iconButton('assets/icons/timer.svg', 'date'),
              _iconButton('assets/icons/tag.svg', 'tag'),
              _iconButton('assets/icons/flag.svg', 'priority'),
              const Spacer(),
              GestureDetector(
                onTap: _submitTask,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SvgPicture.asset('assets/icons/send.svg', width: 24, height: 24),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

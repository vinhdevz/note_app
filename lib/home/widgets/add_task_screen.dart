import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/widgets/select_date_dialog.dart';
import 'package:flutter_todo_app/home/widgets/select_priority_dialog.dart';
import 'package:flutter_todo_app/models/task_model.dart';
import 'package:flutter_todo_app/database/task_database.dart';
import 'package:easy_localization/easy_localization.dart';

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
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  DateTime? _selectedDateTime;
  int _priority = 1;

  @override
  void initState() {
    super.initState();
    if (widget.existingTask != null) {
      _titleController.text = widget.existingTask!.title;
      _descController.text = widget.existingTask!.description ?? '';
      _selectedDateTime = widget.existingTask!.dateTime;
      _priority = widget.existingTask!.priority;
    }
  }

  Future<void> _submitTask() async {
    final title = _titleController.text.trim();
    if (title.isEmpty || _selectedDateTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('PleaseCompleteTitleAndTime'.tr())),
      );
      return;
    }

    final updatedTask = TaskModel(
      id: widget.existingTask?.id,
      title: title,
      description: _descController.text.trim(),
      dateTime: _selectedDateTime!,
      priority: _priority,
    );

    try {
      if (widget.existingTask != null) {
        await TaskDatabase.instance.updateTask(updatedTask);
      } else {
        await TaskDatabase.instance.createTask(updatedTask);
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
          builder: (BuildContext context) => SelectDateDialog(
            onDateTimeSelected: (value) {
              setState(() {
                _selectedDateTime = value;
              });
            },
          ),
        );
        break;
      case 'priority':
        showDialog(
          context: context,
          builder: (BuildContext context) => SelectPriorityDialog(
            selectedPriority: _priority,
            onSave: (value) {
              setState(() {
                _priority = value;
              });
            },
          ),
        );
        break;
      case 'tag':
        // chưa xử lý
        break;
    }
  }

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
              'Add Task'.tr(),
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
            decoration: InputDecoration(
              hintText: 'Enter task title'.tr(),
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
            ),
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descController,
            decoration: InputDecoration(
              hintText: 'Description'.tr(),
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
            ),
            cursorColor: Colors.white,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              GestureDetector(
                onTap: () => _handleIconTap('date'),
                child: Padding(
                  padding: const EdgeInsets.only(right: 26),
                  child: SvgPicture.asset(
                    'assets/icons/timer.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _handleIconTap('tag'),
                child: Padding(
                  padding: const EdgeInsets.only(right: 26),
                  child: SvgPicture.asset(
                    'assets/icons/tag.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => _handleIconTap('priority'),
                child: Padding(
                  padding: const EdgeInsets.only(right: 26),
                  child: SvgPicture.asset(
                    'assets/icons/flag.svg',
                    width: 24,
                    height: 24,
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _submitTask,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SvgPicture.asset(
                    'assets/icons/send.svg',
                    width: 24,
                    height: 24,
                  ),
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

import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';

void showAddTaskModal(BuildContext context, Function(String) onTaskAdded) {
  final _controller = TextEditingController();

  showModalBottomSheet(
    context: context,
    backgroundColor: tdBlack,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add New Task',
              style: TextStyle(color: tdWhite, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Enter task',
                hintStyle: const TextStyle(color: tdGrey),
                enabledBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: tdGrey),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: tdPurple),
                ),
              ),
              style: const TextStyle(color: tdWhite),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  onTaskAdded(_controller.text);
                  Navigator.pop(context);
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: tdPurple,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Add Task', style: TextStyle(color: tdWhite)),
            ),
          ],
        ),
      );
    },
  );
}
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'selectDate_screen.dart';

void showAddTaskModal(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: tdGrey,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
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
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Add Task',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Title Input
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter task title',
                hintStyle: const TextStyle(color: Colors.white70),
                filled: true,
                fillColor: tdGrey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
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

            // Description Input
            TextField(
              decoration: InputDecoration(
                hintText: 'Description',
                hintStyle: const TextStyle(color: Colors.white54),
                filled: true,
                fillColor: tdGrey,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.transparent),
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

            // Icon row
            Row(
              children: [
                GestureDetector(
                  onTap: () => showSelectDateDialog(context),
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
                  // onTap: () => showSelectTagDialog(context),
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
                  // onTap: () => showSelectPriorityDialog(context),
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
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: SvgPicture.asset(
                    'assets/icons/send.svg',
                    
                    width: 24,
                    height: 24,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),
          ],
        ),
      );
    },
  );
}

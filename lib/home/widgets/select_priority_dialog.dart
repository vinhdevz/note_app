import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_svg/flutter_svg.dart';  
class SelectPriorityDialog extends StatefulWidget {
  final int selectedPriority;
  final void Function(int) onSave;

  const SelectPriorityDialog({
    super.key,
    required this.selectedPriority,
    required this.onSave,
  });

  @override
  State<SelectPriorityDialog> createState() => _SelectPriorityDialogState();
}

class _SelectPriorityDialogState extends State<SelectPriorityDialog> {
  late int _selected;

  @override
  void initState() {
    super.initState();
    _selected = widget.selectedPriority;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      backgroundColor: tdGrey,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Task Priority',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: tdText),
            SizedBox(
              height: 300, 
              child: GridView.builder(
                itemCount: 10,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 18,
                  mainAxisSpacing: 18,
                ),
                itemBuilder: (context, index) {
                  final num = index + 1;
                  final isSelected = num == _selected;
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _selected = num;
                      });
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? tdPurple : Color(0xff272727),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                         
                          SvgPicture.asset(
                            'assets/icons/flag.svg',  
                           
                            width: 24,
                            height: 24,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            '$num',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
           
            Row(
  children: [
    Expanded(
      child: SizedBox(
        height: 50,
        child: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text(
            "Cancel",
            style: TextStyle(color: tdPurple, fontSize: 16),
          ),
        ),
      ),
    ),
    const SizedBox(width: 10),
    Expanded(
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          onPressed: () {
            widget.onSave(_selected);
            Navigator.pop(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: tdPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          child: const Text(
            "Save",
            style: TextStyle(color: tdText, fontSize: 16),
          ),
        ),
      ),
    ),
  ],
)

          ],
        ),
      ),
    );
  }
}

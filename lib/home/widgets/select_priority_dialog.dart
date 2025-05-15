import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:easy_localization/easy_localization.dart';

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
            Text(
              'Task Priority'.tr(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Divider(color: tdText),
            const SizedBox(height: 10),
            Column(
              children: [
                _buildPriorityOption(1, 'Easy'.tr(), iconEasy, priEasy),
                const SizedBox(height: 10),
                _buildPriorityOption(2, 'Normal'.tr(), iconNormal, priNormal),
                const SizedBox(height: 10),
                _buildPriorityOption(3, 'Hard'.tr(), iconHard, priHard),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "Cancel".tr(),
                        style: const TextStyle(color: tdPurple, fontSize: 16),
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
                      child: Text(
                        "Save".tr(),
                        style: const TextStyle(color: tdText, fontSize: 16),
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

  Widget _buildPriorityOption(int value, String label, Color iconColor, Color bgColor) {
    final bool isSelected = _selected == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selected = value;
        });
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? bgColor : tdGrey,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isSelected ? Colors.black : tdPurple,
            width: 2,
          ),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            SvgPicture.asset(
              'assets/icons/flag.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                isSelected ? iconColor : Colors.white,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            )
          ],
        ),
      ),
    );
  }
}

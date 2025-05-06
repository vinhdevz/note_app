import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';

Future<TimeOfDay?> showSelectTimeDialog(BuildContext context) async {
  return showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
    helpText: 'Choose time',
    cancelText: 'Cancel',
    confirmText: 'Save',
    initialEntryMode: TimePickerEntryMode.input,
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData.dark().copyWith(
          timePickerTheme: TimePickerThemeData(
            backgroundColor: tdGrey,
            hourMinuteTextColor: Colors.white,
            hourMinuteShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            hourMinuteTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
              height: 2.5,
            ),
            dayPeriodTextColor: Colors.white,
            dayPeriodShape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            dayPeriodColor: WidgetStateColor.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return tdPurple;
              }
              return const Color(0xFF1E1E1E);
            }),
            dialHandColor: tdPurple,
            dialBackgroundColor: const Color(0xFF1E1E1E),
            entryModeIconColor: tdPurple,
            helpTextStyle: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
            cancelButtonStyle: TextButton.styleFrom(
              foregroundColor: tdPurple,
              textStyle: const TextStyle(fontSize: 16),
            ),
            confirmButtonStyle: ElevatedButton.styleFrom(
              backgroundColor: tdPurple,
              foregroundColor: Colors.white,
              textStyle: const TextStyle(fontSize: 16),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          colorScheme: ColorScheme.dark(
            primary: tdPurple,
            onSurface: Colors.white,
          ),
        ),
        child: Dialog(
          backgroundColor: tdGrey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: SizedBox(
              height: 270, 
              child: child!,
            ),
          ),
        ),
      );
    },
  );
}

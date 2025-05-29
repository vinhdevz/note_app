import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:easy_localization/easy_localization.dart';

class SelectTimeDialog extends StatefulWidget {
  final void Function(TimeOfDay time) onTimeSelected;

  const SelectTimeDialog({super.key, required this.onTimeSelected});

  @override
  State<SelectTimeDialog> createState() => _SelectTimeDialogState();
}

class _SelectTimeDialogState extends State<SelectTimeDialog> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTimePicker(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: const Padding(
        padding: EdgeInsets.all(15),
        child: SizedBox(
          height: 250,
          child: Center(
            child: Text(
              'Please choose a time',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _showTimePicker(BuildContext context) async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Choose Time'.tr(),
      cancelText: 'Cancel'.tr(),
      confirmText: 'Save'.tr(),
      initialEntryMode: TimePickerEntryMode.input,
      builder: (BuildContext context, Widget? child) {
        if (child == null) return const SizedBox();
        return Localizations.override(
          context: context,
          locale: const Locale('en'),
          child: Theme(
            data: Theme.of(context).copyWith(
              timePickerTheme: _buildTimePickerTheme(context),
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: tdPurple,
                    onSurface: Theme.of(context).colorScheme.onSurface,
                  ),
            ),
            child: _buildDialogContainer(child),
          ),
        );
      },
    );

    if (time != null) {
      widget.onTimeSelected(time);
    }
    Navigator.of(context).pop();
  }

  Dialog _buildDialogContainer(Widget child) {
    return Dialog(
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(3),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
          height: 270,
          child: child,
        ),
      ),
    );
  }

  TimePickerThemeData _buildTimePickerTheme(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return TimePickerThemeData(
      backgroundColor: colorScheme.surface,
      hourMinuteTextColor: colorScheme.onSurface,
      hourMinuteShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      hourMinuteTextStyle: TextStyle(
        color: colorScheme.onSurface,
        fontSize: 24,
        fontWeight: FontWeight.bold,
        height: 2.5,
      ),
      dayPeriodTextColor: colorScheme.onSurface,
      dayPeriodShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      dayPeriodColor: MaterialStateColor.resolveWith((states) {
        return states.contains(MaterialState.selected)
            ? tdPurple
            : colorScheme.surfaceVariant;
      }),
      dialHandColor: tdPurple,
      dialBackgroundColor: colorScheme.background,
      entryModeIconColor: tdPurple,
      helpTextStyle: TextStyle(
        color: colorScheme.onSurface,
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
    );
  }
}

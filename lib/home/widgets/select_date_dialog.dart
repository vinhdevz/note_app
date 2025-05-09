import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:flutter_todo_app/home/widgets/select_time_dialog.dart';

class SelectDateDialog extends StatefulWidget {
  final Function(DateTime) onDateTimeSelected;

  const SelectDateDialog({super.key, required this.onDateTimeSelected});

  @override
  _SelectDateDialogState createState() => _SelectDateDialogState();
}

class _SelectDateDialogState extends State<SelectDateDialog> {
  DateTime selectedDate = DateTime.now();

  void _onDaySelected(DateTime day, DateTime _) {
    setState(() {
      selectedDate = day;
    });
  }

  void _chooseTime() async {
  final time = await showDialog<TimeOfDay>(
    context: context,
    builder: (_) => SelectTimeDialog(
      onTimeSelected: (time) => Navigator.of(context).pop(time),
    ),
  );

  if (time != null) {
    final selectedDateTime = DateTime(
      selectedDate.year,
      selectedDate.month,
      selectedDate.day,
      time.hour,
      time.minute,
    );
    widget.onDateTimeSelected(selectedDateTime);  // Truyền DateTime (ngày + giờ) vào đây
    Navigator.of(context).pop();
  }
}


  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      backgroundColor: tdGrey,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(13),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TableCalendar(
              focusedDay: selectedDate,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) => isSameDay(day, selectedDate),
              onDaySelected: _onDaySelected,
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, _) => _buildDayCell(day, isSelected: false, isToday: false),
                selectedBuilder: (context, day, _) => _buildDayCell(day, isSelected: true, isToday: false),
                todayBuilder: (context, day, _) => _buildDayCell(day, isSelected: false, isToday: true),
                outsideBuilder: (context, day, _) => _buildDayCell(day, isSelected: false, isToday: false, isOutside: true),
              ),
              calendarStyle: const CalendarStyle(isTodayHighlighted: true),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextFormatter: (date, _) => '${_monthName(date.month).toUpperCase()}\n${date.year}',
                titleTextStyle: const TextStyle(color: Colors.white, fontSize: 16, height: 1.4),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white30, width: 1)),
                ),
                leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.white),
              ),
              daysOfWeekHeight: 30,
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                weekendStyle: TextStyle(color: Color(0xffFF4949), fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1.2),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Cancel", style: TextStyle(color: tdPurple, fontSize: 16)),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _chooseTime,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdPurple,
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: const Text("Choose Time", style: TextStyle(color: tdText, fontSize: 16)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayCell(
    DateTime day, {
    required bool isSelected,
    required bool isToday,
    bool isOutside = false,
  }) {
    final bgColor = isSelected
        ? tdPurple
        : isToday
            ? Colors.white24
            : const Color(0xFF272727);

    final textColor = isOutside
        ? Colors.white30
        : isSelected
            ? tdText
            : Colors.white;

    return Center(
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          '${day.day}',
          style: TextStyle(fontSize: 12, color: textColor),
        ),
      ),
    );
  }

  String _monthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }
}

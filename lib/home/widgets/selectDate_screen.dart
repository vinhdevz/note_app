
import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';
import 'package:table_calendar/table_calendar.dart';
import 'selectTime_screen.dart';

Future<void> showSelectDateDialog(BuildContext context) async {
  DateTime selectedDate = DateTime.now();

  await showDialog(
    context: context,
    builder: (context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
      backgroundColor: tdGrey,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TableCalendar(
              focusedDay: selectedDate,
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              selectedDayPredicate: (day) => isSameDay(day, selectedDate),
              onDaySelected: (selected, focused) {
                selectedDate = selected;
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, isSelected: false, isToday: false);
                },
                selectedBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, isSelected: true, isToday: false);
                },
                todayBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, isSelected: false, isToday: true);
                },
                outsideBuilder: (context, day, focusedDay) {
                  return _buildDayCell(day, isSelected: false, isToday: false, isOutside: true);
                },
              ),
              calendarStyle: const CalendarStyle(
                isTodayHighlighted: true,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextFormatter: (date, locale) {
                  // Custom format: Tháng ở trên, năm ở dưới
                  return '${_monthName(date.month).toUpperCase()}\n${date.year}';
                },
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  height: 1.4,
                ),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.white30, width: 1)),
                ),
                leftChevronIcon: Icon(Icons.chevron_left, color: Colors.white),
                rightChevronIcon: Icon(Icons.chevron_right, color: Colors.white),
              ),
              daysOfWeekHeight: 30, 
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
                weekendStyle: TextStyle(
                  color: Color(0xffFF4949),
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: tdPurple, fontSize: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      // Mở dialog chọn giờ khi nhấn "Choose Time"
                      final time = await showSelectTimeDialog(context);
                      if (time != null) {
                        print("Bạn chọn giờ: ${time.format(context)}");
                      }
                      Navigator.pop(context); // Đóng dialog chọn ngày
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: tdPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    child: const Text(
                      "Choose Time",
                      style: TextStyle(color: tdText, fontSize: 16),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
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
        style: TextStyle(
          fontSize: 12,
          color: textColor,
        ),
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

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_todo_app/constants/color.dart';

class BottomBar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const BottomBar({
    super.key,
    required this.onTabSelected,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: tdGrey,
      height: 85,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                _buildTabItem('assets/icons/home_index.svg', 'Index', 0),
                _buildTabItem('assets/icons/calendar.svg', 'Calendar', 1),
              ],
            ),
            Row(
              children: [
                _buildTabItem('assets/icons/clock.svg', 'Focuse', 2),
                _buildTabItem('assets/icons/user.svg', 'Profile', 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String iconPath, String label, int index) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTabSelected(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconPath,
              width: 24,
              height: 24,
              // ignore: deprecated_member_use
              color: isSelected ? tdPurple : Colors.white,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? tdPurple : Colors.white,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

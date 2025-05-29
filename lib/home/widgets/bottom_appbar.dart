import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';

class BottomAppbar extends StatelessWidget {
  final Function(int) onTabSelected;
  final int currentIndex;

  const BottomAppbar({
    super.key,
    required this.onTabSelected,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    
    return BottomAppBar(
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      color: Theme.of(context).colorScheme.tertiary,
      height: 85,
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Row(
              children: [
                _buildTabItem(context, 'assets/icons/home_index.svg', 'Index', 0),
                _buildTabItem(context, 'assets/icons/calendar.svg', 'Calendar', 1),
              ],
            ),
            Row(
              children: [
                _buildTabItem(context, 'assets/icons/clock.svg', 'Focus', 2),
                _buildTabItem(context, 'assets/icons/user.svg', 'Profile', 3),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(BuildContext context, String iconPath, String label, int index) {
    final isSelected = currentIndex == index;
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = isSelected ? colorScheme.secondary : colorScheme.onSurface;
    final textColor = isSelected ? colorScheme.secondary : colorScheme.onSurface;

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
              color: iconColor,
            ),
            const SizedBox(height: 4),
            Text(
              label.tr(),
              style: TextStyle(
                color: textColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

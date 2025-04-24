import 'package:flutter/material.dart';
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
      height:85,
      child: SafeArea(
       
        child: SizedBox(
         
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: [
                  _buildTabItem(Icons.home, 'Index', 0),
                  _buildTabItem(Icons.calendar_today, 'Calendar', 1),
                ],
              ),
              Row(
                children: [
                  _buildTabItem(Icons.access_time, 'Focus', 2),
                  _buildTabItem(Icons.person_outline, 'Profile', 3),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabItem(IconData icon, String label, int index) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTabSelected(index),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 14.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
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
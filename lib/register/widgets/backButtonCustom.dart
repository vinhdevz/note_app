import 'package:flutter/material.dart';
import 'package:flutter_todo_app/constants/color.dart';

class BackButtonCustom extends StatelessWidget {
  const BackButtonCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back_ios, color: tdWhite),
      onPressed: () => Navigator.pop(context),
    );
  }
}
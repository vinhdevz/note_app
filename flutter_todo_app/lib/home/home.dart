import 'package:flutter/material.dart';

class Home extends StatelessWidget{
  Home({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('ToDo App'),),
    );
  }
}
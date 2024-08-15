import 'package:flutter/material.dart';
import 'package:task_entry/home_page.dart';
import 'package:task_entry/task.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task entry App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        
      ),
      debugShowCheckedModeBanner: false,
      
      home: TaskHomePage(),
    );
  }
}










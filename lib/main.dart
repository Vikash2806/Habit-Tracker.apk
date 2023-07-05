import 'package:flutter/material.dart';
import 'package:habit_tracker_last/pages/home_page.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async {
  // initialize hive
  await Hive.initFlutter();

  // open a box
  await Hive.openBox("Habit_Database");

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.black,
            title: Text('HABIT TRACKER',
              style: TextStyle(
                fontSize:20,
                fontFamily: 'LexendPeta',
              ),
            ),
          ),
          body:HomePage()
      ),
      theme: ThemeData(primarySwatch: Colors.green),
      title: 'HabitTracker',

    );
  }
}
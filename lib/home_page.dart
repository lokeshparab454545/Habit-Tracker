import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habbit/utils/habit_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List habitList = [
    ["Exercise", false, 0, 2],
    ["Read", false, 0, 1],
    ["Meditate", false, 0, 3],
    ["Code", false, 0, 4],
  ];

  void habitStarted(int index) {
    var startTime = DateTime.now();
    int elapsedTime = habitList[index][2];
    setState(() {
      habitList[index][1] = !habitList[index][1];
    });

    if (habitList[index][1]) {
      Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          setState(
            () {
              if (!habitList[index][1]) {
                timer.cancel();
              }

              var currTime = DateTime.now();
              habitList[index][2] = elapsedTime +
                  currTime.second -
                  startTime.second +
                  60 * (currTime.minute - startTime.minute) +
                  60 * 60 * (currTime.hour - startTime.hour);
            },
          );
        },
      );
    }
  }

  void settingOpened(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Settings for " + habitList[index][0]),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        title: const Text("Habit Tracker"),
      ),
      body: ListView.builder(
        itemCount: habitList.length,
        itemBuilder: ((context, index) {
          return HabitTile(
            habitName: habitList[index][0],
            onTap: () {
              habitStarted(index);
            },
            settingsTapped: () {
              settingOpened(index);
            },
            habitStarted: habitList[index][1],
            timeSpent: habitList[index][2],
            timeGoal: habitList[index][3],
          );
        }),
      ),
    );
  }
}

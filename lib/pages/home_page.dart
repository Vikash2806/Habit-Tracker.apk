import 'package:flutter/material.dart';
import 'package:habit_tracker_last/components/habit_tile.dart';
import 'package:habit_tracker_last/components/month_summary.dart';
import 'package:habit_tracker_last/components/my_fab.dart';
import 'package:habit_tracker_last/components/my_alert_box.dart';
import 'package:habit_tracker_last/data/habit_database.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HabitDatabase db = HabitDatabase();
  final _myBox = Hive.box("Habit_Database");

  @override
  void initState() {
    // if there is no current habit list, then it is the 1st time ever opening the app
    // then create default data
    if (_myBox.get("CURRENT_HABIT_LIST") == null) {
      db.createDefaultData();
    }

    // there already exists data, this is not the first time
    else {
      db.loadData();
    }

    // update the database
    db.updateDatabase();

    super.initState();
  }
  //In Flutter, the void initState() method is a lifecycle method that is typically used to initialize state variables and perform one-time setup operations when a StatefulWidget is first created.


  // checkbox was tapped
  void checkBoxTapped(bool? value, int index) {
    setState(() {
      db.todaysHabitList[index][1] = value;
    });
    db.updateDatabase();
  }
  // Here's the updated explanation:
//
// When you press the checkbox, the onChanged event is triggered.
// The onChanged event is associated with the checkBoxTapped function.
// The checkBoxTapped function is called with the new value of the checkbox, which is of type bool? (nullable boolean).
// Inside the checkBoxTapped function, setState is called.
// setState notifies Flutter that the state of the widget has changed and needs to be updated.
// The framework schedules a rebuild of the widget.
// The build method of the widget is called again.
// In the build method, the habitCompleted variable, which holds the state of the checkbox, is updated indirectly through the checkBoxTapped function.
// The checkBoxTapped function assigns the value of the checkbox to habitCompleted indirectly through the value parameter.
// The updated habitCompleted value is then used within the build method to reflect the state change in the UI.




  // create a new habit
  final _newHabitNameController = TextEditingController();
  void createNewHabit() {
    // show alert dialog for user to enter the new habit details
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: 'Enter habit name..',
          onSave: saveNewHabit,
          onCancel: cancelDialogBox,
        );
      },
    );

    // In its on the pressed property, we have to use the showDialog widget of flutter. It takes context and a builder. In builder, we provide the AlertDialog widget with title,

  }

  // save new habit
  void saveNewHabit() {
    // add new habit to todays habit list
    setState(() {
      db.todaysHabitList.add([_newHabitNameController.text, false]);
    });

    // clear textfield
    _newHabitNameController.clear();
    // pop dialog box
    Navigator.of(context).pop();
    db.updateDatabase();
  }

  // cancel new habit
  void cancelDialogBox() {
    // clear textfield
    _newHabitNameController.clear();

    // pop dialog box
    Navigator.of(context).pop();
  }

  // open habit settings to edit
  void openHabitSettings(int index) {
    showDialog(
      context: context,
      builder: (context) {
        return MyAlertBox(
          controller: _newHabitNameController,
          hintText: db.todaysHabitList[index][0],
          onSave: () => saveExistingHabit(index),
          onCancel: cancelDialogBox,
        );
      },
    );
  }

  // save existing habit with a new name
  void saveExistingHabit(int index) {
    setState(() {
      db.todaysHabitList[index][0] = _newHabitNameController.text;
    });
    _newHabitNameController.clear();
    Navigator.pop(context);
    db.updateDatabase();
  }

  // delete habit
  void deleteHabit(int index) {
    setState(() {
      db.todaysHabitList.removeAt(index);
    });
    db.updateDatabase();
  }

  DateTime? selectedDate; // Add this line

  String selectedDateFormatted() {
    return DateFormat('yyyyMMdd').format(selectedDate!);
  }

  void setSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void searchHabits() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    ).then((date) {
      if (date != null) {
        setSelectedDate(date); // Update selected date using the method
        showHabitInfoAlertDialog();
      }
    });
  }


  void showHabitInfoAlertDialog() {
    List habitList = _myBox.get(selectedDateFormatted());

    List<Widget> habitTiles = habitList.map<Widget>((habit) {
      String habitName = habit[0];
      bool habitCompleted = habit[1];

      return ListTile(
        title: Text(habitName),
        trailing: Icon(
          habitCompleted ? Icons.check_circle : Icons.cancel,
          color: habitCompleted ? Colors.green : Colors.red,
        ),
      );
    }).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Habit Information - ${selectedDateFormatted()}'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: habitTiles,
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: searchHabits,
            tooltip: 'Search',
            child: Icon(Icons.search),
          ),
        SizedBox(height: 16),
          MyFloatingActionButton(onPressed: createNewHabit),
        ],
      ),
      body: ListView(
        children: [
          // monthly summary heat map
          MonthlySummary(
            datasets: db.heatMapDataSet,
            startDate: _myBox.get("START_DATE"),
          ),

          // list of habits
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: db.todaysHabitList.length,
            itemBuilder: (context, index) {
              return HabitTile(
                habitName: db.todaysHabitList[index][0],
                habitCompleted: db.todaysHabitList[index][1],
                onChanged: (value) => checkBoxTapped(value, index),//In the context of the onChanged property, (value) => checkBoxTapped(value, index) is an anonymous function that takes a single parameter value and calls the checkBoxTapped function with value and index as arguments.
                settingsTapped: (context) => openHabitSettings(index),
                deleteTapped: (context) => deleteHabit(index),
              );
            },
          )
        ],
      ),
    );
  }
}

// explain this line clearly: onChanged: (value) => checkBoxTapped(value) ,
//
// ChatGPT
// Certainly! Let's break down the line of code onChanged: (value) => checkBoxTapped(value):
//
// onChanged is a property of the Checkbox widget. It expects a callback function that gets invoked when the user interacts with the checkbox.
// (value) => checkBoxTapped(value) is an anonymous function that serves as the callback for the onChanged event.
// Here's how it works:
//
// When the state of the checkbox changes, the onChanged event is triggered.
// The anonymous function (value) => checkBoxTapped(value) is called.
// The value parameter represents the new value of the checkbox (a bool? type).
// The function then calls the checkBoxTapped function and passes the value parameter to it.
// Inside the checkBoxTapped function, the state of the widget is updated based on the new checkbox value, and setState is called to trigger a rebuild of the widget.
// In simpler terms, the line of code onChanged: (value) => checkBoxTapped(value) sets up a callback function that takes the new checkbox value as a parameter and calls the checkBoxTapped function with that value. This allows you to handle the state change of the checkbox and update the widget accordingl
//

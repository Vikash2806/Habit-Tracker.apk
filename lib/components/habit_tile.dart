import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:habit_tracker_last/datetime/date_time.dart';
import 'package:confetti/confetti.dart';

class HabitTile extends StatefulWidget {
  final String habitName;
  final bool ?habitCompleted;
  final Function(bool?)? onChanged;
  final Function(BuildContext)? settingsTapped;
  final Function(BuildContext)? deleteTapped;

  const HabitTile({
    super.key,
    required this.habitName,
    required this.habitCompleted,
    required this.onChanged,
    required this.settingsTapped,
    required this.deleteTapped,
  });

  @override
  State<HabitTile> createState() => _HabitTileState();
}

class _HabitTileState extends State<HabitTile> {


  Color tileColor = Colors.greenAccent[100]!;

  //FOR CONFETTI WIDGET:
  ConfettiController _confettiController = ConfettiController(duration: const Duration(seconds: 2));
  @override
  void dispose() {
    _confettiController.dispose(); // Dispose the confetti controller to avoid memory leaks
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children:[ Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              // settings option
              SlidableAction(
                onPressed: widget.settingsTapped,
                 backgroundColor: Colors.blueGrey.shade700,
                icon: Icons.edit,
                borderRadius: BorderRadius.circular(18),
              ),

              // delete option
              SlidableAction(
                onPressed: widget.deleteTapped,
                backgroundColor: Colors.red.shade400,
                icon: Icons.delete,
                borderRadius: BorderRadius.circular(18),
              ),
            ],
          ),
          child: Container(

            padding: EdgeInsets.only(top:6,bottom: 6,right: 10,left: 10),
            decoration: BoxDecoration(
              color: tileColor,
              borderRadius: BorderRadius.circular(18),
            ),
            child: Row(
              children: [
                // checkbox
                Checkbox(
                  value: widget.habitCompleted,
                  onChanged: (value){
                    widget.onChanged!(value);

                    setState(() {
                      tileColor=value?? false? Colors.tealAccent!:Colors.greenAccent[100]!;

                    });
                    if(value??false){
                      _confettiController.play();
                    }


                    //   Certainly! Let's break down the line tileColor = value ?? false ? Colors.grey[300]! : Colors.greenAccent[100]!; and understand its functionality:
                    //
                    //   value ?? false: This part uses the null-aware operator ?? to check if value is null. If value is not null, it is used as the condition for the ternary operator. If value is null, it is replaced with false as the fallback value.
                    //
                    //   ? Colors.grey[300]! : Colors.greenAccent[100]!: This is a ternary operator, which evaluates the condition preceding it (value ?? false). If the condition is true, it returns Colors.grey[300]!, which is a shade of grey color. If the condition is false, it returns Colors.greenAccent[100]!, which is a shade of green color.
                    //
                    //   tileColor = ...: This assigns the resulting color from the ternary operator to the tileColor variable.
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  ),
                ),

                // habit name
                Text(widget.habitName),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon
                      (Icons.arrow_left_sharp),
                  ),
                ),

              ],
            ),
          ),
        ),

          Positioned.fill(
            child: IgnorePointer(
              child: ConfettiWidget(
                confettiController: _confettiController,
                // Configure confetti properties, such as colors, direction, etc.
                // Example:
                blastDirection:-pi/2,

              ),
            ),
          ),

        ],

      ),

    );
  }
}
import 'package:flutter/material.dart';

class MyAlertBox extends StatelessWidget {
  final controller;
  final String hintText;
  final VoidCallback onSave;
  final VoidCallback onCancel;

  const MyAlertBox({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onSave,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
      ),
      backgroundColor: Colors.black.withOpacity(0.6),
      content: TextField(
        controller: controller,
        style: const TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder:
          const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(7)),
          ),

          focusedBorder:
          const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.greenAccent),
            borderRadius: const BorderRadius.all(Radius.circular(7)),

          ),

        ),
      ),
      actions: [
        MaterialButton(
            onPressed: onCancel,
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white),
            ),
            color: Colors.red.shade900,
            shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            )
        ),
        MaterialButton(
            onPressed: onSave,
            child: Text(
              "Save",
              style: TextStyle(color: Colors.black),
            ),
            color: Colors.greenAccent,

            shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)
            )
        ),
      ],
    );
  }
}
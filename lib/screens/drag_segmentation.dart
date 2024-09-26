import 'package:flutter/material.dart';

class DragSegmentation extends StatelessWidget {
  final String letter;

  DragSegmentation({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Draggable<String>(
      data: letter,
      feedback: Material(
        color: Colors.transparent,
        child: Text(
          letter,
          style: const TextStyle(
            fontFamily: 'PartyConfetti',
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
      ),
      childWhenDragging: Container(),
      child: Text(
        letter,
        style: const TextStyle(
          fontFamily: 'PartyConfetti',
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

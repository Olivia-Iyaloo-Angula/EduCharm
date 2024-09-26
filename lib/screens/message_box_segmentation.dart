import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';

class MessageBoxSegmentation extends StatefulWidget {
  final String message;
  final VoidCallback onContinue;

  MessageBoxSegmentation({required this.message, required this.onContinue});

  @override
  _MessageBoxSegmentationState createState() => _MessageBoxSegmentationState();
}

class _MessageBoxSegmentationState extends State<MessageBoxSegmentation> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AlertDialog(
          backgroundColor: const Color.fromARGB(
              166, 33, 149, 243), // Set background color to blue
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            // Add rounded corners
          ),
          title: Text(
            widget.message,
            style: TextStyle(
              fontFamily:
                  'PartyConfetti', // Set the font family to PartyConfetti
              color: Colors.white, // Set the text color to white
              fontSize: 24, // Increase the font size
              fontWeight: FontWeight.bold, // Make the text bold
            ),
            textAlign: TextAlign.center, // Center the text
          ),
          actions: <Widget>[
            Center(
              child: TextButton(
                onPressed: widget.onContinue,
                child: Text(
                  'Continue',
                  style: TextStyle(
                    fontFamily:
                        'PartyConfetti', // Set the font family to PartyConfetti
                    color: Colors.white, // Set the text color to white
                    fontSize: 20, // Increase the font size
                    fontWeight: FontWeight.bold, // Make the text bold
                  ),
                ),
                style: TextButton.styleFrom(
                  backgroundColor:
                      Colors.lightBlue, // Light blue button background
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                        10), // Rounded corners for the button
                  ),
                ),
              ),
            ),
          ],
        ),
        Align(
          alignment: Alignment.topCenter,
          child: ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            shouldLoop: false,
            colors: const [
              Colors.red,
              Colors.blue,
              Colors.green,
              Colors.yellow,
              Colors.pink,
              Colors.orange,
            ], // Different confetti colors
            numberOfParticles: 20, // Number of confetti particles
          ),
        ),
      ],
    );
  }
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class TapTheSoundScreen extends StatefulWidget {
  @override
  _TapTheSoundScreenState createState() => _TapTheSoundScreenState();
}

class _TapTheSoundScreenState extends State<TapTheSoundScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  Random random = Random();
  AudioPlayer audioPlayer = AudioPlayer();
  List<String> letters = [];
  String currentTarget = '';
  int targetCount = 0; // Track how many target bubbles are left
  int round = 0; // Track how many sets have been completed
  final int maxRounds = 6; // Set a maximum of 6 rounds

  final List<Map<String, dynamic>> bubbleSets = [
    {
      'letters': ['Ch', 'Ch', 'Ch', 'A', 'K', 'D', 'C', 'H'],
      'target': 'Ch'
    },
    {
      'letters': ['B', 'B', 'B', 'C', 'B', 'D', 'E', 'F'],
      'target': 'B'
    },
    {
      'letters': ['A', 'A', 'C', 'A', 'K', 'M', 'N', 'P'],
      'target': 'A'
    },
    {
      'letters': ['D', 'D', 'D', 'A', 'E', 'L', 'P', 'D'],
      'target': 'D'
    },
    {
      'letters': ['F', 'F', 'F', 'B', 'G', 'F', 'L', 'R'],
      'target': 'F'
    },
    {
      'letters': ['G', 'G', 'M', 'G', 'B', 'T', 'G', 'Z'],
      'target': 'G'
    },
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    loadNewSet();
  }

  @override
  void dispose() {
    _controller.dispose();
    audioPlayer.dispose();
    super.dispose();
  }

  // Play the given audio file
  void playAudio(String fileName) async {
    await audioPlayer.play(AssetSource(fileName));
  }

  // Load new set of bubbles
  void loadNewSet() {
    if (round < maxRounds) {
      setState(() {
        // Get the current set of letters and target
        letters = bubbleSets[round]['letters'];
        currentTarget = bubbleSets[round]['target'];

        // Play the instruction audio (e.g., "Tap on the Ch" or "Tap on the B")
        playAudio('tap_on_the_${currentTarget.toLowerCase()}.mp3');

        // Count initial target letters
        targetCount = letters.where((letter) => letter == currentTarget).length;
      });
    } else {
      // End of the game or handle when all sets are done
      print('Game Over. All rounds completed!');
      // You can navigate to a different screen or show a "Congratulations" message.
    }
  }

  // Function to generate random positions for the bubbles with letters
  Positioned _buildFloatingBubble(String letter, double left, double top) {
    return Positioned(
      left: left, // Fixed horizontal position
      top: top, // Fixed vertical position
      child: GestureDetector(
        onTap: () {
          if (letter == currentTarget) {
            playAudio(
                '${currentTarget.toLowerCase()}_sound.mp3'); // Play sound for tapped letter
            setState(() {
              letters.remove(letter); // Remove tapped target bubble
              targetCount--;
              // If no more target bubbles left, play "Well done" and load next set
              if (targetCount == 0) {
                playAudio('well_done.mp3');
                Future.delayed(Duration(seconds: 2), () {
                  round++;
                  loadNewSet(); // Load the next round's bubbles
                });
              }
            });
          }
          print('Bubble tapped: $letter');
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue.shade100, // Bubble color
          ),
          child: Center(
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontFamily: 'PartyConfetti', // Added PartyConfetti font
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> bubbles = [];

    // Generate random positions for bubbles and ensure they don't overlap
    for (var letter in letters) {
      double left;
      double top;
      bool overlap;
      do {
        overlap = false;
        left = random.nextDouble() *
            (MediaQuery.of(context).size.width -
                60); // Adjusted for bubble size
        top = random.nextDouble() *
            (MediaQuery.of(context).size.height -
                60); // Adjusted for bubble size

        // Check for overlap with existing bubbles
        for (var bubble in bubbles) {
          final Positioned positionedBubble = bubble as Positioned;
          final double existingLeft = positionedBubble.left!;
          final double existingTop = positionedBubble.top!;
          final double dx = (existingLeft - left).abs();
          final double dy = (existingTop - top).abs();
          final double distance = sqrt(dx * dx + dy * dy);
          if (distance < 60) {
            // Bubble size as threshold for overlap
            overlap = true;
            break;
          }
        }
      } while (overlap);

      bubbles.add(_buildFloatingBubble(letter, left, top));
    }

    return Scaffold(
      body: Stack(
        children: bubbles,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class ReadingScreen extends StatefulWidget {
  @override
  _ReadingScreenState createState() => _ReadingScreenState();
}

class _ReadingScreenState extends State<ReadingScreen> {
  List<String> words = [
    'Fox',
    'Lion',
    'Bee',
    'Cat',
    'Zebra',
    'Bag',
    'Gift',
    'Apple',
    'Pig',
    'Cow',
    'Ball',
    'Truck',
    'Eggs',
    'Kite',
    'Juice',
    'Tree',
    'Dress',
    'Hand',
    'Candy',
    'Corn',
    'Bird',
    'Milk'
  ]; // List of possible words

  Map<String, String> wordImageMap = {
    'Fox': 'assets/images/fox.png',
    'Lion': 'assets/images/lion.png',
    'Bee': 'assets/images/Bee.png',
    'Cat': 'assets/images/cat.png',
    'Zebra': 'assets/images/Zebra.png',
    'Bag': 'assets/images/Bag.png',
    'Gift': 'assets/images/Gift.png',
    'Apple': 'assets/images/Apple.png',
    'Pig': 'assets/images/pig.png',
    'Cow': 'assets/images/Cow.png',
    'Ball': 'assets/images/Ball.png',
    'Truck': 'assets/images/Truck.png',
    'Eggs': 'assets/images/Eggs.png',
    'Kite': 'assets/images/Kite.png',
    'Juice': 'assets/images/Juice.png',
    'Tree': 'assets/images/Tree.png',
    'Dress': 'assets/images/Dress.png',
    'Hand': 'assets/images/Hand.png',
    'Candy': 'assets/images/Candy.png',
    'Corn': 'assets/images/Corn.png',
    'Bird': 'assets/images/Bird.png',
    'Milk': 'assets/images/Milk.png'
  }; // Map of words to images

  List<String> displayedWords = []; // Words displayed on buttons
  String? correctWord; // The correct word matching the picture
  String? imagePath; // Path to the image
  bool showOnlyCorrect = false; // Whether to hide wrong words
  final AudioPlayer _audioPlayer = AudioPlayer(); // Audio player instance
  int currentSession = 0; // Track the current session number
  static const int totalSessions = 10; // Number of sessions

  Map<String, Color> buttonColors = {}; // Track the button colors
  Color defaultColor = Colors.blue.shade200; // Faded blue color for buttons

  @override
  void initState() {
    super.initState();
    _generateRandomWords(); // Generate random words for the buttons
    _playInstructionAudio(); // Play the instruction audio at the start
    _initializeButtonColors(); // Initialize button colors
  }

  // Function to initialize the button colors
  void _initializeButtonColors() {
    displayedWords.forEach((word) {
      buttonColors[word] = defaultColor; // Set each word to default color
    });
  }

  // Function to generate 3 random words and pick the correct one
  void _generateRandomWords() {
    Random random = Random();
    displayedWords = words..shuffle(); // Shuffle the words
    displayedWords = displayedWords.take(3).toList(); // Take first 3 words
    correctWord = displayedWords[random.nextInt(3)]; // Pick a correct word
    imagePath =
        wordImageMap[correctWord]; // Get the image path for the correct word
  }

  // Function to play the instruction audio
  void _playInstructionAudio() async {
    await _audioPlayer.play(AssetSource('audio/Read_the_words_and_tap.mp3'));
  }

  // Function to play the "Correct" audio
  Future<void> _playCorrectAudio() async {
    await _audioPlayer.play(AssetSource('audio/Correct_1.mp3'));
  }

  // Function to play the "Well done" audio
  Future<void> _playWellDoneAudio() async {
    await _audioPlayer.play(AssetSource('audio/Well_done.mp3'));
  }

  // Function to play the "Wrong" audio
  Future<void> _playWrongAudio() async {
    await _audioPlayer.play(AssetSource('audio/wrong.mp3'));
  }

  // Function to handle word tap
  void _onWordTap(String word) async {
    if (word == correctWord) {
      // Set the button color to green (for correct) and play audio
      setState(() {
        buttonColors[word] = Colors.green;
      });
      await _playCorrectAudio(); // Play the "Correct" audio
      setState(() {
        showOnlyCorrect = true; // Show only the correct word
      });
      await Future.delayed(
          Duration(milliseconds: 300)); // Short delay for "glitch" effect
      setState(() {
        buttonColors[word] = defaultColor; // Reset color after the effect
      });
      await Future.delayed(Duration(seconds: 1)); // Short delay for effect
      await _playWellDoneAudio(); // Play the "Well done" audio
      _nextSession(); // Proceed to the next session
    } else {
      // Set the button color to red (for incorrect) and play audio
      setState(() {
        buttonColors[word] = Colors.red;
      });
      await _playWrongAudio(); // Play the "Wrong" audio if incorrect
      await Future.delayed(
          Duration(milliseconds: 300)); // Short delay for "glitch" effect
      setState(() {
        buttonColors[word] = defaultColor; // Reset color after the effect
      });
    }
  }

  // Function to move to the next session or finish
  void _nextSession() async {
    if (currentSession < totalSessions - 1) {
      setState(() {
        currentSession++;
        showOnlyCorrect = false; // Reset the visibility
        _generateRandomWords(); // Generate new random words
        _initializeButtonColors(); // Reset button colors
      });
      await Future.delayed(Duration(seconds: 1)); // Short delay
      _playInstructionAudio(); // Play instruction audio before next session
    } else {
      // Handle the end of all sessions
      _showCompletionMessage(); // Show completion message after 10 sessions
    }
  }

  // Function to display a completion message after all sessions
  void _showCompletionMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Congratulations!'),
          content: Text('You have completed all the sessions.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // Ensure everything is centered
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Display the image
              if (imagePath != null)
                Image.asset(
                  imagePath!,
                  height: 150,
                  width: 150,
                ),
              SizedBox(height: 30),
              // Display the 3 word buttons in the center of the screen
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: displayedWords.map((word) {
                  if (!showOnlyCorrect || word == correctWord) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AnimatedContainer(
                        duration: Duration(
                            milliseconds:
                                300), // Animation duration for "glitch" effect
                        color: buttonColors[word], // Button color
                        child: ElevatedButton(
                          onPressed: () => _onWordTap(word),
                          child: Text(
                            word,
                            style: TextStyle(
                              fontSize: 24,
                              fontFamily:
                                  'PartyConfetti', // Use the custom font
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 40),
                            backgroundColor: Colors
                                .transparent, // Transparent background, as container controls the color
                            shadowColor: Colors
                                .transparent, // No shadow for a flat design
                            shape: RoundedRectangleBorder(
                              // Add border radius for rounded corners
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Container(); // Hide the incorrect words if tapped
                  }
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose the audio player when screen is closed
    super.dispose();
  }
}

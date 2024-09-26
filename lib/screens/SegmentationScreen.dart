import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controller_segmentation.dart';
import 'drag_segmentation.dart';
import 'message_box_segmentation.dart';
import 'allWords_segmentation.dart';

class SegmentationScreen extends StatefulWidget {
  @override
  _SegmentationScreenState createState() => _SegmentationScreenState();
}

class _SegmentationScreenState extends State<SegmentationScreen> {
  List<String> _words =
      List.from(allWordsSegmentation); // Word list for segmentation
  late String _word, _dropWord;
  late int _gapIndex;
  late String _missingLetter; // Store the missing letter
  late List<String> _draggableLetters; // List to store all draggable letters
  bool _isLetterPlaced = false; // Track if the letter is placed

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  void _initializeScreen() {
    if (_words.isEmpty) {
      _showReplayMessage(); // Show replay message if no words left
    } else {
      _generateWord();
    }
  }

  void _generateWord() {
    if (_words.isNotEmpty) {
      final r = Random().nextInt(_words.length);
      _word = _words[r];
      _dropWord = _word;
      _gapIndex = Random().nextInt(_word.length);
      _missingLetter = _word[_gapIndex]; // Assign the missing letter
      _isLetterPlaced = false; // Reset the placed letter flag

      // Prepare the draggable letters
      _draggableLetters = _generateDraggableLetters();

      // Notify the controller after the screen is fully rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<ControllerSegmentation>(context, listen: false)
            .setUp(total: _word.length);
        Provider.of<ControllerSegmentation>(context, listen: false)
            .requestWord(request: false);
      });
    }
  }

  // Function to generate random draggable letters including the correct one
  List<String> _generateDraggableLetters() {
    List<String> letters = [_missingLetter];
    final alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.characters.toList();
    alphabet.remove(_missingLetter.toUpperCase());

    while (letters.length < 3) {
      final randomLetter = alphabet[Random().nextInt(alphabet.length)];
      if (!letters.contains(randomLetter)) {
        letters.add(randomLetter);
      }
    }

    letters.shuffle(); // Shuffle to randomize the order
    return letters;
  }

  void _onCorrect() {
    // Remove the used word from the list
    _words.remove(_word);

    if (_words.isEmpty) {
      _showReplayMessage(); // Show replay message when all words are done
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return MessageBoxSegmentation(
            message: 'Correct!',
            onContinue: () {
              Navigator.of(context).pop();
              setState(() {
                _initializeScreen(); // Load a new word
              });
            },
          );
        },
      );
    }
  }

  void _showReplayMessage() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'All Words Completed',
            style: TextStyle(
              fontFamily: 'PartyConfetti',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'Would you like to replay the game?',
            style: TextStyle(
              fontFamily: 'PartyConfetti',
              fontSize: 16,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'Yes',
                style: TextStyle(
                  fontFamily: 'PartyConfetti',
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _words =
                      List.from(allWordsSegmentation); // Reset the word list
                  _initializeScreen(); // Start a new game
                });
              },
            ),
            TextButton(
              child: Text(
                'No',
                style: TextStyle(
                  fontFamily: 'PartyConfetti',
                  fontSize: 16,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                // Optionally, navigate back or close the app
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segmentation'),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Display the image
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 255, 255, 255)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Image.asset(
                  'assets/images/$_dropWord.jpeg',
                  errorBuilder: (context, error, stackTrace) {
                    return const Text('Image not found');
                  },
                ),
              ),
              const SizedBox(height: 20),
              // Display the word with the missing letter(s) in bubble-like boxes
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _dropWord.characters
                    .toList()
                    .asMap()
                    .map((index, e) {
                      return MapEntry(
                        index,
                        index == _gapIndex && !_isLetterPlaced
                            ? DragTarget<String>(
                                builder:
                                    (context, candidateData, rejectedData) {
                                  return Container(
                                    width: 50,
                                    height: 50,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.blue.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.blue.shade300,
                                          offset: const Offset(2, 2),
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    alignment: Alignment.center,
                                    child: const Text(
                                      '_',
                                      style: TextStyle(
                                        fontFamily: 'PartyConfetti',
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                  );
                                },
                                onWillAccept: (receivedLetter) {
                                  // Only accept if the dragged letter is correct
                                  return receivedLetter == _missingLetter;
                                },
                                onAccept: (receivedLetter) {
                                  setState(() {
                                    _dropWord = _dropWord.replaceRange(
                                        index, index + 1, receivedLetter);
                                    _draggableLetters.remove(
                                        receivedLetter); // Remove the letter from draggable list
                                    _isLetterPlaced =
                                        true; // Mark letter as placed
                                  });
                                  _onCorrect(); // Display the correct message box
                                },
                              )
                            : Container(
                                width: 50,
                                height: 50,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.shade300,
                                      offset: const Offset(2, 2),
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                alignment: Alignment.center,
                                child: Text(
                                  e,
                                  style: const TextStyle(
                                    fontFamily: 'PartyConfetti',
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 255, 255, 255),
                                  ),
                                ),
                              ),
                      );
                    })
                    .values
                    .toList(),
              ),
              const SizedBox(
                  height: 40), // Added space between word and draggable letters
              // Display draggable letters in bubble-like buttons with spacing
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _draggableLetters
                    .map((letter) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.blue.shade300,
                                  offset: const Offset(2, 2),
                                  blurRadius: 5,
                                ),
                              ],
                            ),
                            child: DragSegmentation(letter: letter),
                          ),
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

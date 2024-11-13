import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart'; // Import the audio player package

void main() {
  runApp(const MaterialApp(
    home: WordFamiliesScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class WordFamiliesScreen extends StatefulWidget {
  const WordFamiliesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _WordFamiliesScreenState createState() => _WordFamiliesScreenState();
}

class _WordFamiliesScreenState extends State<WordFamiliesScreen> {
  // Map of word families with associated words
  final Map<String, List<String>> wordFamilies = {
    'at': ['cat', 'bat', 'hat'],
    'an': ['fan', 'man', 'can'],
  };

  // To keep track of what words have been dropped in which family
  Map<String, List<String>> selectedFamilies = {};

  // Audio player instance
  final AudioPlayer _audioPlayer = AudioPlayer();

  // Function to play correct sound
  void _playCorrectSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/Correct_2.mp3'));
    } catch (e) {
      print('Error playing correct sound: $e');
    }
  }

  // Function to play wrong sound
  void _playWrongSound() async {
    try {
      await _audioPlayer.play(AssetSource('audio/wrong.mp3'));
    } catch (e) {
      print('Error playing wrong sound: $e');
    }
  }

  // Function to check if the word belongs to the correct family
  bool _isCorrectWord(String family, String word) {
    return wordFamilies[family]!.contains(word);
  }

  // Function to handle the word being dropped in the family
  void _onWordDropped(String family, String word) {
    setState(() {
      // If the word is correct, play the correct sound and add it to the family
      if (_isCorrectWord(family, word)) {
        _playCorrectSound();
        if (selectedFamilies[family] == null) {
          selectedFamilies[family] = [];
        }
        selectedFamilies[family]!.add(word);
      } else {
        // If the word is wrong, play the wrong sound
        _playWrongSound();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Word Families Fun!',
          style: TextStyle(
            fontFamily: 'PartyConfetti', // Use PartyConfetti font
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        // Make the screen scrollable
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Word Families Drag Targets (Wrapped to 2 per row for a cleaner look)
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: wordFamilies.keys.map((family) {
                  return DragTarget<String>(
                    onAccept: (word) {
                      _onWordDropped(family, word);
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.pinkAccent,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Center(
                          child: Text(
                            family.toUpperCase(),
                            style: TextStyle(
                              fontFamily:
                                  'PartyConfetti', // Use PartyConfetti font
                              fontSize: 22,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
              SizedBox(height: 30),

              // Draggable Words
              GridView.builder(
                shrinkWrap:
                    true, // Ensures the GridView doesn't take up more space than needed
                physics:
                    NeverScrollableScrollPhysics(), // Disable GridView scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 1.5,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 15,
                ),
                itemCount: wordFamilies.values.expand((x) => x).length,
                itemBuilder: (context, index) {
                  String word =
                      wordFamilies.values.expand((x) => x).toList()[index];
                  return Draggable<String>(
                    data: word,
                    childWhenDragging: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    feedback: Material(
                      color: Colors.transparent,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.orangeAccent,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(
                            word,
                            style: TextStyle(
                                fontFamily:
                                    'PartyConfetti', // Use PartyConfetti font
                                color: Colors.white,
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.orange,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          word,
                          style: TextStyle(
                            fontFamily:
                                'PartyConfetti', // Use PartyConfetti font
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),

              // Display selected words per family
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: selectedFamilies.keys.map((family) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$family Family:',
                          style: TextStyle(
                            fontFamily:
                                'PartyConfetti', // Use PartyConfetti font
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.pinkAccent,
                          ),
                        ),
                        ...selectedFamilies[family]!.map((word) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              word,
                              style: TextStyle(
                                fontFamily:
                                    'PartyConfetti', // Use PartyConfetti font
                                fontSize: 18,
                                color: Colors.black,
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'AlphabetScreen.dart';

class AlphabetSoundsScreen extends StatelessWidget {
  final Map<String, String> _fileExtensions = {
    'N': 'png',
    'O': 'png',
    'R': 'png',
    // Add more mappings if you have other PNG files
  };

  final Map<String, String> _alphabetWords = {
    'A': 'Apple',
    'B': 'Ball',
    'C': 'Cat',
    'D': 'Doughnut',
    'E': 'Elephant',
    'F': 'Fish',
    'G': 'Grapes',
    'H': 'Hand',
    'I': 'Ice-Cream',
    'J': 'Jacket',
    'K': 'Kite',
    'L': 'Lemon',
    'M': 'Monkey',
    'N': 'Noodles',
    'O': 'Octupus',
    'P': 'Pig',
    'Q': 'Queen',
    'R': 'Rainbow',
    'S': 'Stars',
    'T': 'Truck',
    'U': 'Umbrella',
    'V': 'Violin',
    'W': 'Whale',
    'X': 'X-Ray',
    'Y': 'Yoghurt',
    'Z': 'Zebra',
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alphabet Sounds'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4, // Number of buttons per row
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemCount: 26,
          itemBuilder: (context, index) {
            return _buildAlphabetButton(
                context, String.fromCharCode(65 + index));
          },
        ),
      ),
    );
  }

  String _getFileExtension(String letter) {
    return _fileExtensions[letter] ?? 'jpg';
  }

  Widget _buildAlphabetButton(BuildContext context, String letter) {
    String fileExtension = _getFileExtension(letter);
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Colors.white.withOpacity(0.5), // Semi-transparent white
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.all(8.0), // Adjust padding for button size
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlphabetScreen(
              letter: letter,
              word: _alphabetWords[letter] ?? 'Unknown',
            ),
          ),
        );
      },
      child: Image.asset(
        'assets/$letter.$fileExtension', // Path to the letter image
        fit: BoxFit.contain, // Ensure the image fits within the bounds
        height: 60, // Adjust the height as needed
        width: 60, // Adjust the width as needed
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: AlphabetSoundsScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

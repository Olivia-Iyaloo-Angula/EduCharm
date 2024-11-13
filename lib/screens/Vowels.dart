import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:educharm/screens/music_player_screen.dart';

class VowelsScreen extends StatelessWidget {
  const VowelsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vowels'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                _buildVowelButton(context, 'A'),
                _buildVowelButton(context, 'E'),
                _buildVowelButton(context, 'I'),
                _buildVowelButton(context, 'O'),
                _buildVowelButton(context, 'U', centered: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildPolarBearButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildVowelButton(BuildContext context, String vowel,
      {bool centered = false}) {
    final AudioPlayer _audioPlayer = AudioPlayer();

    Widget button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blueAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.zero,
      ),
      onPressed: () async {
        // Play the corresponding vowel sound
        await _audioPlayer.play(AssetSource('audio/$vowel.wav'));
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Image.asset(
          'assets/vowels/$vowel.jpg', // Path to the vowel image
          fit: BoxFit.cover, // Ensure the image covers the button
          height: 136, // Increased height to make the image bigger
        ),
      ),
    );

    Widget column = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        button,
        const SizedBox(height: 8.0), // Space between button and text
        Text(
          'Vowel $vowel',
          style: const TextStyle(
            fontSize: 18.0, // Increased font size
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ],
    );

    if (centered) {
      column = Center(child: column);
    }

    return Container(
      margin: const EdgeInsets.all(10.0),
      child: column,
    );
  }

  Widget _buildPolarBearButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MusicPlayerScreen(
              audioPath:
                  'audio/Vowel_Song.mp3', // Replace with the correct sound
            ),
          ),
        );
      },
      child: AnimatedContainer(
        duration: const Duration(seconds: 1),
        child: Image.asset(
          'assets/images/cute-polar-bear.jpg', // Path to your polar bear image
          height: 100,
          width: 150,
        ),
      ),
    );
  }
}

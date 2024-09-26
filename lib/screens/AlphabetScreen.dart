import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AlphabetScreen extends StatefulWidget {
  final String letter;
  final String word;

  AlphabetScreen({
    required this.letter,
    required this.word,
  });

  @override
  _AlphabetScreenState createState() => _AlphabetScreenState();
}

class _AlphabetScreenState extends State<AlphabetScreen> {
  final AudioPlayer _audioPlayer = AudioPlayer();

  final Map<String, String> _gifPaths = {
    'A': 'assets/gifs/A.gif',
    'B': 'assets/gifs/B.gif',
    'C': 'assets/gifs/C.gif',
    'D': 'assets/gifs/D.gif',
    'E': 'assets/gifs/E.gif',
    'F': 'assets/gifs/F.gif',
    'G': 'assets/gifs/G.gif',
    'H': 'assets/gifs/H.gif',
    'I': 'assets/gifs/I.gif',
    'J': 'assets/gifs/J.gif',
    'K': 'assets/gifs/K.gif',
    'L': 'assets/gifs/L.gif',
    'M': 'assets/gifs/M.gif',
    'N': 'assets/gifs/N.gif',
    'O': 'assets/gifs/O.gif',
    'P': 'assets/gifs/P.gif',
    'Q': 'assets/gifs/Q.gif',
    'R': 'assets/gifs/R.gif',
    'S': 'assets/gifs/S.gif',
    'T': 'assets/gifs/T.gif',
    'U': 'assets/gifs/U.gif',
    'V': 'assets/gifs/V.gif',
    'W': 'assets/gifs/W.gif',
    'X': 'assets/gifs/X.gif',
    'Y': 'assets/gifs/Y.gif',
    'Z': 'assets/gifs/Z.gif',
  };

  void _playLetterSound() async {
    await _audioPlayer.play(AssetSource('audio/${widget.letter}.wav'));
  }

  void _playWordSound() async {
    await _audioPlayer.play(AssetSource('audio/${widget.letter}.mp3'));
  }

  String _buildLetterText(String letter) {
    return letter + letter.toLowerCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Letter ${widget.letter}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 6,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _playLetterSound,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        _gifPaths[widget.letter]!,
                        height: 150,
                        width: 150,
                      ),
                      SizedBox(height: 8.0),
                      Text(
                        _buildLetterText(widget.letter),
                        style: TextStyle(
                          fontSize: 60.0,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              flex: 4,
              child: Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: _playWordSound,
                  child: Text(
                    '${widget.letter} is for ${widget.word}',
                    style: TextStyle(
                      fontSize: 45.0,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

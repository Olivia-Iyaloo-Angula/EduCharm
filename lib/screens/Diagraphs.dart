import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class DiagraphsScreen extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Diagraphs'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'A diagraph is when two letters come together to create a unique sound.',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2, // Number of columns
              padding: EdgeInsets.all(16.0),
              children: [
                _buildDiagraphButton(context, 'oo', 'OO'),
                _buildDiagraphButton(context, 'ee', 'EE'),
                _buildDiagraphButton(context, 'ou', 'OU'),
                _buildDiagraphButton(context, 'ea', 'EA'),
                _buildDiagraphButton(context, 'ie', 'IE'),
                _buildDiagraphButton(context, 'ea', 'EA'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagraphButton(
      BuildContext context, String diagraph, String displayText) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(24.0),
        backgroundColor: Colors.blueAccent,
      ),
      onPressed: () {
        // Navigate to the sound buttons screen
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DiagraphDetailScreen(diagraph: diagraph)),
        );
      },
      child: Text(
        displayText,
        style: TextStyle(
          fontSize: 24.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class DiagraphDetailScreen extends StatelessWidget {
  final String diagraph;
  final AudioPlayer _audioPlayer = AudioPlayer();

  DiagraphDetailScreen({required this.diagraph});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$diagraph Diagraph'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // First Container - Circular buttons with sounds for specific letters
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'Sound out these letters:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Wrap(
                    spacing: 10.0,
                    runSpacing: 10.0,
                    children: ['l', 'm', 'p', 'j', 'e', 'h']
                        .map((letter) => ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: CircleBorder(),
                                padding: EdgeInsets.all(24.0),
                                backgroundColor: Colors.blueAccent,
                              ),
                              onPressed: () async {
                                await _playLetterSound(letter);
                              },
                              child: Text(
                                letter.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 24.0,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

            // Second Container - Story with diagraph
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Story with the diagraph:',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Once upon a time, there was a little tree by the sea. The tree had three bright green leaves and a bee that loved to fly around it.',
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),

            // Third Container - Placeholder for Action (for future)
            Container(
              margin: EdgeInsets.all(16.0),
              padding: EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text(
                    'Action Section',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text('This section can include interactive actions later.'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to play sound for a letter
  Future<void> _playLetterSound(String letter) async {
    String fileName = '$letter.mp3';
    await _audioPlayer.play(AssetSource('audio/$fileName'));
  }
}

void main() {
  runApp(MaterialApp(
    home: DiagraphsScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

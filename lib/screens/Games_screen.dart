import 'package:flutter/material.dart';
import 'package:educharm/screens/Settings.dart' as settings;
import 'package:educharm/screens/LetterTracingScreen.dart' as tracing;
import 'package:educharm/screens/TapTheSoundScreen.dart' as tapTheSound;
import 'package:educharm/screens/IsSoundInWordScreen.dart' as isSoundInWord;
import 'package:educharm/screens/SegmentationScreen.dart' as segmentation;
import 'package:educharm/screens/ReadingScreen.dart' as reading;

void main() {
  runApp(MaterialApp(
    home: GamesScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class GamesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Games Screen',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => settings.SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildGameButton(
                      context,
                      'Word Tracing',
                      'assets/letter tracing.webp',
                      tracing.LetterARViewScreen()),
                  _buildGameButton(
                      context,
                      'Tap the Sound',
                      'assets/710e743npjL.png',
                      tapTheSound.TapTheSoundScreen()),
                  _buildGameButton(
                      context,
                      'Is Sound in Word?',
                      'assets/free-printable-flashcards-with-pictures.jpg',
                      isSoundInWord.IsSoundInWordScreen()),
                  _buildGameButton(context, 'Segmentation',
                      'assets/IMG_3202.jpg', segmentation.SegmentationScreen()),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            _buildCenterButton(context, 'Reading', 'assets/ABC Words.png',
                reading.ReadingScreen()),
          ],
        ),
      ),
    );
  }

  Widget _buildGameButton(
      BuildContext context, String title, String imagePath, Widget? screen) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 80.0, horizontal: 100.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              if (screen != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                );
              }
            },
            child: null,
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              border: Border.all(color: Colors.lightBlue, width: 2.0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCenterButton(
      BuildContext context, String title, String imagePath, Widget? screen) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              padding: EdgeInsets.symmetric(vertical: 100.0, horizontal: 100.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () {
              if (screen != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => screen),
                );
              }
            },
            child: null,
          ),
        ),
        Positioned(
          bottom: 10,
          left: 10,
          right: 10,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.7),
              border: Border.all(color: Colors.lightBlue, width: 2.0),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

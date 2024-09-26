import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class MusicPlayerScreen extends StatefulWidget {
  final String audioPath;

  const MusicPlayerScreen({Key? key, required this.audioPath})
      : super(key: key);

  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState();
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen>
    with TickerProviderStateMixin {
  late AudioPlayer _audioPlayer;
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _animations;
  final List<String> _letters = ['A', 'E', 'I', 'O', 'U'];
  final Random _random = Random();
  final List<Color> _colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple
  ];

  bool isPlaying = false;

  @override
  void initState() {
    super.initState();

    _audioPlayer = AudioPlayer();

    // Initialize controllers and animations for 50 letters (10 of each A, E, I, O, U)
    _controllers = List.generate(
      _letters.length * 10, // 10 instances for each letter
      (index) => AnimationController(
        vsync: this,
        duration: Duration(seconds: 3 + _random.nextInt(3)),
      ),
    );

    _animations = _controllers.map((controller) {
      return Tween<Offset>(
        begin: Offset(
          _random.nextDouble() * 2 - 1, // Start from a random X position
          _random.nextDouble() * 2 - 1, // Start from a random Y position
        ),
        end: Offset(
          _random.nextDouble() * 2 - 1, // End at a random X position
          _random.nextDouble() * 2 - 1, // End at a random Y position
        ),
      ).animate(CurvedAnimation(parent: controller, curve: Curves.bounceInOut));
    }).toList();

    // Start the animations
    _controllers.forEach((controller) => controller.repeat(reverse: true));

    // Play the audio automatically when screen loads
    _playAudio();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _controllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _playAudio() async {
    await _audioPlayer.play(AssetSource(widget.audioPath));
    setState(() {
      isPlaying = true;
    });
  }

  void _pauseAudio() async {
    await _audioPlayer.pause();
    setState(() {
      isPlaying = false;
    });
  }

  void _resumeAudio() async {
    await _audioPlayer.resume();
    setState(() {
      isPlaying = true;
    });
  }

  void _restartAudio() async {
    await _audioPlayer.stop();
    await _audioPlayer.play(AssetSource(widget.audioPath));
    setState(() {
      isPlaying = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 83, 187, 222),
        title: Text("Vowel Song Player"),
      ),
      body: Stack(
        children: [
          // Set faded background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/images/CloudsWallpaper.jpg'), // Use your image path
                fit: BoxFit.cover, // Ensures the image covers the entire screen
                colorFilter: ColorFilter.mode(
                  Colors.white
                      .withOpacity(0.3), // Adjust opacity for fading effect
                  BlendMode.dstATop, // Blend mode for fading
                ),
              ),
            ),
          ),
          // Create bouncing letters (10 of each letter in different colors)
          for (int i = 0; i < _letters.length * 10; i++)
            AnimatedBuilder(
              animation: _animations[i],
              builder: (context, child) {
                return Transform.translate(
                  offset: _animations[i].value *
                      MediaQuery.of(context).size.width /
                      2,
                  child: child,
                );
              },
              child: Center(
                child: Text(
                  _letters[i %
                      _letters
                          .length], // Use modulo to cycle through A, E, I, O, U
                  style: TextStyle(
                    fontFamily: 'PartyConfetti', // Use the PartyConfetti font
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color:
                        _colors[i % _colors.length], // Cycle through the colors
                  ),
                ),
              ),
            ),
          // Music controls
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 83, 187, 222),
                    ),
                    icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
                    label: Text(isPlaying ? 'Pause' : 'Play'),
                    onPressed: () {
                      if (isPlaying) {
                        _pauseAudio();
                      } else {
                        _resumeAudio();
                      }
                    },
                  ),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 83, 187, 222),
                    ),
                    icon: Icon(Icons.restart_alt),
                    label: Text('Restart'),
                    onPressed: _restartAudio,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:animated_background/animated_background.dart';
import 'package:audioplayers/audioplayers.dart';

class IsSoundInWordScreen extends StatefulWidget {
  @override
  _IsSoundInWordScreenState createState() => _IsSoundInWordScreenState();
}

class _IsSoundInWordScreenState extends State<IsSoundInWordScreen>
    with SingleTickerProviderStateMixin {
  int currentImageIndex = -1; // Track the current image index
  bool showResultButtons = false; // Track whether to show result buttons
  bool isCorrectTapped = false; // Track if the correct answer was tapped
  List<String> imagePaths = [
    'assets/images/Tree.png',
    'assets/images/Ball.png',
    'assets/images/Eggs.png'
  ]; // Images to show
  List<String> audioPaths = [
    'audio/Tree.mp3',
    'audio/Ball.mp3',
    'audio/Eggs.mp3'
  ]; // Audio files to play corresponding to images

  final AudioPlayer _audioPlayer = AudioPlayer(); // AudioPlayer instance
  bool isTreeSoundPlayed =
      false; // To prevent the tree sound from playing repeatedly

  @override
  void initState() {
    super.initState();
    // Start the image display process
    _startImageDisplay();
  }

  // Function to play audio and then start displaying images
  void _startImageDisplay() async {
    await _playIntroAudio(); // Play introduction audio before showing images
    _showImagesWithDelay(); // Start showing images
  }

  // Function to play the introduction audio
  Future<void> _playIntroAudio() async {
    await _audioPlayer.play(AssetSource('audio/listen_for_ee_in_this.mp3'));
    await Future.delayed(
        Duration(seconds: 3)); // Wait for the duration of the audio
  }

  // Function to delay image appearance every 3 seconds and play corresponding audio
  void _showImagesWithDelay() async {
    for (int i = 0; i < imagePaths.length; i++) {
      await Future.delayed(Duration(seconds: 3)); // Wait for 3 seconds
      setState(() {
        currentImageIndex = i; // Update image index to show next image
      });
      await _playImageAudio(i); // Play the audio corresponding to the image
    }
  }

  // Function to play audio corresponding to the current image
  Future<void> _playImageAudio(int index) async {
    await _audioPlayer
        .play(AssetSource(audioPaths[index])); // Play the corresponding audio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Is Sound in Word?'),
      ),
      body: Stack(
        children: [
          // Animated Background
          AnimatedBackground(
            behaviour: RandomParticleBehaviour(
              options: ParticleOptions(
                spawnMaxRadius: 50, // Max radius of particles
                spawnMinSpeed: 15, // Min speed of particles
                particleCount: 70, // Number of particles
                spawnMaxSpeed: 40, // Max speed of particles
                baseColor: Colors.blueAccent.withOpacity(0.3), // Particle color
              ),
            ),
            vsync: this,
            child: Container(),
          ),

          // Centered content to display images one by one or result buttons
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (!showResultButtons) ...[
                  // Display images when not showing the result buttons
                  if (currentImageIndex >= 0) _buildImageButton(0),
                  if (currentImageIndex >= 1) _buildImageButton(1),
                  if (currentImageIndex >= 2) _buildImageButton(2),
                ] else ...[
                  // Show the tapped tree image with two result buttons
                  _buildTappedImage(),
                  SizedBox(height: 20),
                  _buildResultButtons(),
                  // Play tree sound when tree image is tapped
                  if (!isTreeSoundPlayed) _playTreeSound(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Function to build a button with an image and animation
  Widget _buildImageButton(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: AnimatedScale(
        scale: currentImageIndex >= index ? 1.1 : 1.0,
        duration: Duration(milliseconds: 500),
        curve: Curves.elasticOut,
        child: GestureDetector(
          onTap: () {
            _onImageTap(index);
          },
          child: Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: const Color.fromARGB(209, 0, 166, 255),
              border: Border.all(color: Colors.grey, width: 2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              imagePaths[index],
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  // Function to handle image tap
  void _onImageTap(int index) {
    if (index == 0) {
      // Assuming 'Tree.png' is the correct image
      setState(() {
        isCorrectTapped = true;
        showResultButtons = true;
        isTreeSoundPlayed = false; // Reset sound flag to ensure it plays
      });
      _audioPlayer.play(AssetSource('audio/listen_for_ee_in_this.mp3'));
    } else {
      setState(() {
        isCorrectTapped = false;
        showResultButtons = true;
        isTreeSoundPlayed = true; // Don't play the sound for wrong taps
      });
    }
  }

  // Function to build the tapped tree image
  Widget _buildTappedImage() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: const Color.fromARGB(209, 0, 166, 255),
        border: Border.all(color: Colors.grey, width: 2),
        borderRadius: BorderRadius.circular(20),
        boxShadow: isCorrectTapped
            ? [BoxShadow(color: Colors.green, blurRadius: 10)]
            : null, // Show green shadow for correct tap
      ),
      child: Image.asset(
        'assets/images/Tree.png', // Keep the Tree image visible
        fit: BoxFit.cover,
      ),
    );
  }

  // Function to build the result buttons (checkmark and cross)
  Widget _buildResultButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Correct button with checkmark
        GestureDetector(
          onTap: () {
            _handleCorrectTap();
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.check, size: 50, color: Colors.white),
          ),
        ),
        SizedBox(width: 30),
        // Wrong button with cross
        GestureDetector(
          onTap: () {
            _handleWrongTap();
          },
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.close, size: 50, color: Colors.white),
          ),
        ),
      ],
    );
  }

  // Function to handle the correct button tap
  void _handleCorrectTap() async {
    await _audioPlayer.play(AssetSource('audio/Well_done.mp3'));
    await Future.delayed(Duration(seconds: 2)); // Wait for the audio to finish
    setState(() {
      showResultButtons = false; // Hide result buttons
      currentImageIndex = -1; // Reset image index to load new images
    });
    _startImageDisplay(); // Start the new set of images
  }

  // Function to handle the wrong button tap
  void _handleWrongTap() {
    setState(() {
      showResultButtons = false; // Hide result buttons
    });
  }

  // Function to play the tree sound
  Widget _playTreeSound() {
    // Use Future.microtask to avoid playing multiple sounds due to state rebuild
    Future.microtask(() async {
      if (!isTreeSoundPlayed) {
        await _audioPlayer.play(AssetSource('audio/Tree.mp3'));
        setState(() {
          isTreeSoundPlayed = true; // Mark the sound as played
        });
      }
    });
    return Container(); // Return an empty container as this is for side-effect
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Dispose of the audio player
    super.dispose();
  }
}

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart'; // Import the video_player package

class DiagraphsScreen extends StatelessWidget {
  final AudioPlayer _audioPlayer = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Diagraphs',
          style: TextStyle(
            fontFamily: 'PartyConfetti',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'A diagraph is when two letters come together to create a unique sound.',
              style: TextStyle(
                fontSize: 18.0,
                fontFamily: 'PartyConfetti',
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
                _buildDiagraphButton(context, 'oo', 'OO', 'assets/OO.jpg'),
                _buildDiagraphButton(
                    context, 'ee', 'EE', 'assets/EE-Words-.jpg'),
                _buildDiagraphButton(context, 'ou', 'OU', 'assets/OU.jpg'),
                _buildDiagraphButton(context, 'ch', 'CH', 'assets/ch.jpg'),
                _buildDiagraphButton(context, 'ie', 'IE', 'assets/IE.jpg'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDiagraphButton(BuildContext context, String diagraph,
      String displayText, String imagePath) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: CircleBorder(),
        padding: EdgeInsets.all(24.0),
        backgroundColor: Colors.blueAccent.withOpacity(0.2),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DiagraphDetailScreen(
                  diagraph: diagraph, imagePath: imagePath)),
        );
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: ClipOval(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                height: 100,
                width: 100,
              ),
            ),
          ),
          SizedBox(height: 10),
          Text(
            displayText,
            style: TextStyle(
              fontSize: 24.0,
              fontFamily: 'PartyConfetti',
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class DiagraphDetailScreen extends StatelessWidget {
  final String diagraph;
  final String imagePath;
  final AudioPlayer _audioPlayer = AudioPlayer();

  final Map<String, List<String>> lettersByDiagraph = {
    'oo': ['l', 'm', 'p', 'j', 'e', 'h'],
    'ee': ['b', 'n', 's', 'v', 'k', 'r'],
    'ou': ['f', 'g', 't', 'd', 'c', 'w'],
    'ch': ['a', 'q', 'z', 'x', 'y', 'i'],
    'ie': ['u', 'o', 'v', 'n', 's', 'k'],
  };

  final Map<String, String> diagraphStories = {
    'oo':
        'One night, the moon was shining bright in the sky, but he felt a little lonely. Down below, in a small kitchen, there was a spoon who loved to look up at the stars. The spoon wished he could fly up to the moon and be his friend. Suddenly, with a whoosh, a magic breeze carried the spoon up into the sky. The moon smiled and said, "I’m so happy to see you, Spoon!" They danced together all night, spinning and twirling in the soft glow of the moonlight.',
    'ee':
        'Deep in the forest stood a tall tree with long branches and bright green leaves. One day, a little bee named Zee flew by the tree and stopped to rest. The tree asked Zee, "Where are you going?" Zee buzzed and said, "I’m collecting nectar to make sweet honey!" The tree shook its leaves and said, "Why not stay here with me? I’ll keep you cool with my shade." Zee agreed, and from then on, the bee and the tree became the best of friends, sharing stories and keeping each other company.',
    'ou':
        'High up in the sky, there was a big, fluffy cloud named Pout. Pout was very proud of how white and puffy he was. Every day, he floated across the sky, making shapes for all the animals on the ground to see. "Look, it\'s a bunny!" said a fox. "No, it’s a dragon!" said a bird. Pout loved making everyone smile. But one day, he noticed that other clouds were getting bigger. Pout wasn’t jealous; instead, he puffed himself up even more and made the biggest, fluffiest cloud shape ever—a huge, happy elephant!',
    'ch':
        'High up in the sky, there was a big, fluffy cloud named Pout. Pout was very proud of how white and puffy he was. Every day, he floated across the sky, making shapes for all the animals on the ground to see. "Look, it\'s a bunny!" said a fox. "No, it’s a dragon!" said a bird. Pout loved making everyone smile. But one day, he noticed that other clouds were getting bigger. Pout wasn’t jealous; instead, he puffed himself up even more and made the biggest, fluffiest cloud shape ever—a huge, happy elephant!',
    'ie':
        'In a cozy little kitchen, there was a pie on the windowsill, cooling off after being baked. The pie smelled so sweet, it made the whole house happy. Suddenly, a gust of wind whooshed through the window and lifted the pie into the sky! Up, up, up it went, floating above the houses and trees. A little bird named Kip saw the pie and couldn’t believe his eyes. "A pie in the sky!" Kip shouted. He followed the pie as it drifted through the clouds. Eventually, the pie landed back on the windowsill, and Kip got a tasty slice.',
  };

  DiagraphDetailScreen({required this.diagraph, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '$diagraph Diagraph',
          style: TextStyle(
            fontFamily: 'PartyConfetti',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLetterSounds(),
            _buildStoryContainer(),
            _buildImageContainer(),
            _buildVideoContainer(),
          ],
        ),
      ),
    );
  }

  Widget _buildLetterSounds() {
    return Container(
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
              fontFamily: 'PartyConfetti',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: lettersByDiagraph[diagraph]!
                .map((letter) => ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(24.0),
                        backgroundColor: Colors.blueAccent.withOpacity(0.7),
                      ),
                      onPressed: () async {
                        await _playLetterSound(letter);
                      },
                      child: Text(
                        letter.toUpperCase(),
                        style: TextStyle(
                          fontSize: 24.0,
                          fontFamily: 'PartyConfetti',
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildStoryContainer() {
    return Container(
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
            'Story with the "$diagraph" diagraph:',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'PartyConfetti',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20),
          Text(
            diagraphStories[diagraph]!,
            style: TextStyle(
              fontSize: 16.0,
              fontFamily: 'PartyConfetti',
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageContainer() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            'Flashcard Sound for "$diagraph":',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'PartyConfetti',
              fontWeight: FontWeight.bold,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: StarBorder(),
              padding: EdgeInsets.all(24.0),
              backgroundColor: Colors.orange.shade200.withOpacity(0.7),
              minimumSize: Size(150, 150),
              elevation: 8,
            ),
            onPressed: () async {
              await _playLetterSound(diagraph);
            },
            child: Text(
              diagraph.toUpperCase(),
              style: TextStyle(
                fontSize: 24.0,
                fontFamily: 'PartyConfetti',
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoContainer() {
    return Container(
      margin: EdgeInsets.all(16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '"$diagraph" FORMATION:',
            style: TextStyle(
              fontSize: 20.0,
              fontFamily: 'PartyConfetti',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          AspectRatio(
            aspectRatio: 16 / 9,
            child: VideoPlayerWidget(diagraph: diagraph),
          ),
        ],
      ),
    );
  }

  Future<void> _playLetterSound(String letter) async {
    String fileName = '${letter.toUpperCase()}_sound.mp3';

    try {
      await _audioPlayer.play(AssetSource('audio/$fileName'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String diagraph;

  VideoPlayerWidget({required this.diagraph});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        VideoPlayerController.asset('assets/${widget.diagraph}_video.mp4')
          ..initialize().then((_) {
            setState(() {});
          });
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Column(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              VideoProgressIndicator(_controller, allowScrubbing: true),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(_controller.value.isPlaying
                        ? Icons.pause
                        : Icons.play_arrow),
                    onPressed: () {
                      setState(() {
                        _controller.value.isPlaying
                            ? _controller.pause()
                            : _controller.play();
                      });
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.replay),
                    onPressed: () {
                      _controller.seekTo(Duration.zero);
                      _controller.play();
                    },
                  ),
                ],
              ),
            ],
          )
        : Center(child: CircularProgressIndicator());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

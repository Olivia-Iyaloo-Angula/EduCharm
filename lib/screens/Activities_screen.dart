import 'package:flutter/material.dart';

class ActivitiesScreen extends StatefulWidget {
  @override
  _ActivitiesScreenState createState() => _ActivitiesScreenState();
}

class _ActivitiesScreenState extends State<ActivitiesScreen> {
  bool isCollapsed = true;
  List<String> pupils = [];
  final TextEditingController nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Activities Screen',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInstructionBox(),
            SizedBox(height: 16.0),
            _buildPupilRegistration(),
            SizedBox(height: 16.0),
            _buildStartButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildInstructionBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isCollapsed = !isCollapsed;
            });
          },
          child: Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade200,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Text(
              'Tap to ${isCollapsed ? 'expand' : 'collapse'} instructions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        if (!isCollapsed)
          Container(
            padding: EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(10.0),
            ),
            child:
                Text('Reading is a vital skill for children\'s development...'
                    // Instructional content here
                    ),
          ),
      ],
    );
  }

  Widget _buildPupilRegistration() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Register Pupils:',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(hintText: 'Enter pupil name'),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  setState(() {
                    pupils.add(nameController.text);
                    nameController.clear();
                  });
                }
              },
            ),
          ],
        ),
        SizedBox(height: 10),
        if (pupils.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: pupils
                .map(
                  (pupil) => Chip(
                    label: Text(pupil),
                    onDeleted: () {
                      setState(() {
                        pupils.remove(pupil);
                      });
                    },
                  ),
                )
                .toList(),
          ),
      ],
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (pupils.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LevelSelectionScreen()),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Please register at least one pupil.')),
            );
          }
        },
        child: Text('Start Activity'),
      ),
    );
  }
}

class LevelSelectionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Level'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildLevelButton(context, 'Easy'),
          _buildLevelButton(context, 'Medium'),
          _buildLevelButton(context, 'Hard'),
          _buildLevelButton(context, 'Extremely Hard'),
        ],
      ),
    );
  }

  Widget _buildLevelButton(BuildContext context, String level) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WordActivityScreen(level: level),
            ),
          );
        },
        child: Text(level),
      ),
    );
  }
}

class WordActivityScreen extends StatefulWidget {
  final String level;
  WordActivityScreen({required this.level});

  @override
  _WordActivityScreenState createState() => _WordActivityScreenState();
}

class _WordActivityScreenState extends State<WordActivityScreen> {
  final List<Map<String, dynamic>> easyWords = [
    {
      'word': 'cat',
      'hint': 'Rhymes with hat',
      'image': 'assets/cat.png',
      'correctRhyme': true,
      'containsLetter': true
    },
    {
      'word': 'dog',
      'hint': 'Rhymes with log',
      'image': 'assets/dog.png',
      'correctRhyme': true,
      'containsLetter': true
    },
  ];
  final List<Map<String, dynamic>> mediumWords = [
    {
      'word': 'rain',
      'hint': 'Contains "r"',
      'image': 'assets/rain.png',
      'correctRhyme': true,
      'containsLetter': true
    },
    {
      'word': 'wood',
      'hint': 'Rhymes with good',
      'image': 'assets/wood.png',
      'correctRhyme': true,
      'containsLetter': true
    },
  ];
  final List<Map<String, dynamic>> hardWords = [
    {
      'word': 'great',
      'hint': 'Rhymes with weight',
      'image': 'assets/great.png',
      'correctRhyme': true,
      'containsLetter': true
    },
    {
      'word': 'blue',
      'hint': 'Contains "b"',
      'image': 'assets/blue.png',
      'correctRhyme': true,
      'containsLetter': true
    },
  ];
  final List<Map<String, dynamic>> extremelyHardWords = [
    {
      'word': 'exhaust',
      'hint': 'Rhymes with lost',
      'image': 'assets/exhaust.png',
      'correctRhyme': true,
      'containsLetter': true
    },
    {
      'word': 'obstacle',
      'hint': 'Contains "s"',
      'image': 'assets/obstacle.png',
      'correctRhyme': true,
      'containsLetter': true
    },
  ];

  List<Map<String, dynamic>> selectedWordList = [];
  int currentWordIndex = 0;
  int correctAnswers = 0;
  bool selectedRhyme = false;
  bool selectedContainsLetter = false;

  @override
  void initState() {
    super.initState();
    _selectWordList(widget.level);
  }

  void _selectWordList(String level) {
    switch (level) {
      case 'Easy':
        selectedWordList = easyWords;
        break;
      case 'Medium':
        selectedWordList = mediumWords;
        break;
      case 'Hard':
        selectedWordList = hardWords;
        break;
      case 'Extremely Hard':
        selectedWordList = extremelyHardWords;
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.level} Activity'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: currentWordIndex < selectedWordList.length
            ? _buildActivitySection()
            : _buildScoreScreen(),
      ),
    );
  }

  Widget _buildActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Word Activity:',
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.0),
        Image.asset(
          selectedWordList[currentWordIndex]['image']!,
          height: 150.0,
        ),
        SizedBox(height: 12.0),
        Text(
          'Word: ${selectedWordList[currentWordIndex]['word']}',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 8.0),
        Text(
          selectedWordList[currentWordIndex]['hint']!,
          style: TextStyle(fontSize: 18.0),
        ),
        SizedBox(height: 16.0),
        _buildCheckboxOptions(),
        SizedBox(height: 16.0),
        _buildSubmitButton(),
      ],
    );
  }

  Widget _buildCheckboxOptions() {
    return Column(
      children: [
        CheckboxListTile(
          title: Text('Correct rhyme'),
          value: selectedRhyme,
          onChanged: (value) {
            setState(() {
              selectedRhyme = value!;
            });
          },
        ),
        CheckboxListTile(
          title: Text('Contains letter'),
          value: selectedContainsLetter,
          onChanged: (value) {
            setState(() {
              selectedContainsLetter = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _checkAnswer,
      child: Text('Submit'),
    );
  }

  void _checkAnswer() {
    if (selectedRhyme == selectedWordList[currentWordIndex]['correctRhyme'] &&
        selectedContainsLetter ==
            selectedWordList[currentWordIndex]['containsLetter']) {
      correctAnswers++;
    }
    setState(() {
      currentWordIndex++;
      selectedRhyme = false;
      selectedContainsLetter = false;
    });
  }

  Widget _buildScoreScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Well done!',
            style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16.0),
          Text(
            'Score: $correctAnswers / ${selectedWordList.length}',
            style: TextStyle(fontSize: 18.0),
          ),
          SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Go Back'),
          ),
        ],
      ),
    );
  }
}

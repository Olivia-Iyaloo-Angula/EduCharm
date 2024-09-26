import 'package:flutter/material.dart';

class WordFamiliesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Word Families'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Word families are any group of words that have the same ending sound.',
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
                _buildWordFamilyButton(context, 'at', '-AT-'),
                _buildWordFamilyButton(context, 'an', '-AN-'),
                _buildWordFamilyButton(context, 'it', '-IT-'),
                _buildWordFamilyButton(context, 'in', '-IN-'),
                _buildWordFamilyButton(context, 'op', '-OP-'),
                _buildWordFamilyButton(context, 'ug', '-UG-'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWordFamilyButton(
      BuildContext context, String wordFamily, String description) {
    return Container(
      margin: EdgeInsets.all(10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              padding: EdgeInsets.symmetric(
                  vertical: 44.0, horizontal: 39.0), // Increased height
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordsScreen(wordFamily: wordFamily),
                ),
              );
            },
            child: Text(
              wordFamily.toUpperCase(),
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 12.0), // Space between button and text
          Text(
            description,
            style: TextStyle(
              fontSize: 18.0,
              color: Colors.black,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class WordsScreen extends StatelessWidget {
  final String wordFamily;

  WordsScreen({required this.wordFamily});

  @override
  Widget build(BuildContext context) {
    List<String> words = _getWordsForWordFamily(wordFamily);

    return Scaffold(
      appBar: AppBar(
        title: Text('$wordFamily Words'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: words.length,
        itemBuilder: (context, index) {
          String word = words[index];
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: word
                  .split('')
                  .map(
                    (letter) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(255, 147, 149, 149),
                          padding: EdgeInsets.all(
                              14.0), // Reduced padding for buttons
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize:
                              Size(50, 50), // Set a fixed size for buttons
                        ),
                        onPressed: () {
                          // Add your onPressed code here
                        },
                        child: Text(
                          letter.toUpperCase(),
                          style: TextStyle(
                            fontSize: 24.0, // Kept font size
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          );
        },
      ),
    );
  }

  List<String> _getWordsForWordFamily(String wordFamily) {
    // Define some example words for each word family
    switch (wordFamily) {
      case 'at':
        return [
          'cat',
          'bat',
          'hat',
          'rat',
          'sat',
          'mat',
          'pat',
          'fat',
          'flat',
          'that'
        ];
      case 'an':
        return [
          'fan',
          'man',
          'can',
          'pan',
          'tan',
          'van',
          'plan',
          'span',
          'scan',
          'ran'
        ];
      case 'it':
        return [
          'kit',
          'lit',
          'pit',
          'sit',
          'fit',
          'hit',
          'wit',
          'bit',
          'quit',
          'split'
        ];
      case 'in':
        return [
          'pin',
          'win',
          'bin',
          'sin',
          'fin',
          'kin',
          'spin',
          'grin',
          'thin',
          'skin'
        ];
      case 'op':
        return [
          'top',
          'pop',
          'hop',
          'mop',
          'cop',
          'shop',
          'chop',
          'drop',
          'flop',
          'stop'
        ];
      case 'ug':
        return [
          'bug',
          'hug',
          'rug',
          'mug',
          'jug',
          'tug',
          'dug',
          'lug',
          'plug',
          'slug'
        ];
      default:
        return [
          'cat',
          'bat',
          'hat',
          'rat',
          'sat',
          'mat',
          'pat',
          'fat',
          'flat',
          'that'
        ];
    }
  }
}

void main() {
  runApp(MaterialApp(
    home: WordFamiliesScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:educharm/controller.dart';
import 'package:educharm/drag.dart';
import 'package:educharm/drop.dart';
import 'fly_in_animation.dart';
import 'package:educharm/progress_bar.dart';
import 'settings.dart';
import 'package:educharm/message_box.dart';
import 'package:educharm/allWords.dart';

class SpellingBeeScreen extends StatefulWidget {
  @override
  _SpellingBeeScreenState createState() => _SpellingBeeScreenState();
}

class _SpellingBeeScreenState extends State<SpellingBeeScreen> {
  List<String> _words =
      List.from(allWords); // Avoid modifying the original list
  late String _word, _dropWord;

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  void _initializeScreen() {
    _words = List.from(allWords);
    _generateWord();
  }

  void _generateWord() {
    if (_words.isNotEmpty) {
      final r = Random().nextInt(_words.length);
      _word = _words[r];
      _dropWord = _word;
      _words.removeAt(r);

      final s = _word.characters.toList()..shuffle();
      _word = s.join();

      // Notify the controller after the screen is fully rendered
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Provider.of<Controller>(context, listen: false)
            .setUp(total: _word.length);
        Provider.of<Controller>(context, listen: false)
            .requestWord(request: false);
      });
    }
  }

  void _animationCompleted() {
    Future.delayed(const Duration(milliseconds: 200), () {
      Provider.of<Controller>(context, listen: false)
          .updateLetterDropped(dropped: false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Spelling Bee Screen',
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
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Selector<Controller, bool>(
        selector: (_, controller) => controller.generateWord,
        builder: (_, generate, __) {
          if (generate) {
            if (_words.isNotEmpty) {
              _generateWord();
            }
          }
          return SafeArea(
            child: Stack(
              children: [
                Container(
                  color: Colors.lightBlue,
                ),
                Column(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 0, 0, 0),
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(18, 2, 2, 2),
                                  child: FittedBox(
                                    child: Text(
                                      'Spelling Bee',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayLarge,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: Selector<Controller, bool>(
                                    selector: (_, controller) =>
                                        controller.letterDropped,
                                    builder: (_, dropped, __) => FlyInAnimation(
                                      removeScale: true,
                                      animate: dropped,
                                      animationCompleted: _animationCompleted,
                                      child:
                                          Image.asset('assets/images/Bee.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _dropWord.characters
                            .map((e) => FlyInAnimation(
                                  animate: true,
                                  child: Drop(
                                    letter: e,
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: FlyInAnimation(
                        animate: true,
                        child: Image.asset(
                          'assets/images/$_dropWord.png',
                          errorBuilder: (context, error, stackTrace) {
                            return const Text('Image not found');
                          },
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: _word.characters
                            .map(
                              (e) => FlyInAnimation(
                                animate: true,
                                child: Drag(
                                  letter: e,
                                  fontSize: 30,
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ),
                    const Expanded(flex: 1, child: ProgressBar()),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

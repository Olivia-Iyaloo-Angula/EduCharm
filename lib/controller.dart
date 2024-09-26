import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:educharm/allWords.dart';
import 'package:educharm/message_box.dart';

class Controller extends ChangeNotifier {
  int totalLetters = 0;
  int lettersAnswered = 0;
  int wordsAnswered = 0;
  bool generateWord = true;
  bool sessionCompleted = false;
  bool letterDropped = false;
  double percentCompleted = 0;

  final AudioPlayer _audioPlayer = AudioPlayer();

  void setUp({required int total}) {
    lettersAnswered = 0;
    totalLetters = total;
    notifyListeners();
  }

  void incrementLetters({required BuildContext context}) {
    lettersAnswered++;
    updateLetterDropped(dropped: true);

    if (lettersAnswered == totalLetters) {
      _playSound('audio/Well_done.mp3');
      wordsAnswered++;
      percentCompleted = wordsAnswered / allWords.length;

      if (wordsAnswered == allWords.length) {
        sessionCompleted = true;
      }

      showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => MessageBox(
          sessionCompleted: sessionCompleted,
        ),
      ).then((_) {
        // Optionally, reset after the dialog is closed
        if (sessionCompleted) {
          reset();
        } else {
          // Request a new word if the session is not completed
          requestWord(request: true);
        }
      });
    } else {
      _playSound('audio/Correct_1.mp3');
    }

    notifyListeners();
  }

  void requestWord({required bool request}) {
    generateWord = request;
    notifyListeners();
  }

  void updateLetterDropped({required bool dropped}) {
    letterDropped = dropped;
    notifyListeners();
  }

  void reset() {
    sessionCompleted = false;
    wordsAnswered = 0;
    generateWord = true;
    percentCompleted = 0;
    notifyListeners();
  }

  void _playSound(String path) async {
    try {
      await _audioPlayer.play(AssetSource(path));
    } catch (e) {
      print("Error playing sound: $e");
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }
}

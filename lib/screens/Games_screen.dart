import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'QRScannerScreen.dart'; // Import the QRScannerScreen

void main() {
  runApp(MaterialApp(
    home: GamesScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class GamesScreen extends StatelessWidget {
  // URL for the WebAR link
  final String webARLink = 'https://mywebar.com/p/Project_0_jrm0lme58o';

  // Function to launch the WebAR link
  void _launchWebAR() async {
    if (await canLaunch(webARLink)) {
      await launch(webARLink);
    } else {
      throw 'Could not launch $webARLink';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Games Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                // Navigate to the QRScannerScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => QRScannerScreen()),
                );
              },
              child: Text(
                'Open QR Scanner',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

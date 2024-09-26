import 'package:flutter/material.dart';
import 'package:educharm/main.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set Scaffold background color to white
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'EduCharm',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0, // To remove shadow below AppBar
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.white, // Set Container background color to white
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 250.0, // Adjust the width as needed
                height: 250.0, // Adjust the height as needed
                child: Image.asset(
                  'assets/WelcomeScreen.png',
                  fit: BoxFit.contain,
                ),
              ),
              const SizedBox(height: 40.0), // Add space below the image
              const Text(
                "A magical journey into the world of learning",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18.0, // Adjust the font size as needed
                ),
              ),
              const SizedBox(height: 30.0), // Space below the text
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Background color
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 20.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => NavigationManager()),
                  );
                },
                child: const Text(
                  "Start learning >> >>",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0, // Adjust the font size as needed
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

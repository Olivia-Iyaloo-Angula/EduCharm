import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: LetterTracingScreen(),
    debugShowCheckedModeBanner: false,
  ));
}

class LetterTracingScreen extends StatefulWidget {
  @override
  _LetterTracingScreenState createState() => _LetterTracingScreenState();
}

class _LetterTracingScreenState extends State<LetterTracingScreen>
    with SingleTickerProviderStateMixin {
  String _currentLetter = 'E'; // Set to 'E' for example
  int _correctTraces = 0;
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isTracingAllowed = false; // Flag to control when tracing is allowed
  List<Offset> _userPoints = []; // Store user tracing points

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward().then((_) {
      setState(() {
        _isTracingAllowed = true; // Allow tracing after the demo completes
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trace the Letter'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        color: Colors.blue[100], // Background color similar to screenshot
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 400,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue, width: 5),
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    DashedLetterPath(
                      letter: _currentLetter,
                      animation: _animation,
                    ),
                    if (!_isTracingAllowed)
                      AnimatedFingerIcon(animation: _animation),
                    if (_isTracingAllowed)
                      LetterTracingWidget(
                        letter: _currentLetter,
                        onTraceComplete: _onTraceComplete,
                        userPoints: _userPoints,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onTraceComplete() {
    setState(() {
      _correctTraces++;
      _isTracingAllowed = false; // Disable further tracing after completion
      _controller.reset();
      _controller.forward().then((_) {
        _userPoints.clear(); // Clear the user tracing points
        setState(() {
          _isTracingAllowed = true;
        });
      });
    });
  }
}

class DashedLetterPath extends StatelessWidget {
  final String letter;
  final Animation<double> animation;

  DashedLetterPath({required this.letter, required this.animation});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(300, 300),
      painter: DashedLetterPainter(letter, animation),
    );
  }
}

class DashedLetterPainter extends CustomPainter {
  final String letter;
  final Animation<double> animation;

  DashedLetterPainter(this.letter, this.animation);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 4.0
      ..style = PaintingStyle.stroke;

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(fontSize: 250, color: Colors.transparent),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    Path path = Path();
    textPainter.paint(canvas, Offset.zero);
    PathMetrics pathMetrics = path.computeMetrics();

    for (var metric in pathMetrics) {
      double length = metric.length * animation.value;
      for (double i = 0; i < length; i += 10) {
        canvas.drawLine(
          metric.getTangentForOffset(i)!.position,
          metric.getTangentForOffset(i + 5)!.position,
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(DashedLetterPainter oldDelegate) {
    return oldDelegate.letter != letter || oldDelegate.animation != animation;
  }
}

class AnimatedFingerIcon extends StatelessWidget {
  final Animation<double> animation;

  AnimatedFingerIcon({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 30 + (300 * (1 - animation.value)), // Adjust position
      child: Icon(
        Icons.touch_app,
        size: 50,
        color: Colors.blue,
      ),
    );
  }
}

class LetterTracingWidget extends StatefulWidget {
  final String letter;
  final VoidCallback onTraceComplete;
  final List<Offset> userPoints;

  LetterTracingWidget({
    required this.letter,
    required this.onTraceComplete,
    required this.userPoints,
  });

  @override
  _LetterTracingWidgetState createState() => _LetterTracingWidgetState();
}

class _LetterTracingWidgetState extends State<LetterTracingWidget> {
  void _handlePanUpdate(DragUpdateDetails details) {
    setState(() {
      widget.userPoints.add(details.localPosition);
    });
  }

  void _handlePanEnd(DragEndDetails details) {
    if (_isTraceCorrect()) {
      widget.onTraceComplete();
    }
    setState(() {
      widget.userPoints.clear(); // Clear points after tracing ends
    });
  }

  bool _isTraceCorrect() {
    // Implement logic to check if the trace is correct
    return true; // Allow all traces for now
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: CustomPaint(
        size: Size(300, 300),
        painter: LetterPainter(widget.letter, widget.userPoints),
      ),
    );
  }
}

class LetterPainter extends CustomPainter {
  final String letter;
  final List<Offset> points;

  LetterPainter(this.letter, this.points);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;

    TextPainter textPainter = TextPainter(
      text: TextSpan(
        text: letter,
        style: TextStyle(fontSize: 250, color: Colors.grey[300]),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset.zero);

    // Draw user's tracing
    for (int i = 0; i < points.length - 1; i++) {
      canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  @override
  bool shouldRepaint(LetterPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.letter != letter;
  }
}

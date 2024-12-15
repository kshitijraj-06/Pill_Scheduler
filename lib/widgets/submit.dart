import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AnimatedSubmitButton extends StatefulWidget {
  final VoidCallback onPressed;

  const AnimatedSubmitButton({Key? key, required this.onPressed}) : super(key: key);

  @override
  _AnimatedSubmitButtonState createState() => _AnimatedSubmitButtonState();
}

class _AnimatedSubmitButtonState extends State<AnimatedSubmitButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _animation = Tween<double>(begin: -1, end: 1).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startAnimation() {
    _controller.reset();
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth * 0.9; // 80% of screen width
    final buttonHeight = 60.0; // Fixed height

    return GestureDetector(
      onTap: () {
        _startAnimation();
        widget.onPressed();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Container
          Container(
            width: buttonWidth,
            height: buttonHeight,
            decoration: BoxDecoration(
              color: Color(0xFFCBF8F3),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  spreadRadius: 2,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.send,
                    color: Colors.black87,
                    size: 25,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Submit',
                      style: GoogleFonts.lexendDeca(
                      fontSize: 23,
                      color: Colors.black,
                      decoration: TextDecoration.none,
                      fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ),

          // Wave Animation
          Positioned(
            left: _animation.value * buttonWidth, // Animate across the button width
            child: Container(
              width: 40, // Width of the wave
              height: buttonHeight,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.4),
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.0),
                  ],
                  stops: [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
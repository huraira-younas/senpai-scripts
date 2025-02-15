import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/material.dart';
import 'dart:async';

class TypingAnimation extends StatefulWidget {
  final String text;
  final Duration duration;

  const TypingAnimation({
    super.key,
    required this.text,
    this.duration = const Duration(milliseconds: 50),
  });

  @override
  State<TypingAnimation> createState() => _TypingAnimationState();
}

class _TypingAnimationState extends State<TypingAnimation>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _animations;
  late List<String> _typedCharacters;

  @override
  void initState() {
    super.initState();
    _typedCharacters = [];
    _animationControllers = [];
    _animations = [];

    for (int i = 0; i < widget.text.length; i++) {
      _typedCharacters.add('');
      _animationControllers.add(
        AnimationController(vsync: this, duration: widget.duration),
      );

      _animations.add(
        Tween<double>(begin: 0, end: -5).animate(
          CurvedAnimation(
            parent: _animationControllers[i],
            curve: Curves.easeOut,
          ),
        ),
      );
    }

    _startTyping();
  }

  void _startTyping() async {
    for (int i = 0; i < widget.text.length; i++) {
      await Future.delayed(
        Duration(milliseconds: widget.duration.inMilliseconds * i),
      );

      setState(() {
        _typedCharacters[i] = widget.text[i];
      });

      _animationControllers[i].forward(from: 0);
    }
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(widget.text.length, (index) {
        return AnimatedBuilder(
          animation: _animations[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: Text(
                _typedCharacters[index],
                style: GoogleFonts.inter(
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}

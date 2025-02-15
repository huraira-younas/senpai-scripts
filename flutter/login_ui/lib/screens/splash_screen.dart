import 'package:flutter/material.dart';
import 'package:login_ui/const/colors.dart';
import 'package:login_ui/screens/login_screen.dart';
import 'package:login_ui/widgets/typing_widget.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool isDone = false, type = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isDone = true;
      });

      Future.delayed(
        const Duration(milliseconds: 1000),
        () => setState(() => type = true),
      );

      Future.delayed(const Duration(seconds: 3), () {
        Future.delayed(
          const Duration(milliseconds: 200),
          () => setState(() => isDone = false),
        );

        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          Navigator.of(
            context,
          ).pushReplacement(MaterialPageRoute(builder: (_) => LoginScreen()));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          SizedBox(height: size.height, width: size.width),
          Positioned(
            left: -size.width,
            right: -size.width,
            child: AnimatedContainer(
              height: isDone ? size.height * 2 : 100,
              width: isDone ? size.width * 2 : 100,
              duration: const Duration(milliseconds: 600),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDone ? primaryColor : Colors.white,
              ),
            ),
          ),
          AnimatedContainer(
            height: 80,
            width: 80,
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: isDone ? Colors.white : primaryColor,
                width: 8,
              ),
              color: isDone ? primaryColor : Colors.white,
            ),
          ),
          Positioned(
            bottom: 30,
            child: AnimatedOpacity(
              opacity: type ? 1 : 0,
              duration: const Duration(milliseconds: 300),
              child: type ? TypingAnimation(text: "Ovadey") : null,
            ),
          ),
        ],
      ),
    );
  }
}

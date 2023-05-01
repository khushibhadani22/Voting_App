import 'dart:async';

import 'package:flutter/material.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation sizeAnimation;
  late Animation textAnimation;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 2000,
      ),
    );

    sizeAnimation =
        Tween<double>(begin: 50, end: 200).animate(animationController);
    textAnimation = TextStyleTween(
      begin: const TextStyle(
        color: Colors.cyan,
        fontSize: 10,
        fontWeight: FontWeight.bold,
      ),
      end: TextStyle(
        color: Colors.cyan.shade900,
        fontWeight: FontWeight.bold,
        fontSize: 30,
      ),
    ).animate(animationController);

    animationController.forward();
    Timer(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed('login_page');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      //  backgroundColor: Colors.cyan,
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Spacer(),
            AnimatedBuilder(
              animation: animationController,
              builder: (context, widget) {
                return Column(
                  children: [
                    RotationTransition(
                      turns: animationController,
                      child: const CircleAvatar(
                        radius: 90,
                        backgroundImage: AssetImage(
                          'assets/images/vote.jpg',
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Voting App",
                      style: textAnimation.value,
                    ),
                  ],
                );
              },
            ),
            const Spacer(),
            LinearProgressIndicator(
              color: Colors.cyan.shade900,
              backgroundColor: Colors.cyan,
            ),
          ],
        ),
      ),
    );
  }
}

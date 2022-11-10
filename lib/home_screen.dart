import 'dart:async';

import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double shipX = 0.0, shipY = 0.0;
  double maxHeight = 0.0;
  double initialPosition = 0.0;
  double time = 0.0;
  double velocity = 2.9;
  double gravity = -4.9;
  bool isGameRunning = false;

  void startGame() {
    isGameRunning = true;

    Timer.periodic(
      const Duration(milliseconds: 30),
      (timer) {
        time = time + 0.02;

        setState(() {
          maxHeight = velocity * time + gravity * time * time;

          shipY = initialPosition - maxHeight;
        });
      },
    );
  }

  void onJump() {
    setState(() {
      time = 0;
      initialPosition = shipY;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: isGameRunning ? onJump : startGame,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/space.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Align(
                alignment: Alignment(shipX, shipY),
                child: Container(
                  height: 40,
                  width: 80,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage("assets/ship1.png"),
                    ),
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

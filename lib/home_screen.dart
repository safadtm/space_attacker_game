import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:space_attackers/asteriod_model.dart';

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

  List<AsteriodData> asteroidData = [];

  List<AsteriodData> setAsteroidData() {
    List<AsteriodData> data = [
      AsteriodData(
        size: const Size(40, 60),
        alignment: const Alignment(2, 0.7),
      ),
      AsteriodData(
        size: const Size(80, 100),
        alignment: const Alignment(1.5, -0.5),
      ),
      AsteriodData(
        size: const Size(40, 50),
        alignment: const Alignment(3, -0.2),
      ),
      AsteriodData(
        size: const Size(60, 30),
        alignment: const Alignment(2.2, 0.2),
      ),
    ];

    return data;
  }

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
        moveAsteriod();
      },
    );
  }

  void onJump() {
    setState(() {
      time = 0;
      initialPosition = shipY;
    });
  }

  double generateRandomNumber() {
    Random rand = Random();
    double randomDouble = rand.nextDouble() * (-1.0 - 1.0) + 1.0;
    return randomDouble;
  }

  void moveAsteriod() {
    Alignment asteriod1 = asteroidData[0].alignment;
    Alignment asteriod2 = asteroidData[1].alignment;
    Alignment asteriod3 = asteroidData[2].alignment;
    Alignment asteriod4 = asteroidData[3].alignment;

    if (asteriod1.x > -1.4) {
      asteroidData[0].alignment = Alignment(asteriod1.x - 0.02, asteriod1.y);
    } else {
      asteroidData[0].alignment = Alignment(2, generateRandomNumber());
    }
    if (asteriod2.x > -1.4) {
      asteroidData[1].alignment = Alignment(asteriod2.x - 0.02, asteriod2.y);
    } else {
      asteroidData[1].alignment = Alignment(1.5, generateRandomNumber());
    }
    if (asteriod3.x > -1.4) {
      asteroidData[2].alignment = Alignment(asteriod3.x - 0.02, asteriod3.y);
    } else {
      asteroidData[2].alignment = Alignment(3, generateRandomNumber());
    }
    if (asteriod4.x > -1.4) {
      asteroidData[3].alignment = Alignment(asteriod4.x - 0.02, asteriod4.y);
    } else {
      asteroidData[3].alignment = Alignment(2.2, generateRandomNumber());
    }
  }

  @override
  void initState() {
    super.initState();
    asteroidData = setAsteroidData();
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
              Align(
                alignment: asteroidData[0].alignment,
                child: Container(
                  height: asteroidData[0].size.height,
                  width: asteroidData[0].size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(asteroidData[0].path),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: asteroidData[1].alignment,
                child: Container(
                  height: asteroidData[1].size.height,
                  width: asteroidData[1].size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(asteroidData[2].path),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: asteroidData[2].alignment,
                child: Container(
                  height: asteroidData[2].size.height,
                  width: asteroidData[2].size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(asteroidData[2].path),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: asteroidData[3].alignment,
                child: Container(
                  height: asteroidData[3].size.height,
                  width: asteroidData[3].size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(asteroidData[3].path),
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

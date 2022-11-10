import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:space_attackers/asteriod_model.dart';
import 'package:space_attackers/collision_data.dart';

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

  int score = 0;

  List<GlobalKey> globalKeys = [];
  GlobalKey shipGlobalKey = GlobalKey();

  List<AsteriodData> asteroidData = [];

  List<AsteriodData> setAsteroidData() {
    List<AsteriodData> data = [
      AsteriodData(
        size: const Size(70, 70),
        alignment: const Alignment(3.9, 0.7),
      ),
      AsteriodData(
        size: const Size(100, 100),
        alignment: const Alignment(1.8, -0.5),
      ),
      AsteriodData(
        size: const Size(40, 40),
        alignment: const Alignment(3, -0.3),
      ),
      AsteriodData(
        size: const Size(60, 60),
        alignment: const Alignment(2.3, 0.5),
      ),
    ];

    return data;
  }

  void startGame() {
    resetData();
    isGameRunning = true;

    Timer.periodic(
      const Duration(milliseconds: 30),
      (timer) {
        time = time + 0.02;

        setState(() {
          maxHeight = velocity * time + gravity * time * time;

          shipY = initialPosition - maxHeight;

          if (isShipColoded()) {
            timer.cancel();
            isGameRunning = false;
          }
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

    /////////////////////////////

    if (asteriod1.x <= 0.021 && asteriod1.x >= 0.001) {
      score++;
    }
    if (asteriod2.x <= 0.02 && asteriod2.x >= 0.001) {
      score++;
    }
    if (asteriod3.x <= 0.021 && asteriod3.x >= 0.001) {
      score++;
    }
    if (asteriod4.x <= 0.021 && asteriod4.x >= 0.001) {
      score++;
    }
  }

  bool isShipColoded() {
    if (shipY > 1) {
      return true;
    } else if (shipY < -0.95) {
      return true;
    } else if (chechCollision()) {
      return true;
    } else {
      return false;
    }
  }

  bool chechCollision() {
    bool isCollided = false;

    RenderBox shipRenderBox =
        shipGlobalKey.currentContext!.findRenderObject() as RenderBox;

    List<CollisionData> collisionData = [];

    for (var element in globalKeys) {
      RenderBox renderBox =
          element.currentContext!.findRenderObject() as RenderBox;

      collisionData.add(
        CollisionData(
          sizeOfObject: renderBox.size,
          positionOfBox: renderBox.localToGlobal(Offset.zero),
        ),
      );
    }
    for (var element in collisionData) {
      final shipPosition = shipRenderBox.localToGlobal(Offset.zero);
      final asteroidPosition = element.positionOfBox;

      final asteroidSize = element.sizeOfObject;
      final shipSize = shipRenderBox.size;

      bool _isCollided =
          (shipPosition.dx < asteroidPosition.dx + asteroidSize.width &&
              shipPosition.dx + shipSize.width > asteroidPosition.dx &&
              shipPosition.dy < asteroidPosition.dy + asteroidSize.height &&
              shipPosition.dy + shipSize.height > asteroidPosition.dy);
      if (_isCollided) {
        isCollided = true;
        break;
      } else {
        isCollided = false;
      }
    }

    return isCollided;
  }

  @override
  void initState() {
    super.initState();
    asteroidData = setAsteroidData();
    initialiseGlobalKeys();
  }

  void initialiseGlobalKeys() {
    for (int i = 0; i < 4; i++) {
      globalKeys.add(GlobalKey());
    }
  }

  void resetData() {
    setState(() {
      asteroidData = setAsteroidData();
      shipX = 0.0;
      shipY = 0.0;
      maxHeight = 0.0;
      initialPosition = 0.0;
      time = 0.0;
      velocity = 2.9;
      gravity = -4.9;
      score = 0;
      isGameRunning = false;
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
                  key: shipGlobalKey,
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
                  key: globalKeys[0],
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
                  key: globalKeys[1],
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
                  key: globalKeys[2],
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
                  key: globalKeys[3],
                  height: asteroidData[3].size.height,
                  width: asteroidData[3].size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(asteroidData[3].path),
                    ),
                  ),
                ),
              ),
              isGameRunning
                  ? const SizedBox()
                  : const Align(
                      alignment: Alignment(0, -0.3),
                      child: Text(
                        "TAP TO PLAY",
                        style: TextStyle(
                          fontSize: 25,
                          letterSpacing: 4,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
              Align(
                alignment: const Alignment(0, 0.95),
                child: Text(
                  "Score : $score",
                  style: const TextStyle(
                    fontSize: 25,
                    letterSpacing: 4,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:babellion/routes/app_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'dart:async';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showLogo = false;
  List<Widget> _towerWidgets = [];

  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 0), () {
      _startTowerDrop();
    });

    Timer(const Duration(seconds: 2), () {
      setState(() {
        _showLogo = true;
      });
    });

    Timer(const Duration(seconds: 4), () {
      GoRouter.of(context).go(AppRouter.login.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFAA733F),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFAA733F), width: 2),
              ),
            ),
            ..._towerWidgets, // Display Tower Widgets
            if (_showLogo)
              Positioned(
                bottom: 50,
                child: Image.asset('assets/images/logoname.jpg', width: 150)
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .fade(duration: const Duration(seconds: 2)),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _startTowerDrop() async {
    _dropTower('assets/images/tower4.png', 0, -200, 35);
    await Future.delayed(Duration(milliseconds: 450));

    _dropTower('assets/images/tower3.png', 2000, -200, 5);
    await Future.delayed(Duration(milliseconds: 450));

    _dropTower('assets/images/tower2.png', 4000, -200, -30);
    await Future.delayed(Duration(milliseconds: 450));

    _dropTower('assets/images/tower1.png', 6000, -200, -60);
  }

  void _dropTower(String imagePath, int delay, double startY, double targetY) {
    setState(() {
      _towerWidgets.add(
        TweenAnimationBuilder(
          tween: Tween<double>(begin: startY, end: targetY),
          duration: const Duration(seconds: 2),
          curve: Curves.bounceOut,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, value),
              child: Image.asset(imagePath, width: 150),
            );
          },
        ).animate(delay: Duration(milliseconds: delay)),
      );
    });
  }
}

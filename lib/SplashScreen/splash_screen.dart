import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gate_keeper_app/screens/menu_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool _showImage = false;
  bool _showText = false;

  @override
  void initState() {
    super.initState();
     Timer(const Duration(seconds: 3), () {
      setState(() {
        _showImage = true;
      });
      Timer(const Duration(seconds: 2), () {
        setState(() {
          _showText = true;
        });
        Timer(const Duration(seconds: 1), (){
          Navigator.pushReplacement(
            context,
            PageRouteBuilder(
              transitionDuration:const Duration(milliseconds: 500),
              pageBuilder: (context, animation, secondaryAnimation) => const MenuScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );
              },
            ),
          );
        });
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 200),
            AnimatedOpacity(
              opacity: _showImage ? 1.0 : 0.0,
              duration:const Duration(seconds: 1),
              curve: Curves.easeInOutBack,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 40),
                  Image.asset(
                    "assets/App.png",
                    width: 200,
                  ),
                ],
              ),
            ),
           const SizedBox(height: 20),
            AnimatedOpacity(
              opacity: _showText ? 1.0 : 0.0,
              duration:const Duration(seconds: 1),
              curve: Curves.easeInOutBack,
              child:const Column(
                children: [
                  Text(
                    "GATE KEEPER",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Your Gateway To Secure Living",
                    style: TextStyle(
                      fontSize: 18,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

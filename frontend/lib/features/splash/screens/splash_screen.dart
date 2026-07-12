import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
      () {
        if (!mounted) return;

        context.go(AppRouter.login);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF6C4DFF),
              Color(0xFF8B5CFF),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/images/logo.png",
                  width: 140,
                  height: 140,
                )
                    .animate()
                    .fadeIn(duration: 800.ms)
                    .scale(),

                const SizedBox(height: 30),

                const Text(
                  "FairSplit",
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 300.ms),

                const SizedBox(height: 12),

                const Text(
                  "Split Smarter,\nNot Harder",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 17,
                    height: 1.5,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 600.ms),

                const SizedBox(height: 50),

                const CircularProgressIndicator(
                  color: Colors.white,
                )
                    .animate()
                    .fadeIn(delay: 900.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
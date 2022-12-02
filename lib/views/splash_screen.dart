import 'dart:math' as math;
import 'package:ecommerce_app/views/login_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
      _controller.stop(canceled: true);
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: _controller,
        child: Center(
          child: SizedBox(
            width: 300.0,
            height: 200.0,
            child: Image.asset("assets/images/logo.jpeg"),
          ),
        ),
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2.2 * math.pi,
            child: child,
          );
        },
      ),
    );
  }
}

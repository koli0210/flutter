import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:test_01/view/welcome/welcome_view_controller.dart';

class WelcomeView extends StatelessWidget {
  final WelcomeViewController _controller = Get.put(WelcomeViewController());
  WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/splash.jpeg',
                height: 170,
                width: 170,
              ),
              const SizedBox(height: 56),
              const SpinKitThreeInOut(
                color: Colors.blue,
                size: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

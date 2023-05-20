
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../labour/labour_home_screen.dart';
import '../user/home.dart';
import '../user/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  Future<void> _navigate() async {
    await Future.delayed(const Duration(seconds: 2));
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    if (token == null) {
      Get.off(() => LoginScreen());
    } else {
      bool? isWorker = prefs.getBool('isWorker');
      if (isWorker!) {
        Get.off(() => const LabourHomeScreen());
      } else {
        Get.off(() => const Home());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image(
              image: AssetImage('assets/workers.jpg'),
            ),
            Text(
              "WORKERS WORLD",
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 37, 40, 48),
                shadows: [
                  Shadow(
                    offset: Offset(.5, 1),
                    blurRadius: 4,
                    color: Color.fromARGB(255, 37, 40, 48),
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

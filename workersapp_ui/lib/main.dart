import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workersapp_ui/screens/commonScreen/splash_screen.dart';



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF8a95a7),
        useMaterial3: true,
      ),
      home:  const SplashScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workersapp_ui/logic/controller/labour/labour_auth_controller.dart';
import 'package:workersapp_ui/screens/labour/labour_signup_screen.dart';

import '../../widgets/buttion.dart';
import '../../widgets/components/email_feild.dart';
import '../../widgets/components/password_field.dart';
import '../user/login_screen.dart';

class LabourLoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final LabourAuthController loginController = Get.put(LabourAuthController());
  LabourLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(32),
            children: <Widget>[
              const Text(
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
              const SizedBox(height: 20),
              EmailFeild(
                  textEditingController: loginController.emailController),
              PasswordField(
                textEditingController: loginController.passwordController,
              ),
              const SizedBox(
                height: 20,
              ),
              Button(
                onPressed: () => loginController.loginUser(),
                text: "Signup",
              ),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: const Text(
                        "Are-you-New-Worker?",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      onTap: () => Get.offAll(
                        LabourSignupScreen(),
                      ),
                    ),
                    GestureDetector(
                      child: const Text(
                        "Are You User",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      onTap: () => Get.offAll(LoginScreen()),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

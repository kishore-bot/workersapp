import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workersapp_ui/screens/user/home.dart';
import 'package:workersapp_ui/screens/user/login_screen.dart';
import '../../logic/controller/user/authentication.dart';
import '../../logic/controller/user/user_me.dart';
import '../../widgets/buttion.dart';
import '../../widgets/components/email_feild.dart';
import '../../widgets/components/number_feild.dart';
import '../../widgets/components/password_field.dart';
import '../../widgets/components/text_input_field.dart';
import '../labour/labour_login_screen.dart';

class SignupScreen extends StatelessWidget {
  final UserDetails user = Get.put(UserDetails());
  final _formKey = GlobalKey<FormState>();
  final AuthenticationController signupController =
      Get.put(AuthenticationController());
  SignupScreen({super.key});


  final Rx<Uint8List?> _imageBytes = Rx<Uint8List?>(null);
  void uploadImage() async {
    Uint8List? selectedImageBytes = await user.uploadPhoto();
    if (selectedImageBytes != null) {
      _imageBytes.value = selectedImageBytes;
    } else {
      Get.snackbar(
        'Error',
        "Select an image",
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    }
  }

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
              const SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage();
                },
                child: Obx(
                  () => user.isLoading.value
                      ? const CircularProgressIndicator()
                      : CircleAvatar(
                          backgroundImage: _imageBytes.value != null
                              ? MemoryImage(_imageBytes.value!)
                              : null,
                          radius: 100,
                          backgroundColor: Colors.red,
                          child: Container(
                            alignment: Alignment.topRight,
                            width: 30,
                            height: 30,
                            margin: const EdgeInsets.all(10),
                            child: const CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  AssetImage("assets/addImage.jpeg"),
                            ),
                          ),
                        ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextInputField(
                hinttext: 'Name',
                icon: Icons.person,
                textEditingController: signupController.nameController,
              ),
              const SizedBox(
                height: 20,
              ),
              NumberFeild(
                textEditingController: signupController.numberController,
              ),
              const SizedBox(
                height: 20,
              ),
              EmailFeild(
                textEditingController: signupController.emailController,
              ),
              const SizedBox(
                height: 20,
              ),
              PasswordField(
                textEditingController: signupController.passwordController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextInputField(
                hinttext: 'City',
                icon: Icons.streetview,
                textEditingController: signupController.streetController,
              ),
              const SizedBox(
                height: 20,
              ),
              TextInputField(
                hinttext: 'Address',
                icon: Icons.home,
                textEditingController: signupController.adressController,
              ),
              const SizedBox(
                height: 10,
              ),
              Button(
                onPressed: () async{
                  await signupController.signupUser();
                  await user.upload();
                  Get.off(const Home());
                },
                text: "Signup",
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      child: const Text(
                        "Back To Login",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      onTap: () => Get.offAll(LoginScreen()),
                    ),
                    GestureDetector(
                      child: const Text(
                        "Are You worker",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      onTap: () => Get.offAll(LabourLoginScreen()),
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

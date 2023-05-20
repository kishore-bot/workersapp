import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../../global vriables/global_variables.dart';
import '../../../screens/user/home.dart';

class LabourAuthController extends GetxController {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController experience = TextEditingController();
  TextEditingController phoneNo = TextEditingController();
  TextEditingController specialization = TextEditingController();
    TextEditingController idcontroller = TextEditingController();
  final Future<SharedPreferences> _userPref = SharedPreferences.getInstance();

  Future<void> signupUser() async {
    try {
      if (nameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          specialization.text.isEmpty ||
          phoneNo.text.isEmpty ||
          experience.text.isEmpty||idcontroller.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill in all the fields',
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );
        return;
      }

      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse('$uri/workers-signup');
      Map body = {
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'phoneNo':phoneNo.text,
        'specialization':specialization.text,
        'experience':experience.text,
        'workerJobId':idcontroller.text
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        var token = jsonData['token'];
        var worker = jsonData['worker'];
        final SharedPreferences userPref = await _userPref;
        await userPref.setString('token', token);
        await userPref.setString('name', worker['name']);
        await userPref.setBool('isWorker', true);
        nameController.clear();
        passwordController.clear();
        emailController.clear();
        specialization.clear();
        phoneNo.clear();
        experience.clear();
        idcontroller.clear();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    }
  }

  Future<void> loginUser() async {
    try {
      // Validate input fields
      if (emailController.text.isEmpty || passwordController.text.isEmpty) {
        Get.snackbar(
          'Error',
          'Please fill in all the fields',
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );
        return;
      }

      var headers = {'Content-Type': 'application/json'};
      var url = Uri.parse('$uri/workers-login');
      Map body = {
        'email': emailController.text,
        'password': passwordController.text
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);

      if (response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        var token = jsonData['token'];
        var worker = jsonData['worker'];
        final SharedPreferences userPref = await _userPref;
        await userPref.setString('token', token);
        await userPref.setString('name', worker['name']);
        await userPref.setBool('isWorker', true);
        Get.off(const Home());
        nameController.clear();
        passwordController.clear();
        emailController.clear();
      } else {
        Get.snackbar(
          'Error',
          'An error occurred while signing up. Please try again later.',
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    }
  }
}

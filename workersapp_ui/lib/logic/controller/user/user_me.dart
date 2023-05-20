import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

import '../../../global vriables/global_variables.dart';
import '../../../screens/user/login_screen.dart';
import '../../models/user_model.dart';

class UserDetails extends GetxController {
  XFile? pickedFile;
  var isLoading = false.obs;
  var isImage = false.obs;
  UserModel? _userModel;
  UserModel get userModel => _userModel!;
  String? str;
  Future<void> userName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    str = prefs.getString('name')!;
  }

  Future<void>fetchMe() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      var response = await http.get(
        Uri.parse('$uri/users/profile'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _userModel = UserModel.fromJson(jsonData);
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
    } finally {
      isLoading(false);
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var response = await http.post(
      Uri.parse('$uri/users/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 201) {
      await prefs.remove('token');
      await prefs.remove('name');
      await prefs.remove('isWorker');
      Get.off(() => LoginScreen());
    }
  }

  Future<Uint8List?> uploadPhoto() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if (result != null) {
        PlatformFile file = result.files.single;
        pickedFile = convertFilePickerToImagePicker(file);
        if (pickedFile != null) {
          final fileBytes = await File(pickedFile!.path).readAsBytes();
          return fileBytes;
        } else {
          showFileSelectionError();
          return null;
        }
      }
    } catch (e) {
      showFileSelectionError();
      return null;
    }
    return null;
  }

  XFile? convertFilePickerToImagePicker(PlatformFile file) {
    if (file.path != null) {
      return XFile(file.path!);
    }
    return null;
  }

  void showFileSelectionError() {
    Get.snackbar(
      'Error',
      "Need to select a file",
      duration: const Duration(seconds: 3),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[700],
      colorText: Colors.white,
    );
  }

  // upload image
  Future<void> upload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token'};
    var request = http.MultipartRequest('POST', Uri.parse('$uri/users/avatar'));
    request.headers.addAll(headers);

    var file = await http.MultipartFile.fromPath('avatar', pickedFile!.path);
    request.files.add(file);
    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        Get.snackbar(
          'Success',
          "uploaded successfully",
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          "Failed to Upload",
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
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

  // feth the image
  Future<Uint8List?> fetchAvatarImage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token'};

    try {
      var response =
          await http.get(Uri.parse('$uri/users/avatar'), headers: headers);

      if (response.statusCode == 200) {
        isLoading(false);
        return response.bodyBytes;
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
    return null;
  }
}

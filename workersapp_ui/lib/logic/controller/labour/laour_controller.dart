import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';
import 'package:workersapp_ui/logic/models/labour_review_model.dart';
import 'package:workersapp_ui/screens/labour/labour_login_screen.dart';

import '../../../global vriables/global_variables.dart';
import '../../models/labour_profile_model.dart';
import '../../models/labour_request_model.dart';

class LabourController extends GetxController {
  var isLoading = false.obs;
  XFile? pickedFile;

  var isImage = false.obs;
  LabourProfileModel? _labourProfile;

  LabourProfileModel? get labourProfile => _labourProfile;
  String? str;

  List<LabourRequestModel> _labourReqHistory = [];
    List<LabourRequestModel> get labourReqHistory => _labourReqHistory;
    
  List<LabourReviewModel> _review = [];

  List<LabourReviewModel> get review => _review;
// fetch worker
  Future<void> userName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    str = prefs.getString('name')!;
  }
//fetch worker details
  Future<void> fetchMe() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var response = await http.get(
      Uri.parse('$uri/workers/profile'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      _labourProfile = LabourProfileModel.fromJson(jsonData);
    } else {
      throw Exception('Failed to fetch profile');
    }
  }

  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var response = await http.post(
      Uri.parse('$uri/workers/logout'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 201) {
      await prefs.remove('token');
      await prefs.remove('name');
      await prefs.remove('isWorker');
      Get.off(() => LabourLoginScreen());
    }
  }

  Future<int> isRequested(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var response = await http.get(
      Uri.parse('$uri/worker/status-updates/$id'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      int status = jsonData['status'];
      return status;
    }
    return -1;
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

  Future<void> upload() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    var headers = {'Authorization': 'Bearer $token'};
    var request =
        http.MultipartRequest('POST', Uri.parse('$uri/workers/avatar'));
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
          await http.get(Uri.parse('$uri/workers/avatar'), headers: headers);

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

  Future<void> fetchRequests() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var response = await http.get(
        Uri.parse('$uri/workers/history'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseBody = response.body.toString();

        if (responseBody.isNotEmpty) {
          final jsonData = json.decode(responseBody);
          _labourReqHistory = List<LabourRequestModel>.from(
            jsonData.map(
              (data) => LabourRequestModel.fromJson(data),
            ),
          );
          return;
        }
      }
      Get.snackbar(
        'Message',
        "No request found",
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    } catch (e) {
      final msg = json.decode(e.toString())['error'];
      Get.snackbar(
        'Error',
        msg,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> acceptedRequests() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var response = await http.get(
        Uri.parse('$uri/workers/fetch-status'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseBody = response.body.toString();

        if (responseBody.isNotEmpty) {
          final jsonData = json.decode(responseBody);
          _labourReqHistory = List<LabourRequestModel>.from(
            jsonData.map(
              (data) => LabourRequestModel.fromJson(data),
            ),
          );
          return;
        }
      }
      Get.snackbar(
        'Message',
        jsonDecode(response.body)['message'],
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    } catch (e) {
      final msg = json.decode(e.toString())['error'];
      Get.snackbar(
        'Error',
        msg,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  Future<void> acceptOrReject(String id, int status) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Map<String, dynamic> body = {'id': id, 'status': status};
      var response = await http.post(
        Uri.parse('$uri/workers/change-status'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          "Status Changed",
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          " ",
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
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    }
  }

  Future<void> finishWork(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      Map<String, dynamic> body = {
        'id': id,
      };
      var response = await http.post(
        Uri.parse('$uri/workers/finish'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          "Finished",
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          " ",
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
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    }
  }

  Future<void> labourReview() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var response = await http.get(
        Uri.parse('$uri/workers/review'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final responseBody = response.body.toString();

        if (responseBody.isNotEmpty) {
          final jsonData = json.decode(responseBody);
          _review = LabourReviewModel.fromJsonList(jsonData);
          return;
        }
      } else {
        Get.snackbar(
          'Message',
          "NO ONE REVEWD YOU",
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );
      }
    } catch (e) {
      final msg = json.decode(e.toString())['error'];
      Get.snackbar(
        'Error',
        msg,
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }
}

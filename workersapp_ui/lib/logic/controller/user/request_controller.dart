import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../global vriables/global_variables.dart';
import '../../../screens/user/home.dart';
import '../../models/user_history.dart';

class RequestController extends GetxController {
  TextEditingController comment = TextEditingController();
  TextEditingController rating = TextEditingController();

  var isLoading = false.obs;
  List<UserHistory> _historyList = []; // use the WorkersModel

  List<UserHistory> get historyList => _historyList;

  @override
  void onClose() {
    super.onClose();
    _historyList.clear();
  }

  Future<void> fetchHistory() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var response = await http.get(
        Uri.parse('$uri/users/history'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body.toString());
        _historyList = List<UserHistory>.from(
          jsonData.map(
            (data) => UserHistory.fromJson(data),
          ),
        );
        return;
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

  // for Workers screen
  Future<bool> requestWorker(String owner) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var headers = {'Authorization': 'Bearer $token'};
      var url = Uri.parse('$uri/user-request/$owner');
      http.Response response = await http.post(url, headers: headers);
      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          "Requested to Worker",
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Message',
          jsonDecode(response.body)['message'],
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      Get.snackbar(
        'Message',
        json.decode(e.toString())['error'],
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
      return false;
    }
  }

  Future<bool> isHistory(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var headers = {'Authorization': 'Bearer $token'};
      var url = Uri.parse('$uri/users/ishistory/$id');
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return false;
      }
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
      return false;
    }
  }

  // review a user /users/review/:id
  Future<void> reviewAworker(String id) async {
    try {
      if (rating.text.isEmpty || comment.text.isEmpty) {
        Get.snackbar(
          'Message',
          'Please fill in all the fields',
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );
        return;
      }
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      var url = Uri.parse('$uri/users/review/$id');
      Map body = {
        'rating': rating.text,
        'comment': comment.text,
      };
      http.Response response =
          await http.post(url, body: jsonEncode(body), headers: headers);
      if (response.statusCode == 201) {
        Get.snackbar(
          'Message',
          'SuccessFully Reviewed',
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );
        Get.offAll(() => const Home());
        comment.clear();
        rating.clear();
      } else {
        Get.snackbar(
          'Message',
          jsonDecode(response.body)['message'],
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
}

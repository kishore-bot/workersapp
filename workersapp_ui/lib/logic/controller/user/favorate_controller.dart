import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../global vriables/global_variables.dart';
import '../../models/workers_model.dart';

class FavorateController extends GetxController {
  var isLoading = false.obs;
  List<WorkersModel> _workersList = []; // use the WorkersModel

  List<WorkersModel> get workersList => _workersList;

  @override
  void onClose() {
    super.onClose();
    _workersList.clear();
  }

  Future<void>fetchFavList() async {
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var response = await http.get(
        Uri.parse('$uri/user-fav'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        _workersList = List<WorkersModel>.from(jsonData.map((data) =>
            WorkersModel.fromJson(data))); // use WorkersModel.fromJson
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

  Future<bool> postFav(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var headers = {'Authorization': 'Bearer $token'};
      var url = Uri.parse('$uri/user-fav/$id');
      http.Response response = await http.post(url, headers: headers);
      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          "Added SuccesFully",
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );

        return true;
      }
      Get.snackbar(
        'Message',
        "Already in your fav list",
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
      return false; // Add this line
    }
  }

  Future<bool> deleteFav(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var headers = {'Authorization': 'Bearer $token'};
      var url = Uri.parse('$uri/user-fav/$id');
      http.Response response = await http.delete(url, headers: headers);
      if (response.statusCode == 201) {
        Get.snackbar(
          'Success',
          "Removed SuccessFully",
          duration: const Duration(seconds: 3),
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.grey[700],
          colorText: Colors.white,
        );
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
      return true;
    }
  }

  Future<bool> isFav(String id) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var headers = {'Authorization': 'Bearer $token'};
      var url = Uri.parse('$uri/users/isfav/$id');
      http.Response response = await http.get(url, headers: headers);
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
      return false; // Add this line
    }
  }
}

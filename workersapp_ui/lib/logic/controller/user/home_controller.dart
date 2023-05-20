import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../global vriables/global_variables.dart';
import '../../models/workers_model.dart';

class HomeController extends GetxController {
  var isLoading = false.obs;
  List<WorkersModel> _workersList = []; // use the WorkersModel
  List<WorkersModel> get workersList => _workersList;

  @override
  void onInit() {
    super.onInit();
    fetchWorkersData();
  }

  @override
  void onClose() {
    super.onClose();
    _workersList.clear();
  }

  // for Workers screen
  fetchWorkersData() async {
    // make it return a Future<void>
    try {
      isLoading(true);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var response = await http.get(
        Uri.parse('$uri/users/home'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is List) {
          _workersList = jsonData
              .map((data) => WorkersModel.fromJson(data))
              .toList();
        }
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
}

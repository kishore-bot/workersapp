import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../global vriables/global_variables.dart';
import '../../models/workers_model.dart';

class SearchingController extends GetxController {
  TextEditingController queryController = TextEditingController();

  var isLoading = false.obs;
  List<WorkersModel> _workersList = [];

  List<WorkersModel> get workersList => _workersList;
  @override
  void onClose() {
    // queryController.removeListener(searchWorkers);
    super.onClose();
  }

  Future<void> searchWorkers() async {
    try {
      if (queryController.text.isEmpty) {
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
      isLoading(true);
      workersList.clear();
      String query = queryController.text;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');
      var response = await http.get(
        Uri.parse('$uri/search?q=$query'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData == null || jsonData.isEmpty) {
          throw Exception('No match found');
        }

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
      queryController.clear;
      isLoading(false);
    }
  }
}

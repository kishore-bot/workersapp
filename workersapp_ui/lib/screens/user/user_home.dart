import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workersapp_ui/screens/user/details.dart';

import '../../logic/controller/user/home_controller.dart';
import '../../widgets/page_container.dart';

class UserHome extends StatefulWidget {
  const UserHome({super.key});

  @override
  State<UserHome> createState() => _UserHomeState();
}

class _UserHomeState extends State<UserHome> {
  final HomeController userController = Get.put(HomeController());

  Future<void> _refresh() async {
    await userController.fetchWorkersData();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: Obx(
        () => userController.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: userController.workersList.length,
                itemBuilder: (BuildContext context, int index) {
                  final home = userController.workersList[index];
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => DetailsPage(home: home));
                    },
                    child: PageContainer(
                      home: home,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

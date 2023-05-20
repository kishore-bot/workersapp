import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workersapp_ui/logic/controller/labour/laour_controller.dart';
import 'package:workersapp_ui/screens/labour/labour_detailed_screen.dart';

import '../../widgets/labour_page_container.dart';

class LabourRequestedScreen extends StatefulWidget {
  const LabourRequestedScreen({super.key});

  @override
  State<LabourRequestedScreen> createState() => _LabourRequestedScreenState();
}

class _LabourRequestedScreenState extends State<LabourRequestedScreen> {
  final LabourController userController = Get.put(LabourController());

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    await userController.fetchRequests();
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
                itemCount: userController.labourReqHistory.length,
                itemBuilder: (BuildContext context, int index) {
                  final home = userController.labourReqHistory[index].user;
                  return GestureDetector(
                    onTap: () {
                      Get.to(
                        () => LabourDetailedScreen(
                          home: home,
                        ),
                      );
                    },
                    child: LabourPageContainer(
                      home: home,
                    ),
                  );
                },
              ),
      ),
    );
  }
}

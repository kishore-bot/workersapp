import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workersapp_ui/logic/controller/labour/laour_controller.dart';
import 'package:workersapp_ui/widgets/labour_page_container.dart';

import '../../widgets/buttion.dart';

class LabourAcceptedScreen extends StatefulWidget {
  const LabourAcceptedScreen({super.key});

  @override
  State<LabourAcceptedScreen> createState() => _LabourAcceptedScreenState();
}

class _LabourAcceptedScreenState extends State<LabourAcceptedScreen> {
  final LabourController userController = Get.put(LabourController());
  bool color = false;

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    await userController.acceptedRequests();
  }

  Future<void>_accept(String id)async{
    await userController.finishWork( id);
    setState(() {
      _refresh();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
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
                    return SizedBox(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          LabourPageContainer(home: home),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: Button(
                              clr: const Color.fromARGB(255, 93, 106, 114),
                              onPressed: () {
                                _accept(home.id);
                              },
                              text: "Finish Work",
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

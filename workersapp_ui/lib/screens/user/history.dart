import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workersapp_ui/screens/user/review_screen.dart';

import '../../logic/controller/user/request_controller.dart';
import '../../widgets/buttion.dart';
import '../../widgets/page_container.dart';

class History extends StatefulWidget {
  const History({Key? key}) : super(key: key);

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final RequestController userController = Get.put(RequestController());
  bool color = false;

  @override
  void initState() {
    super.initState();
    userController.fetchHistory();
  }

  Future<void> _refresh() async {
    await userController.fetchHistory();
  }

  bool _request(bool status, String id) {
    if (status) {
      userController.requestWorker(id);
      return true; // return true for green color
    } else {
      Get.snackbar(
        'Message',
        'Your Request is pending',
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    }
    return false; // return false for red color
  }

  void _review(final home, bool reqclr) {
    if (reqclr) {
      Get.to(
        () => ReviewScreen(
          home: home,
        ),
      );
    } else {
      Get.snackbar(
        'Message',
        'Your request need to finish first',
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    }
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
                  itemCount: userController.historyList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final home = userController.historyList[index];
                    bool reqclr;
                    bool isGreen =
                        false; // initialize isGreen variable to false
                    if (home.status == 1 || home.status == 3) {
                      reqclr = true;
                      isGreen = true; // set isGreen to true for green color
                    } else {
                      reqclr = false;
                    }
                    return SizedBox(
                      height: 250,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          PageContainer(home: home),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: 200,
                                height: 30,
                                child: Button(
                                  onPressed: () {
                                    setState(() {
                                      isGreen = _request(reqclr, home.id);
                                    });
                                  },
                                  text: "Request Again",
                                  clr: isGreen
                                      ? const Color.fromARGB(255, 93, 106, 114)
                                      : Colors
                                          .red, // use isGreen variable to set button color
                                ),
                              ),
                              SizedBox(
                                width: 90,
                                height: 30,
                                child: Button(
                                  clr: const Color.fromARGB(255, 93, 106, 114),
                                  onPressed: () {
                                    _review(home, reqclr);
                                  },
                                  text: "Review",
                                ),
                              ),
                            ],
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

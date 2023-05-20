import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workersapp_ui/logic/controller/labour/laour_controller.dart';
import 'package:workersapp_ui/widgets/buttion.dart';

class LabourDetailedScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final home;
  const LabourDetailedScreen({super.key, this.home});

  @override
  State<LabourDetailedScreen> createState() => _LabourDetailedScreenState();
}

class _LabourDetailedScreenState extends State<LabourDetailedScreen> {
  final LabourController labour = Get.put(LabourController());
  late Future<int> clr;
  RxInt no = (-1).obs;

  @override
  void initState() {
    super.initState();
    clr = labour.isRequested(widget.home.id);
    clr.then(
      (value) {
        setState(
          () {
            no.value = value;
          },
        );
      },
    );
  }

  void changeStatus(String id, int status) {
    if (no.value == 0) {
      if (status == 1) {
        no.value=1;
        labour.acceptOrReject(id, status) as Future<int>;
      } else {
        no.value=2;
        labour.acceptOrReject(id, status) as Future<int>;
      }
    } else {
      Get.snackbar(
        'Error',
        "You Aleady changed Status",
        duration: const Duration(seconds: 3),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.grey[700],
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    var home = widget.home;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          backgroundColor: const Color.fromARGB(255, 135, 137, 145),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 50,
            width: 150,
            child: Obx(
              () => Button(
                onPressed: () {
                  changeStatus(home.id, 1);
                },
                clr: no.value == 1
                    ? Colors.green
                    : const Color.fromARGB(255, 93, 106, 114),
                text: "Accept",
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: 150,
            child: Obx(
              () => Button(
                onPressed: () {
                  changeStatus(home.id, 1);
                },
                clr: no.value == 2
                    ? const Color.fromARGB(255, 233, 9, 147)
                    : const Color.fromARGB(255, 93, 106, 114),
                text: "Reject",
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: const Color.fromARGB(255, 175, 193, 207),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: const Offset(4, 6),
                        ),
                      ],
                    ),
                    height: 250,
                    width: 300,
                    child: Image.memory(
                      home.avatar!,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width - 20,
                        margin: const EdgeInsets.all(10),
                        height: 300,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(10),
                          ),
                          color: const Color.fromARGB(255, 156, 167, 173),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(4, 6),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  "Details",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.bold,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                Text(
                                  "Name: ${home.name}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Phone NO: ${home.phoneNo}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Email: ${home.email}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Street: ${home.street}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Address: ${home.address}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

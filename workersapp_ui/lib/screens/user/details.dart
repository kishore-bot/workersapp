import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../logic/controller/user/favorate_controller.dart';
import '../../logic/controller/user/home_controller.dart';
import '../../logic/controller/user/request_controller.dart';
import '../../widgets/buttion.dart';

// ignore: must_be_immutable
class DetailsPage extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final home;

  const DetailsPage({Key? key, required this.home}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  final FavorateController favorateController = Get.put(FavorateController());

  final HomeController userController = Get.put(HomeController());

  final RequestController requestController = Get.put(RequestController());

  RxBool isExist = false.obs;

  RxBool isRequest = false.obs;

  @override
  void initState() {
    super.initState();
    _loadBeforeScreen();
  }

  void _loadBeforeScreen() async {
    bool isFavorite = await favorateController.isFav(widget.home.id);
    bool isHistory = await requestController.isHistory(widget.home.id);
    setState(() {
      isExist.value = isFavorite;
      isRequest.value = isHistory;
    });
  }

  void _changeFav(String id) async {
    if (isExist.value == true) {
      bool result = await favorateController.postFav(id);
      isExist.value = result;
    } else {
      bool result = await favorateController.deleteFav(id);
      isExist.value = result;
    }
  }

  void _request(String owner) async {
    if (isRequest.value != true) {
      bool result = await requestController.requestWorker(owner);
      isRequest.value = result;
    } else {
      Get.snackbar(
        'Warning',
        'You Request Is Still In Pending List ',
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
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () async {
              _changeFav(home.id);
            },
            child: Obx(
              () => (isExist.value == true)
                  ? const Icon(
                      Icons.favorite,
                      color: Color.fromARGB(255, 93, 106, 114),
                    )
                  : const Icon(
                      Icons.favorite,
                      color: Colors.green,
                    ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 200,
            height: 50,
            child: Obx(
              () => Button(
                  clr: (isRequest.value == false)
                      ? Colors.green
                      : const Color.fromARGB(255, 93, 106, 114),
                  onPressed: () {
                    _request(home.id);
                  },
                  text: "Request"),
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
                                  "Expertee: ${home.specialization}",
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
                                  "PhonNo: ${home.phoneNo}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Salary: ${home.salary}",
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "Experience: ${home.experience}",
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
                      const Text(
                        "Review Of Users",
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0)),
                      ),
                      Text(
                        "Average Rating ${home.avgRating}",
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 12, 12, 11)),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 300,
                        child: ListView.builder(
                          itemCount: home.reviews.length,
                          itemBuilder: (BuildContext context, int index) {
                            final review = home.reviews![index];
                            return Container(
                              width: MediaQuery.of(context).size.width - 20,
                              margin: const EdgeInsets.all(10),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Reviwed By: ${review.name}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      SizedBox(
                                        width: 300,
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            "Comment: ${review.comment}",
                                            style:
                                                const TextStyle(fontSize: 16),
                                          ),
                                        ),
                                      ),
                                      Text(
                                        "Rating out of 5: ${review.rating}",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
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

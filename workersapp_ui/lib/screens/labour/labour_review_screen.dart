import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../logic/controller/labour/laour_controller.dart';

class LabourReviewScreen extends StatefulWidget {
  const LabourReviewScreen({super.key});

  @override
  State<LabourReviewScreen> createState() => _LabourReviewScreenState();
}

class _LabourReviewScreenState extends State<LabourReviewScreen> {
  final LabourController userController = Get.put(LabourController());

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  Future<void> _refresh() async {
    await userController.labourReview();
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
                itemCount: userController.review.length,
                itemBuilder: (BuildContext context, int index) {
                  final review = userController.review[index];
                  return Container(
                    margin: const EdgeInsets.all(10),
                    width: 400,
                    height: 150,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                      color: Color.fromARGB(255, 156, 167, 173),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name: ${review.name}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              review.email,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Rating ${review.rating}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "Comment: ${review.comment}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
    );
  }
}

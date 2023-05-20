import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../logic/controller/user/favorate_controller.dart';
import '../../widgets/buttion.dart';
import '../../widgets/page_container.dart';

class FavScreen extends StatefulWidget {
  const FavScreen({super.key});

  @override
  State<FavScreen> createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  final FavorateController userController = Get.put(FavorateController());
  Future<void> _refresh() async {
    await userController.fetchFavList();
  }

  @override
  void initState() {

    super.initState();
    _refresh();
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
                  itemCount: userController.workersList.length,
                  itemBuilder: (BuildContext context, int index) {
                    final home = userController.workersList[index.toInt()];
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
                                width: 130,
                                height: 30,
                                child: Button(
                                  clr: const Color.fromARGB(255, 93, 106, 114),
                                  onPressed: () {
                                    userController.deleteFav(home.id);
                                    setState(() {
                                      _refresh();
                                    });
                                  },
                                  text: "Remove",
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

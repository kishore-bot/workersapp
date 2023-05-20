import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workersapp_ui/screens/user/details.dart';
import '../../logic/controller/user/search_controller.dart';
import '../../widgets/page_container.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final FocusNode _focusNode = FocusNode();

  final SearchingController searchController = Get.put(SearchingController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          title: SizedBox(
            height: 50,
            width: 300,
            child: Card(
              elevation: 1,
              color: const Color.fromARGB(255, 93, 106, 114),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextFormField(
                focusNode: _focusNode,
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    contentPadding: EdgeInsets.all(5),
                    hintText: "Search Here"),
                controller: searchController.queryController,
                onEditingComplete: () {
                  searchController.searchWorkers();
                  setState(() {
                    _focusNode.unfocus();
                    searchController.queryController.clear();
                  });
                  

                },
              ),
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 135, 137, 145),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Expanded(
              child: Obx(
                () => searchController.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        itemCount: searchController.workersList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final workers = searchController.workersList[index];
                          return GestureDetector(
                            onTap: () => {
                              Get.to(
                                () => DetailsPage(home: workers),
                              ),
                            },
                            child: PageContainer(home: workers),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

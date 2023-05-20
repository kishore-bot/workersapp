import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workersapp_ui/screens/labour/labour_accepted_screen.dart';
import 'package:workersapp_ui/screens/labour/labour_account_screen.dart';
import 'package:workersapp_ui/screens/labour/labour_requested_screen.dart';

import '../../logic/controller/labour/laour_controller.dart';

class LabourHomeScreen extends StatefulWidget {
  const LabourHomeScreen({super.key});

  @override
  State<LabourHomeScreen> createState() => _LabourHomeScreenState();
}

class _LabourHomeScreenState extends State<LabourHomeScreen> {
  final LabourController worker=Get.put(LabourController());

  Uint8List? _imageBytes;

  final RxInt _selectedindex = 0.obs;
  final List<Widget> _pages = [
    const LabourRequestedScreen(),
    const LabourAcceptedScreen(),
    const LabourRequestedScreen()
  ];

  String? name;
  @override
  void initState() {
    super.initState();
    worker.userName().then((_) {
      setState(() {
        name = worker.str;
      });
    });
    worker.fetchAvatarImage().then((bytes) {
      setState(() {
        _imageBytes = bytes;
      });
    });
  }

  void _navigateBottomBar(int idx) {
    setState(() {
      _selectedindex.value = idx;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: AppBar(
          title: Text(
            "Hey $name",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 37, 40, 48),
              shadows: [
                Shadow(
                  offset: Offset(.5, 1),
                  blurRadius: 1,
                  color: Color.fromARGB(255, 37, 40, 48),
                ),
              ],
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 135, 137, 145),
          actions: [
            GestureDetector(
              onTap: () => {Get.to(() => const LabourAccountScreen())},
              child: CircleAvatar(
                radius: 16,
                backgroundImage:
                    _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              ),
            ),
            const SizedBox(
              width: 10,
            )
          ],
        ),
      ),
      body: _pages[_selectedindex.value],
      bottomNavigationBar: Obx(
        () => NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: Colors.blue.shade200,
            labelTextStyle: MaterialStateProperty.all(
              const TextStyle(
                color: Color.fromARGB(255, 49, 54, 59),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          child: NavigationBar(
            height: 70,
            backgroundColor: const Color.fromARGB(255, 135, 137, 145),
            selectedIndex: _selectedindex.value,
            onDestinationSelected: _navigateBottomBar,
            destinations: const [
              NavigationDestination(icon: Icon(Icons.request_page_outlined), label: "Rquests"),
              NavigationDestination(
                  icon: Icon(Icons.favorite), label: "Accepted"),
              NavigationDestination(icon: Icon(Icons.reviews), label: "Review"),
            ],
          ),
        ),
      ),
    );
  }
}

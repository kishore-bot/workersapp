import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:workersapp_ui/screens/user/account.dart';
import 'package:workersapp_ui/screens/user/history.dart';
import 'package:workersapp_ui/screens/user/search_screen.dart';
import 'package:workersapp_ui/screens/user/user_home.dart';

import '../../logic/controller/user/user_me.dart';
import 'fav_screen.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final UserDetails user = Get.put(UserDetails());

  Uint8List? _imageBytes;

  final RxInt _selectedindex = 0.obs;
  final List<Widget> _pages = [
    const UserHome(),
    const FavScreen(),
    const History()
  ];

  String? name;
  @override
  void initState() {
    super.initState();
    user.userName().then((_) {
      setState(() {
        name = user.str;
      });
    });
    user.fetchAvatarImage().then((bytes) {
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
              onTap: () => {Get.to(() => const Account())},
              child:  CircleAvatar(
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
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromARGB(255, 135, 137, 145),
        onPressed: () {
          Get.to(() => const SearchScreen());
        },
        child: const Icon(Icons.search),
      ),
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
              NavigationDestination(icon: Icon(Icons.home), label: "Home"),
              NavigationDestination(
                  icon: Icon(Icons.favorite), label: "Favorite"),
              NavigationDestination(
                  icon: Icon(Icons.history), label: "History"),
            ],
          ),
        ),
      ),
    );
  }
}

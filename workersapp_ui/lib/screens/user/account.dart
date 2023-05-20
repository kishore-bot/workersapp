import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../logic/controller/user/user_me.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final UserDetails userDetails = Get.put(UserDetails());

  Uint8List? _imageBytes;

  @override
  void initState() {
    super.initState();
    userDetails.fetchMe();
    userDetails.fetchAvatarImage().then((bytes) {
      setState(() {
        _imageBytes = bytes;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 30,
        backgroundColor: const Color.fromARGB(255, 135, 137, 145),
      ),
      body: SafeArea(
        top: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  maxRadius: 90,
                  backgroundColor: const Color.fromARGB(255, 175, 193, 207),
                  child: CircleAvatar(
                    radius: 80,
                    foregroundImage:
                        _imageBytes != null ? MemoryImage(_imageBytes!) : null,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              margin: const EdgeInsets.all(10),
              padding: const EdgeInsets.all(20),
              width: MediaQuery.of(context).size.width - 20,
              height: 300,
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
              child: Obx(
                () => userDetails.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Hey !${userDetails.userModel.name}",
                            style: const TextStyle(
                                fontSize: 30, fontWeight: FontWeight.w800),
                          ),
                          Text(
                            userDetails.userModel.email,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "Phone No : ${userDetails.userModel.phoneN}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "Street: ${userDetails.userModel.street}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          Text(
                            "Address: ${userDetails.userModel.address}",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          GestureDetector(
                            onTap: () {
                              userDetails.logout();
                            },
                            child: const Row(
                              children: [
                                Text(
                                  "Logout ",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w400),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Icon(Icons.exit_to_app_outlined),
                              ],
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

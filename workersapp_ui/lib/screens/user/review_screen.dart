import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../logic/controller/user/request_controller.dart';
import '../../widgets/buttion.dart';

class ReviewScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final home;
  const ReviewScreen({
    super.key, this.home,
  });

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final FocusNode _focusNode = FocusNode();
  RequestController reviewController = Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
        backgroundColor: const Color.fromARGB(255, 135, 137, 145),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Review ${widget.home.name}",
                  style: const TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 37, 40, 48),
                    shadows: [
                      Shadow(
                        offset: Offset(.5, 1),
                        blurRadius: 4,
                        color: Color.fromARGB(255, 37, 40, 48),
                      ),
                    ],
                  ),
                ),const SizedBox(height: 20,),
                SizedBox(
                  height: 100,
                  width: 300,
                  child: Card(
                    elevation: 1,
                    color: const Color.fromARGB(255, 93, 106, 114),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      textAlignVertical: TextAlignVertical.center,
                      maxLines: 5,
                      minLines: 1,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.comment_bank_outlined),
                          contentPadding: EdgeInsets.all(5),
                          hintText: "Enter the comment"),
                      controller: reviewController.comment,
                      onEditingComplete: () {
                        setState(() {
                          _focusNode.unfocus();
                        });
                      },
                    ),
                  ),
                ),const SizedBox(height: 20,),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: Card(
                    elevation: 1,
                    color: const Color.fromARGB(255, 93, 106, 114),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      textAlignVertical: TextAlignVertical.center,
                      maxLines: 1,
                      minLines: 1,
                      focusNode: _focusNode,
                      decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(Icons.star_border_purple500),
                          contentPadding: EdgeInsets.all(5),
                          hintText: "Enter the Rating"),
                      controller: reviewController.rating,
                      onEditingComplete: () {
                        setState(() {
                          _focusNode.unfocus();
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: 200,
                  height: 50,
                  child: Button(
                    clr: const Color.fromARGB(255, 93, 106, 114),
                      onPressed: () {
                        setState(() {
                          reviewController.comment.clear();
                          reviewController.rating.clear();
                        });
                        reviewController.reviewAworker(widget.home.id);
                      },
                      text: "Done"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

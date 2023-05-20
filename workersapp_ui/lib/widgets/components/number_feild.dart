import 'package:flutter/material.dart';
import 'package:workersapp_ui/widgets/string_extention.dart';

class NumberFeild extends StatelessWidget {
  final TextEditingController textEditingController;
  const NumberFeild({super.key, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 300,
      child: Card(
        elevation: 1,
        color: const Color.fromARGB(255, 93, 106, 114),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextFormField(
          keyboardType: TextInputType.number,
          validator: (s) {
            if (s!.isValidInt()) {
              return "This is a required feild";
            }
            return null;
          },
          textAlignVertical: TextAlignVertical.center,
          decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.phone_android),
              contentPadding: EdgeInsets.all(5),
              hintText: "Phone  No"),
          controller: textEditingController,
        ),
      ),
    );
  }
}

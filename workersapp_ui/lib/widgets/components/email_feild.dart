import 'package:flutter/material.dart';
import 'package:workersapp_ui/widgets/string_extention.dart';

class EmailFeild extends StatelessWidget {
  final TextEditingController textEditingController;
  const EmailFeild({super.key, required this.textEditingController});

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
          validator: (s) {
            if (s!.emailValid() && s.isWhitespace()) {
              return "This is a required feild";
            }
            return null;
          },
          textAlignVertical: TextAlignVertical.center,
          decoration: const InputDecoration(
              border: InputBorder.none,
              prefixIcon: Icon(Icons.email_sharp),
              contentPadding: EdgeInsets.all(5),
              hintText: "Rollx@gmail.com"),
          controller: textEditingController,
        ),
      ),
    );
  }
}
//       



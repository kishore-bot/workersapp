import 'package:flutter/material.dart';
import 'package:workersapp_ui/widgets/string_extention.dart';

class TextInputField extends StatelessWidget {
  final String hinttext;
  final IconData icon;
  final TextEditingController textEditingController;
  const TextInputField({
    super.key,
    required this.textEditingController,
    required this.hinttext,
    required this.icon,
  });

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
            if (s!.isWhitespace()) {
              return "This is a required feild";
            }
            return null;
          },
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(icon),
            contentPadding: const EdgeInsets.all(5),
            hintText: hinttext,
          ),
          controller: textEditingController,
        ),
      ),
    );
  }
}

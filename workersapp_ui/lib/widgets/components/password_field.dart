import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:workersapp_ui/widgets/string_extention.dart';

class PasswordField extends StatelessWidget {
  final TextEditingController textEditingController;
  final obscuredPassword = true.obs;

  PasswordField({Key? key, required this.textEditingController,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => SizedBox(
        height: 60,
        width: 300,
        child: Card(
          elevation: 1,
          color: const Color.fromARGB(255, 93, 106, 114),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          child: TextFormField(
            obscureText: obscuredPassword.value,
            keyboardType: TextInputType.visiblePassword,
            validator: (s) {
              if (s!.isWhitespace()) {
                return "This is a required field";
              }
              return null;
            },
            controller: textEditingController,
            textAlignVertical: TextAlignVertical.center,
            decoration:  InputDecoration(
              border: InputBorder.none,
              prefixIcon: const Icon(Icons.password_outlined),
              suffixIcon: IconButton(
                onPressed: () => obscuredPassword.toggle(),
                icon: Icon(
                  obscuredPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off_outlined,
                ),
                color: const Color.fromARGB(255, 137, 146, 158),
              ),
              contentPadding: const EdgeInsets.all(5),
              hintText: "Password",
            ),
          ),
        ),
      ),
    );
  }
}

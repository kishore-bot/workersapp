import 'package:flutter/material.dart';

class MyInputTheme{

  OutlineInputBorder _buildBorder(Color color){
    return OutlineInputBorder(
      borderRadius: const BorderRadius.all(Radius.circular(8)),
      borderSide: BorderSide(
        color: color,
        width: 1.5,
      )
    );
  }

  InputDecorationTheme theme()=> InputDecorationTheme(
    // border
    contentPadding: const EdgeInsets.all(16),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    constraints: const BoxConstraints(maxWidth: 150),
    enabledBorder: _buildBorder(Colors.grey[600]!),
    errorBorder: _buildBorder(Colors.red),
    focusedErrorBorder: _buildBorder(Colors.red),
    border: _buildBorder(Colors.yellow),
    focusedBorder: _buildBorder(Colors.blue),
    disabledBorder: _buildBorder(Colors.grey[300]!),

    // text

  );
}

// https://www.youtube.com/watch?v=H2xNq5ph8OE
import 'package:e_commerce_foods/global/global.dart';
import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  final int lines;
  final bool? readOnly;
  final int maxLength;
  final type;

  MyTextField(
      {this.hint,
      this.controller,
      this.obscureText = false,
      this.lines = 1,
      this.maxLength = 50,
      this.readOnly,
      this.type});

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: Global.style(
        size: 16,
      ),
      maxLines: lines,
      controller: controller,
      obscureText: obscureText,
      cursorColor: Colors.white,
      readOnly: readOnly!,
      keyboardType: type,
      maxLength: maxLength,
      decoration: InputDecoration(
        hintStyle: Global.style(size: 16, color: Colors.white70),
        hintText: hint,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 4)),
      ),
    );
  }
}

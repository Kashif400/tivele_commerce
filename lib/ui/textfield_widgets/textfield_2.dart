import 'package:flutter/material.dart';
import 'package:e_commerce_foods/global/global.dart';

class MyTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController? controller;
  final bool obscureText;
  // final ValueChanged<String> onChanged;

  MyTextField({this.hint, this.controller, this.obscureText = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),
        color: Colors.white,
      ),
      child: TextField(
        style: Global.style(
          size: 16,
          color: Colors.black,
        ),
        controller: controller,
        obscureText: obscureText,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          hintStyle: Global.style(
            size: 16,
            color: Colors.black54,
          ),
          hintText: hint,
          border: InputBorder.none,
        ),
      ),
    );
  }
}

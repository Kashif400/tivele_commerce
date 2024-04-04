//import 'package:flutter/material.dart';
//import 'package:tivele/global/global.dart';
//
//class MyTextField extends StatelessWidget {
//  final String hint;
//  final TextEditingController controller;
//  final bool obscureText;
//  final int lines;
//
//  MyTextField({
//    this.hint,
//    this.controller,
//    this.obscureText = false,
//    this.lines = 1,
//  });
//
//  @override
//  Widget build(BuildContext context) {
//    return TextField(
//      style: Global.style(
//        size: 16,
//        color: Colors.black
//      ),
//      maxLines: lines,
//      controller: controller,
//      obscureText: obscureText,
//      cursorColor: Colors.black,
//      decoration: InputDecoration(
//        hintStyle: Global.style(size: 16, color: Colors.black54),
//        hintText: hint,
//        enabledBorder:
//            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
//        focusedBorder:
//            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
//      ),
//    );
//  }
//}

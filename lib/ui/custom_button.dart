import 'package:flutter/material.dart';
import 'package:tinycolor2/tinycolor2.dart';

class CustomButton extends StatelessWidget {
  final ButtonCallBack? onPressed;
  final Widget? child;
  final Color? color;
  CustomButton({this.onPressed, this.child, this.color});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: () => this.onPressed!(),
      height: 45.0,
      minWidth: 64.0,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      color: this.color,
      child: this.child,
      splashColor: TinyColor(this.color!).lighten(5).color,
    );
  }
}

typedef ButtonCallBack = void Function();

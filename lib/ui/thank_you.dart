import 'package:e_commerce_foods/global/global.dart';
import 'package:flutter/material.dart';

import 'home/home_user.dart';

class ThankYou extends StatefulWidget {
  final int? ref;
  ThankYou({Key? key, required this.ref}) : super(key: key);
  @override
  _ThankYouState createState() => _ThankYouState(ref);
}

class _ThankYouState extends State<ThankYou> {
  int? referenceId;
  _ThankYouState(this.referenceId);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            'TIVELE',
            style: Global.style(
              bold: true,
              size: 22,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(32),
          width: double.infinity,
          child: Column(
            children: [
              Text(
                'Your Purchase was Successful',
                style: Global.style(
                  size: 16,
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Icon(
                Icons.info_outline,
                color: Colors.white,
                size: 28,
              ),
              Spacer(),
              Text(
                'THANK YOU!',
                style: Global.style(
                  bold: true,
                  size: 24,
                ),
              ),
              Spacer(),
              Text(
                'Reference Number: $referenceId',
                style: Global.style(),
              ),
              TextButton(
                child: Text(
                  'Go Home',
                  style: TextStyle(
                    color: Colors.white,
                    decoration: TextDecoration.underline,
                    fontSize: 19,
                  ),
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => HomeUser(),
                    ),
                    (_) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

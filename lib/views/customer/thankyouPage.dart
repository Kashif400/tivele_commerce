import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/views/customer/customerHomePage.dart';

class ThankyouPage extends StatefulWidget {
  @override
  _ThankYouState createState() => _ThankYouState();
}

class _ThankYouState extends State<ThankyouPage> {
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
                Icons.download_done_outlined,
                color: Colors.white,
                size: 40,
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
                'Reference Number: U1274548969',
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
                  Get.offAll(CustomerHomePage());
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/global/videos.dart';
import 'package:e_commerce_foods/views/business/businessProfilePage.dart';
import 'package:e_commerce_foods/views/customer/customerHomePage.dart';
import 'package:e_commerce_foods/views/customer/customerLoginPage.dart';
import 'package:e_commerce_foods/views/driver/driverHomePage.dart';
import 'package:video_player/video_player.dart';

class SplashPage extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<SplashPage> {
  late VideoPlayerController _controller;

  get result => null;

  @override
  void initState() {
    super.initState();
    int number = Random().nextInt(9);

    _controller = VideoPlayerController.asset(videos[number])
      ..initialize().then(
        (_) {
          _controller.play();
          _controller.setLooping(false);
          _controller.setVolume(0);
          setState(() {});
        },
      );

    Timer(
      Duration(
        seconds: 5,
      ),
      () => _controller.pause(),
    );
    Timer(
        Duration(
          seconds: 5,
        ), () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool status = false;
      String? userType = prefs.getString('user_type');
      status = prefs.getBool('loggedIn') ?? false;
      print(status);
      if (userType == "business" && status) {
        Get.offAll(BusinessProfilePage());
      } else if (userType == "user" && status) {
        Get.offAll(CustomerHomePage());
      } else if (userType == "driver" && status) {
        Get.offAll(DriverHomePage());
      } else {
        Get.offAll(CustomerLoginPage());
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.fill,
                child: SizedBox(
                  width: _controller.value.size?.width ?? 0,
                  height: _controller.value.size?.height ?? 0,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            Container(
              height: double.infinity,
              width: double.infinity,
              color: Colors.black.withOpacity(
                0.6,
              ),
            ),
            Center(
              child: Text(
                'TIVELE',
                style: Global.style(
                  bold: true,
                  size: 36,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

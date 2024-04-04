import 'dart:async';
import 'dart:math';

import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/global/videos.dart';
import 'package:e_commerce_foods/service/token_auth/token_auth_service.dart';
import 'package:e_commerce_foods/views/customer/customerRegistrationPage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'home/home_user.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
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
      prefs.clear();
      bool status = false;
      String? userType = prefs.getString('user_type');

      status = prefs.getBool('loggedIn') ?? false;
      print(status.toString() + "asd");
      if (status != null && status) {
        /*status != null && status*/
        var account = {
          'password': prefs.getString('PASSWORD_USER'),
          'userNameOrEmailAddress': prefs.getString('EMAIL_USER'),
          'rememberClient': true
        };
        var loginRes = await TokenAuthService.authenticate(account);
        if (loginRes) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => HomeUser(),
            ),
            (_) => false,
          );
        } else {
          Get.offAll(CustomerRegistrationPage());
        }
      } else {
        print("register123");
        Get.offAll(CustomerRegistrationPage());
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

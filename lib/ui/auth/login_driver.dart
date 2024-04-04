import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/global/videos.dart';
import 'package:e_commerce_foods/service/account/userProfile_service.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/home/home_driver.dart';
import 'package:e_commerce_foods/ui/auth/register_deliver.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_2.dart';
import 'package:video_player/video_player.dart';

class LoginDriver extends StatefulWidget {
  @override
  _LoginDriverState createState() => _LoginDriverState();
}

class _LoginDriverState extends State<LoginDriver> {
  TextEditingController idController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;
  bool remember = false;
  bool isBusy = false;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
//    int number = Random().nextInt(9);

    _controller = VideoPlayerController.asset('assets/videos/video.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.seekTo(
          Duration(seconds: 0),
        );
        _controller.setLooping(false);
        _controller.setVolume(0);
        setState(() {});
      });

//    for (int i = 1; i < 10; i++) {
//      playVideo(i);
//    }
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
        body: ModalProgressHUD(
          child: Stack(
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
                  child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(32),
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyTextField(
                        hint: 'Driver ID',
                        controller: idController,
                        // readOnly: false,
                      ),
                      SizedBox(height: 16),
                      MyTextField(
                        hint: 'Password',
                        controller: passwordController,
                        obscureText: true,
                        // readOnly: false
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Container(
                            height: 24,
                            width: 24,
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                setState(() {
                                  remember = !remember;
                                });
                              },
                              icon: Icon(
                                remember
                                    ? Icons.check_box_outline_blank
                                    : Icons.check_box,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child:
                                Text('Stay Logged In', style: Global.style()),
                          ),
                        ],
                      ),
                      SizedBox(height: 32),
                      ConfirmationSlider(
                        onConfirmation: () {
                          DriverLogin();
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        textStyle: Global.style(
                          color: Colors.black,
                          size: 16,
                        ),
                        text: 'Swipe to Login',
                        height: 50,
                      ),
                      SizedBox(height: 64),
                      Text(
                        'Don\'t have an account?',
                        style: Global.style(),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => RegisterDeliver(),
                            ),
                          );
                        },
                        child: Text(
                          'Apply here',
                          style: Global.style(
                            bold: true,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      loading
                          ? Container(
                              color: Colors.black,
                              child: Center(
                                child: CircularProgressIndicator(
                                  // backgroundColor: Colors.white,
                                  valueColor: new AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                ),
                              ),
                            )
                          : SizedBox(height: 36),
                    ],
                  ),
                ),
              )),
            ],
          ),
          inAsyncCall: isBusy,
          // demo of some additional parameters
          //  opacity: 0.5,
          progressIndicator: Container(
            color: Colors.black,
            constraints: BoxConstraints.expand(),
            child: Center(
              child: Container(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  playVideo(i) {
    int rand = Random().nextInt(9);
    Timer(
      Duration(
        seconds: 5 * i as int,
      ),
      () {
        _controller = VideoPlayerController.asset(videos[rand])
          ..initialize().then((_) {
            _controller.seekTo(
              Duration(seconds: 0),
            );
            _controller.play();
            _controller.setLooping(false);
            _controller.setVolume(0);

            setState(() {});
          });
      },
    );
  }

  DriverLogin() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (idController.text.isEmpty) {
        showErrorToast("Please enter a valid Driver ID");
        return;
      }
      if (passwordController.text.isEmpty) {
        showErrorToast("Please enter password");
        return;
      }
      setState(() {
        //loading = true;
        isBusy = true;
      });
      var driver = {
        "password": passwordController.text,
        "accountId": idController.text,
        "type": 1
      };
      var res = await UserProfileService.accountLogin(driver);
      if (res["isLogin"]) {
        await SessionService.addDriverAccountId(res["accountId"]);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => HomeDriver(),
          ),
          (_) => false,
        );
      } else {
        showErrorToast("Driver ID or Password is invalid");
      }
      setState(() {
        isBusy = false;
      });
    } on SocketException catch (_) {
      showErrorToast("Please check your Internet Connection");
      return false;
    } catch (err) {
      final requestbody = json.decode(err.toString());
      final data = requestbody['error'];
      showErrorToast(data["message"]);
      setState(() {
        isBusy = false;
      });
    }
  }

  void showErrorToast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }
}

import 'dart:io';

import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/service/account/userProfile_service.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/auth/register_business.dart';
import 'package:e_commerce_foods/ui/home/my_profile.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:video_player/video_player.dart';

class LoginBusiness extends StatefulWidget {
  @override
  _LoginBusinessState createState() => _LoginBusinessState();
}

class _LoginBusinessState extends State<LoginBusiness> {
  TextEditingController nameController = TextEditingController();
  TextEditingController AccountIDController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool loading = false;
  bool remember = false;
  bool isBusy = false;
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/video.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(false);
        _controller.setVolume(0);
        setState(() {});
      });
    getCredentials();
  }

  getCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    nameController.text = await prefs.getString("EMAIL_USER")!;
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
                child: Container(
                  padding: EdgeInsets.all(32),
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyTextField(
                          hint: 'Username',
                          controller: nameController,
                        ),
                        SizedBox(height: 16),
                        MyTextField(
                          hint: 'Account ID',
                          controller: AccountIDController,
                        ),
                        SizedBox(height: 16),
                        MyTextField(
                          hint: 'Password',
                          controller: passwordController,
                          obscureText: true,
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
                            BussinessAccountLogin();
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          textStyle: Global.style(
                            color: Colors.black,
                            size: 16,
                          ),
                          height: 50,
                          text: "Swipe to Login",
                        ),
                        Text(
                          'Don\'t have an account?',
                          style: Global.style(),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => RegisterBusiness(),
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
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          color: Colors.black,
          inAsyncCall: isBusy,
          //  opacity: 0.5,
          progressIndicator: Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /* Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                            builder: (_) => HomeBusiness(),
                          ),
                          (_) => false,
                        );
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
                    SizedBox(height: 32),
                    Text(
                      'Don\'t have an account?',
                      style: Global.style(),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => RegisterBusiness(),
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
                        ? CircularProgressIndicator(
                            backgroundColor: Colors.white,
                            valueColor:
                                new AlwaysStoppedAnimation<Color>(Colors.black),
                          )
                        : SizedBox(height: 36),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  BussinessAccountLogin() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (nameController.text.isEmpty) {
        showErrorToast("Please enter Username");
        return;
      }
      if (AccountIDController.text.isEmpty) {
        showErrorToast("Please enter Account ID");
        return;
      }
      if (passwordController.text.isEmpty) {
        showErrorToast("Please enter Password");
        return;
      }
      setState(() {
        loading = true;
      });
      var account = {
        "password": passwordController.text,
        "accountId": AccountIDController.text,
        "type": 0
      };
      setState(() {
        isBusy = true;
      });
      var res = await UserProfileService.accountLogin(account);
      if (res["isLogin"]) {
        await SessionService.addBusinessAccountId(res["accountId"]);
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => MyProfile(res["accountId"]),
          ),
          (_) => false,
        );
      } else {
        showErrorToast("Invalid credentials");
        setState(() {
          isBusy = false;
        });
      }
      setState(() {
        isBusy = false;
      });
    } on SocketException catch (_) {
      showErrorToast("Please check your Internet Connection");
      return false;
    } catch (err) {
      setState(() {
        isBusy = false;
      });
      showErrorToast("Invalid credentials");
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

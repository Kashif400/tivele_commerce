import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:e_commerce_foods/controllers/loginController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/global/videos.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_2.dart';
import 'package:e_commerce_foods/views/business/businessLoginPage.dart';
import 'package:e_commerce_foods/views/customer/customerLoginPage.dart';
import 'package:e_commerce_foods/views/driver/driverRegistrationPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:video_player/video_player.dart';

class DriverLoginPage extends StatefulWidget {
  @override
  _LoginDriverState createState() => _LoginDriverState();
}

class _LoginDriverState extends State<DriverLoginPage> {
  String? _selectedUser = "Driver";
  List usersList = ["Customer", "Business", "Driver"];
  TextEditingController nameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  bool loading = false;
  bool remember = true;
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
    return WillPopScope(
      onWillPop: (() => Get.offAll(DriverRegistrationPage())!
          .then((value) => value as bool)) as Future<bool> Function()?,
      child: SafeArea(
        child: Scaffold(
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
                        Text(
                          'TIVELE',
                          style: Global.style(bold: true, size: 36, caps: true),
                        ),
                        Text(
                          'Login to access your account',
                          style: Global.style(),
                        ),
                        SizedBox(
                          height: 32,
                        ),
                        Container(
                          //margin: EdgeInsets.only(left: 50, right: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(width: 2, color: Colors.white)),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 4)),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                hint: new Text(
                                  "Select Category",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white70),
                                ),
                                underline: Container(
                                  color: Colors.red,
                                ),
                                dropdownColor: Colors.black,
                                iconEnabledColor: Colors.white,
                                isDense: true,
                                items: usersList.map((item) {
                                  return new DropdownMenuItem<String>(
                                    value: item.toString(),
                                    child:
                                        new Text(item, style: Global.style()),
                                  );
                                }).toList(),
                                onChanged: (String? newValueSelected) {
                                  setState(() {
                                    this._selectedUser = newValueSelected;
                                  });
                                  if (newValueSelected == "Customer") {
                                    this._selectedUser = "Driver";
                                    Get.to(CustomerLoginPage());
                                  }
                                  if (newValueSelected == "Business") {
                                    this._selectedUser = "Driver";
                                    Get.to(BusinessLoginPage());
                                  }
                                },
                                value: _selectedUser,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 16),
                        MyTextField(
                          hint: 'Email/ User Name',
                          controller: nameController,
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
                                  print(remember);
                                },
                                icon: Icon(
                                  !remember
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
                        SizedBox(height: 12),
                        Text(
                          'Don\'t have an account?',
                          style: Global.style(),
                        ),
                        InkWell(
                          onTap: () {
                            Get.offAll(DriverRegistrationPage());
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
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
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
            progressIndicator: CircularProgressIndicator(
              backgroundColor: Colors.black.withOpacity(0.9),
              valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
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
      if (nameController.text.isEmpty) {
        showErrorToast("Please enter a valid Driver ID");
        return;
      }
      if (passwordController.text.isEmpty) {
        showErrorToast("Please enter password");
        return;
      }
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        isBusy = true;
      });
      Map<String, Object> userData = {
        'user_type': "driver",
        'password': passwordController.text,
        'email': nameController.text,
      };
      await loginController.fetchLogin(userData, 2, remember);

      setState(() {
        isBusy = false;
      });
    } on SocketException catch (_) {
      showErrorToast("Please check your Internet Connection");
      return false;
    } catch (err) {
      // final requestbody = json.decode(err.body);
      // final data = requestbody['error'];
      // showErrorToast(data["message"]);
      showErrorToast(err.toString());
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

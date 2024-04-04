import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:e_commerce_foods/controllers/loginController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_2.dart';
import 'package:e_commerce_foods/views/business/businessLoginPage.dart';
import 'package:e_commerce_foods/views/customer/customerHomePage.dart';
import 'package:e_commerce_foods/views/customer/customerRegistrationPage.dart';
import 'package:e_commerce_foods/views/driver/driverLoginPage.dart';
import 'package:video_player/video_player.dart';

class CustomerLoginPage extends StatefulWidget {
  @override
  _LoginUserState createState() => _LoginUserState();
}

class _LoginUserState extends State<CustomerLoginPage> {
  String? _selectedUser = "Customer";
  List usersList = ["Customer", "Business", "Driver"];
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final LoginController loginController = Get.put(LoginController());
  void showErrorToast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  bool remember = true;
  bool loading = false;
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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() => Get.offAll(CustomerRegistrationPage())!
          .then((value) => value as bool)) as Future<bool> Function()?,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Obx(() {
            return ModalProgressHUD(
              inAsyncCall: loginController.isLoading.value,
              progressIndicator: CircularProgressIndicator(
                backgroundColor: Colors.black.withOpacity(0.9),
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              color: Colors.black,
              opacity: 0,
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
                              Text(
                                'TIVELE',
                                style: Global.style(
                                    bold: true, size: 36, caps: true),
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
                                    border: Border.all(
                                        width: 2, color: Colors.white)),
                                child: InputDecorator(
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
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
                                          child: new Text(item,
                                              style: Global.style()),
                                        );
                                      }).toList(),
                                      onChanged: (String? newValueSelected) {
                                        setState(() {
                                          this._selectedUser = newValueSelected;
                                        });
                                        if (newValueSelected == "Business") {
                                          this._selectedUser = "Customer";
                                          Get.to(BusinessLoginPage());
                                        }
                                        if (newValueSelected == "Driver") {
                                          this._selectedUser = "Customer";
                                          Get.to(DriverLoginPage());
                                        }
                                      },
                                      value: _selectedUser,
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 32),
                              MyTextField(
                                hint: 'Email / Username',
                                controller: emailController,
                              ),
                              SizedBox(height: 32),
                              MyTextField(
                                hint: 'Password',
                                controller: passwordController,
                                obscureText: true,
                                /*onChanged: (value){
                                                          passwordController.text = value;
                                                        },*/
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
                                    child: Text('Stay Logged In',
                                        style: Global.style()),
                                  ),
                                ],
                              ),
                              SizedBox(height: 32),
                              ConfirmationSlider(
                                onConfirmation: () {
                                  print("swipe to login");
                                  _loginAccount();
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
                                  Get.offAll(CustomerRegistrationPage());
                                },
                                child: Text(
                                  'Apply here',
                                  style: Global.style(
                                    bold: true,
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              //// skip login   buttonnnn /////////////////////////////////////////////////
                              InkWell(
                                onTap: () async {
                                  SharedPreferences prefs =
                                      await SharedPreferences.getInstance();
                                  prefs.setBool("loggedIn", false);
                                  prefs.setString(
                                      "token", globals.authorization);
                                  globals.checkLogin = true;
                                  Get.offAll(CustomerHomePage());
                                },
                                child: Text(
                                  'Skip Login',
                                  style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 20,
                                    letterSpacing: 5,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              SizedBox(height: 30),
                              loading
                                  ? Container(
                                      color: Colors.black,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          backgroundColor: Colors.white,
                                          valueColor:
                                              new AlwaysStoppedAnimation<Color>(
                                                  Colors.black),
                                        ),
                                      ),
                                    )
                                  : SizedBox(height: 36),
                            ],
                          ),
                        )),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Future<void> _loginAccount() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (emailController.text.isEmpty) {
        showErrorToast("Please enter a valid Email or Username");
        return;
      }
      if (passwordController.text.isEmpty) {
        showErrorToast("Please enter Password");
        return;
      }
      setState(() {
        isBusy = true;
      });

      FocusScope.of(context).requestFocus(new FocusNode());
      var userData = {
        'user_type': "user",
        'password': passwordController.text,
        'email': emailController.text,
      };
      await loginController.fetchLogin(userData, 0, remember);
    } on SocketException catch (_) {
      print("Eleyeennnnnnnnn");
      globals.showErrorSnackBar("Check Your Internet Connection!");
      setState(() {
        isBusy = false;
      });
      loginController.isLoading.value = false;
    } catch (err) {
      setState(() {
        isBusy = false;
      });
      print(err);
      loginController.isLoading.value = false;
    }
  }
}

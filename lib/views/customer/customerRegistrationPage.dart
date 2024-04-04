import 'dart:async';
import 'dart:io';

import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/controllers/registrationController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/GlobalProperties/GlobalProperties.dart';
import 'package:e_commerce_foods/service/token_auth/token_auth_service.dart';
import 'package:e_commerce_foods/ui/home/home_user.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_2.dart';
import 'package:e_commerce_foods/views/business/businessRegistrationPage.dart';
import 'package:e_commerce_foods/views/customer/customerLoginPage.dart';
import 'package:e_commerce_foods/views/driver/driverRegistrationPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:video_player/video_player.dart';

class CustomerRegistrationPage extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<CustomerRegistrationPage> {
  String? _selectedUser = "Customer";
  List usersList = ["Customer", "Business", "Driver"];
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  final RegistrationController registrationController =
      Get.put(RegistrationController());
  bool remember = false;
  bool _loading = false;
  String error = "";
  bool isBusy = false;
  late VideoPlayerController controller;
  @override
  void initState() {
    super.initState();
    controller = VideoPlayerController.asset('assets/videos/video.mp4')
      ..initialize().then((_) {
        controller.play();
        controller.setLooping(false);
        controller.setVolume(0);
        setState(() {});
      });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: Obx(() {
            return ModalProgressHUD(
              inAsyncCall: registrationController.isLoading.value,
              //   opacity: 0.5,
              progressIndicator: CircularProgressIndicator(
                backgroundColor: Colors.black.withOpacity(0.9),
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
              ),
              child: Stack(
                children: [
                  SizedBox.expand(
                    child: FittedBox(
                      fit: BoxFit.fill,
                      child: SizedBox(
                        width: controller.value.size?.width ?? 0,
                        height: controller.value.size?.height ?? 0,
                        child: VideoPlayer(controller),
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
                              'Sign up to access your account',
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
                                        Get.offAll(BusinessRegistrationPage());
                                      }
                                      if (newValueSelected == "Driver") {
                                        this._selectedUser = "Customer";
                                        Get.offAll(DriverRegistrationPage());
                                      }
                                    },
                                    value: _selectedUser,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            MyTextField(
                              hint: 'Username',
                              controller: nameController,
                              /*onChanged: (value){
                              nameController.text = value;
                            }*/
                            ),
                            SizedBox(height: 32),
                            MyTextField(
                              hint: 'Email',
                              controller: emailController,
                              /*onChanged: (value){
                                emailController.text = value;
                            }*/
                            ),
                            SizedBox(height: 32),
                            MyTextField(
                              hint: 'Password',
                              controller: passwordController,
                              obscureText: true,
                              /* onChanged: (value){
                                passwordController.text = value;
                              }*/
                            ),
                            SizedBox(height: 32),
                            MyTextField(
                              hint: 'Retype Password',
                              controller: retypePasswordController,
                              obscureText: true,
                            ),
                            SizedBox(height: 32),
                            ConfirmationSlider(
                              onConfirmation: () {
                                _registerAccount();
                              },
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              textStyle: Global.style(
                                color: Colors.black,
                                size: 16,
                              ),
                              text: 'Swipe to Sign Up',
                              height: 50,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'OR',
                              style: Global.style(
                                size: 16,
                              ),
                            ),
                            SizedBox(height: 16),
                            // Row(
                            //   mainAxisAlignment: MainAxisAlignment.center,
                            //   children: [
                            //     Container(
                            //       padding: EdgeInsets.all(10),
                            //       decoration: BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         color: Colors.white,
                            //       ),
                            //       child: IconButton(
                            //         iconSize: 10,
                            //         icon: Icon(FontAwesomeIcons.facebookF,
                            //             color: Colors.black, size: 16),
                            //         onPressed: () {
                            //           _handleFacebookSignUp(context);
                            //         },
                            //       ),
                            //       /*child: FaIcon(
                            //       FontAwesomeIcons.facebookF,
                            //       color: Colors.black,
                            //       size: 16,
                            //     ),*/
                            //     ),
                            //     SizedBox(width: 12),
                            //     Visibility(
                            //       visible: false,
                            //       child: Container(
                            //         padding: EdgeInsets.all(10),
                            //         decoration: BoxDecoration(
                            //           shape: BoxShape.circle,
                            //           color: Colors.white,
                            //         ),
                            //         child: IconButton(
                            //           iconSize: 10,
                            //           icon: Icon(FontAwesomeIcons.instagram,
                            //               color: Colors.black, size: 16),
                            //           onPressed: () {
                            //             _handleFacebookSignUp(context);
                            //           },
                            //         ),
                            //         /*child: FaIcon(
                            //       FontAwesomeIcons.instagram,
                            //       color: Colors.black,
                            //       size: 16,
                            //     ),*/
                            //       ),
                            //     ),
                            //     SizedBox(width: 12),
                            //     Container(
                            //       padding: EdgeInsets.all(8),
                            //       decoration: BoxDecoration(
                            //         shape: BoxShape.circle,
                            //         color: Colors.white,
                            //       ),
                            //       child: IconButton(
                            //         iconSize: 10,
                            //         icon: Icon(FontAwesomeIcons.google,
                            //             color: Colors.black, size: 16),
                            //         onPressed: () {
                            //           _handleGoogleSignUp(context);
                            //           //   signInWithGoogle();
                            //         },
                            //       ),
                            //       /*child: FaIcon(
                            //       FontAwesomeIcons.google,
                            //       color: Colors.black,
                            //       size: 16,
                            //     ),*/
                            //     ),
                            //   ],
                            // ),
                            // SizedBox(height: 16),
                            Text.rich(
                              TextSpan(
                                text: 'Already have an account? ',
                                style: Global.style(
                                  color: Colors.white70,
                                ),
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.to(CustomerLoginPage());
                                      },
                                    text: 'Login',
                                    style: Global.style(
                                      bold: true,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10),
                            _loading
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
                      ),
                    ),
                  ),
                ],
              ),
            );
          })),
    );
  }

  Future<void> _registerAccount() async {
    if (!await validate()) return;
    try {
      FocusScope.of(context).requestFocus(new FocusNode());
      Map<String, Object> userData = {
        'user_type': "user",
        'user_name': nameController.text,
        'password': passwordController.text,
        'email': emailController.text,
      };
      await registrationController.fetchRegistration(userData, 0);
    } catch (err) {
      setState(() {
        isBusy = false;
      });
      showErrorToast("Error occurred while  Sign Up");
      print(err);
    }
    //var names = _fullName.split(' ');
    //var isBroker = context.read<UsersProvider>().newUserIsBroker;
  }

  dynamic validate() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (nameController.text.isEmpty) {
        showErrorToast("Please enter a username");
        return false;
      }
      if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(emailController.text)) {
        showErrorToast("Please enter a valid email");
        return false;
      }
      if (passwordController.text.isEmpty) {
        showErrorToast("Please enter a password");
        return false;
      }
      if (retypePasswordController.text.isEmpty) {
        showErrorToast("Please enter confirm password");
        return false;
      }
      if (retypePasswordController.text != passwordController.text) {
        showErrorToast("Password and confirm password didn't match");
        return false;
      }
      return true;
    } on SocketException catch (_) {
      showErrorToast("Please check your Internet Connection");
      return false;
    } catch (err) {
      // final requestbody = json.decode(err.body);
      // final data = requestbody['error'];
      // showErrorToast(data["message"]);
      showErrorToast(err.toString());
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

  void showSuccessToast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white);
  }

  /*void _registerSuccessful() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => PopUps.confirmationModal(
          context: ctx,
          actionTitle: 'Done',
          action: () => _navigateToLogin(),
          content: Text(
            'Your account has benn Registered with success',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                color: Palette.black,
                fontWeight: FontWeight.bold),
          ),
        ),
        fullscreenDialog: true,
      ),
    );
  }*/
  // Future<void> _handleFacebookSignUp(BuildContext ctx) async {
  //   final facebookLogin = FacebookLogin();
  //   final facebookAuth = await facebookLogin.logIn(['email']);
  //   _loading = true;
  //   switch (facebookAuth.status) {
  //     case FacebookLoginStatus.loggedIn:
  //       final response = await TokenAuthService.externalAuthenticate(
  //           authProvider: 'Facebook',
  //           providerKey: facebookAuth.accessToken.userId,
  //           providerAccessCode: facebookAuth.accessToken.token);
  //       print(response);
  //       if (response) {
  //         GlobalProperties.getProfileImageUrl();
  //         await ctx.read<BusinessUsersProvider>().getCurrentUser();
  //         _loading = false;
  //         Navigator.of(context).pushAndRemoveUntil(
  //           MaterialPageRoute(
  //             builder: (_) => HomeUser(),
  //           ),
  //           (_) => false,
  //         );
  //       }
  //       break;
  //     case FacebookLoginStatus.cancelledByUser:
  //     case FacebookLoginStatus.error:
  //       print(facebookAuth.errorMessage);
  //       print("in error");
  //       Fluttertoast.showToast(
  //           msg: facebookAuth.errorMessage,
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.CENTER,
  //           timeInSecForIosWeb: 1,
  //           backgroundColor: Colors.red,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       break;
  //   }
  // }

  Future<void> _handleGoogleSignUp(BuildContext ctx) async {
    final GoogleSignInAccount googleUser =
        await (_googleSignIn.signIn() as FutureOr<GoogleSignInAccount>);
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final response = await TokenAuthService.externalAuthenticate(
        authProvider: 'Google',
        providerKey: googleUser.id,
        providerAccessCode: googleAuth.accessToken);
    if (response) {
      GlobalProperties.getProfileImageUrl();
      await ctx.read<BusinessUsersProvider>().getCurrentUser();
      _loading = false;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => HomeUser(),
        ),
        (_) => false,
      );
    }
  }
// Future<UserCredential> signInWithGoogle() async {
//   // Trigger the authentication flow
//   final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
//
//   // Obtain the auth details from the request
//   final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//
//   // Create a new credential
//   final credential = GoogleAuthProvider.credential(
//     accessToken: googleAuth.accessToken,
//     idToken: googleAuth.idToken,
//   );
//
//   // Once signed in, return the UserCredential
//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }
}

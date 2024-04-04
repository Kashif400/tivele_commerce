import 'dart:async';
import 'dart:io';

import 'package:e_commerce_foods/controllers/registrationController.dart';
import 'package:e_commerce_foods/controllers/uploadPicController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_2.dart';
import 'package:e_commerce_foods/views/business/businessRegistrationPage.dart';
import 'package:e_commerce_foods/views/customer/customerRegistrationPage.dart';
import 'package:e_commerce_foods/views/driver/driverLoginPage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:video_player/video_player.dart';

class DriverRegistrationPage extends StatefulWidget {
  @override
  _RegisterDeliverState createState() => _RegisterDeliverState();
}

class _RegisterDeliverState extends State<DriverRegistrationPage> {
  final UploadPicController uploadPicController =
      Get.put(UploadPicController());
  final RegistrationController registrationController =
      Get.put(RegistrationController());
  String? _selectedUser = "Driver";
  List usersList = [
    "Customer",
    "Driver"
  ]; //yhan pr add krdena incas eyou want businesss in registration tab
  TextEditingController addressController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailAddressController = TextEditingController();
  final picker = ImagePicker();
  File? _profileImage;
  bool _newProfileImage = false;
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

  void showProductErrorToast(Message) {
    Fluttertoast.showToast(
        msg: Message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
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
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Text(
                          'TIVELE',
                          style: Global.style(bold: true, size: 36, caps: true),
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
                                    Get.offAll(CustomerRegistrationPage());
                                  }
                                  if (newValueSelected == "Business") {
                                    this._selectedUser = "Driver";
                                    Get.offAll(BusinessRegistrationPage());
                                  }
                                },
                                value: _selectedUser,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'First Name',
                          controller: firstNameController,
                          //readOnly: true,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Last Name',
                          controller: lastNameController,
                          //readOnly: true,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'User Name',
                          controller: userNameController,
                          //readOnly: true,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Email Address',
                          controller: emailAddressController,
                          //readOnly: true,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Address',
                          controller: addressController,
                          // readOnly: false,
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: MyTextField(
                                hint: 'City',
                                controller: cityController,
                                // readOnly: false,
                              ),
                            ),
                            SizedBox(
                              width: 4,
                            ),
                            Expanded(
                              child: MyTextField(
                                hint: 'Province',
                                controller: provinceController,
                                //  readOnly: false,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Contact Number',
                          controller: contactNumberController,
                          // readOnly: false,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Password',
                          controller: passwordController,
                          obscureText: true,
                          /* onChanged: (value){
                                passwordController.text = value;
                              }*/
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Retype Password',
                          controller: retypePasswordController,
                          obscureText: true,
                        ),
                        SizedBox(height: 36),
                        Text(
                          'Upload Picture of Drivers License',
                          style: Global.style(
                            size: 16,
                          ),
                        ),
                        Container(
                            height: width / 1.9,
                            width: double.infinity,
                            child: Stack(children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(0),
                                  ),
                                  child: _newProfileImage
                                      ? Image.file(
                                          _profileImage!,
                                          fit: BoxFit.fitWidth,
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 5,
                                            ),
                                          ),
                                        )),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Opacity(
                                  opacity: 0.8,
                                  child: SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: Material(
                                      elevation: 4,
                                      color: Colors.greenAccent,
                                      borderRadius: BorderRadius.circular(40),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.add_a_photo_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: _getImage,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ])

                            /* child: IconButton(
                          alignment: Alignment.bottomRight,
                          iconSize: 60,
                          icon: Icon(Icons.add_a_photo_outlined),
                          color: Colors.white,
                          onPressed: () {
                            _getImage();
                          },
                        ),*/

                            ),
                        SizedBox(height: 12),
                        ConfirmationSlider(
                          onConfirmation: () {
                            RequestForDriverSignUp();
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
                        SizedBox(height: 12),
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
                                    Get.to(DriverLoginPage());
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
                        SizedBox(height: 12),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          inAsyncCall: isBusy,
          // demo of some additional parameters
          // opacity: 0.5,
          progressIndicator: CircularProgressIndicator(
            backgroundColor: Colors.black.withOpacity(0.9),
            valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  void _getImage() async {
    final pickedFile = await picker.pickImage(
        source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    if (pickedFile != null) {
      setState(() {
        _newProfileImage = true;
        _profileImage = File(pickedFile.path);
      });
    }
  }

  RequestForDriverSignUp() async {
    if (!await validate()) return;

    try {
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        isBusy = true;
      });
      if (_newProfileImage) {
        await uploadPicController.fetchPic(
            _profileImage!,
            _profileImage!.path.split("/").last.toString(),
            0,
            "Driver License");
        print(uploadPicController.picINfo.value.status);
        if (uploadPicController.picINfo.value.status == 200) {
          try {
            Map<String, Object?> userData = {
              "user_type": "driver",
              "first_name": firstNameController.text,
              "last_name": lastNameController.text,
              "user_name": userNameController.text,
              "email": emailAddressController.text,
              "address": addressController.text,
              "city": cityController.text,
              "province": provinceController.text,
              "password": passwordController.text,
              "contact": contactNumberController.text,
              "license_image": uploadPicController.picINfo.value.data
            };
            print(userData);
            await registrationController.fetchRegistration(userData, 2);
            setState(() {
              isBusy = false;
            });
          } catch (e) {
            setState(() {
              isBusy = false;
            });
            print("Registration Error!");
            print(e.toString());
          }
        }
        setState(() {
          isBusy = false;
        });
      }
    } on SocketException catch (_) {
      showErrorToast("Please check your Internet Connection");
      return false;
    } catch (err) {
      // final requestbody = json.decode(err.body);
      // final data = requestbody['error'];
      // print(data);
      // showProductErrorToast(data["message"]);
      showErrorToast(err.toString());
      setState(() {
        isBusy = false;
      });
    }
  }

  Future<bool> validate() async {
    if (addressController.text.isEmpty) {
      showErrorToast("Please enter Address");
      return false;
    }
    if (cityController.text.isEmpty) {
      showErrorToast("Please enter City");
      return false;
    }
    if (provinceController.text.isEmpty) {
      showErrorToast("Please enter Province");
      return false;
    }
    if (contactNumberController.text.isEmpty) {
      showErrorToast("Please enter Contact Number");
      return false;
    }
    if (retypePasswordController.text != passwordController.text) {
      showErrorToast("Password and confirm password didn't match");
      return false;
    }
    if (_profileImage == null) {
      showErrorToast("Please upload file");
      return false;
    }
    return true;
  }

  void showErrorToast(Message) {
    Fluttertoast.showToast(
        msg: Message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  void showSuccessToast(Message) {
    Fluttertoast.showToast(
        msg: Message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIos: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white);
  }
}

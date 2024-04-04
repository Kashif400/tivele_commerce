import 'dart:async';
import 'dart:io';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:e_commerce_foods/controllers/registrationController.dart';
import 'package:e_commerce_foods/controllers/uploadPicController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_2.dart';
import 'package:e_commerce_foods/views/business/businessLoginPage.dart';
import 'package:e_commerce_foods/views/customer/customerRegistrationPage.dart';
import 'package:e_commerce_foods/views/driver/driverRegistrationPage.dart';
import 'package:video_player/video_player.dart';

class BusinessRegistrationPage extends StatefulWidget {
  @override
  _RegisterBusiness2State createState() => _RegisterBusiness2State();
}

class _RegisterBusiness2State extends State<BusinessRegistrationPage> {
  final UploadPicController uploadPicController =
      Get.put(UploadPicController());
  final RegistrationController registrationController =
      Get.put(RegistrationController());
  String? _selectedUser = "Business";
  List usersList = ["Customer", "Business", "Driver"];
  TextEditingController nameController = TextEditingController();
  TextEditingController descripationController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  var picker = ImagePicker();
  File? _profileImage;
  bool loading = false;
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

  @override
  Widget build(BuildContext context) {
    //TextEditingController lastNameController = TextEditingController(text:indiUser.userName);

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
                                    this._selectedUser = "Business";
                                    Get.offAll(CustomerRegistrationPage());
                                  }
                                  if (newValueSelected == "Driver") {
                                    this._selectedUser = "Business";
                                    Get.offAll(DriverRegistrationPage());
                                  }
                                },
                                value: _selectedUser,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Bussiness Name',
                          controller: nameController,
                          //readOnly: false,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Email Address',
                          controller: emailController,
                          // readOnly: true,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Description',
                          controller: descripationController,
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
                        SizedBox(height: 32),
                        InkWell(
                          onTap: _getImage,
                          child: Text("Upload Picture of Business",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 12),
                        _newProfileImage
                            ? Container(
                                child: Image.file(
                                  _profileImage!,
                                  height: 150,
                                  fit: BoxFit.fill,
                                ),
                              )
                            : Container(),
                        /*Container(
                          height: width / 1.9,
                          width: double.infinity,
                          child: Stack(children: [
                            ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(0),
                                ),
                                child: Image.file(
                                  _profileImage,
                                  fit: BoxFit.fitWidth,
                                )
                            ),
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
                                          color: Colors.white,                                  ),
                                      ),
                                      onTap: _getImage,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ])


                        */ /* child: IconButton(
                          alignment: Alignment.bottomRight,
                          iconSize: 60,
                          icon: Icon(Icons.add_a_photo_outlined),
                          color: Colors.white,
                          onPressed: () {
                            _getImage();
                          },
                        ),*/ /*

                      )*/
                        SizedBox(height: 12),
                        ConfirmationSlider(
                          onConfirmation: () {
                            RequestForBusinessAccount();
                          },
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          textStyle: Global.style(
                            color: Colors.black,
                            size: 16,
                          ),
                          text: 'Swipe to Sign up ',
                          height: 50,
                        ),
                        SizedBox(height: 16),
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
                                    Get.to(BusinessLoginPage());
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
                  ),
                ),
              ),
            ],
          ),
          inAsyncCall: isBusy,
          //   opacity: 0.5,
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
        source: ImageSource.gallery,
        maxHeight: 800,
        maxWidth: 800,
        imageQuality: 70);
    if (pickedFile != null) {
      setState(() {
        _newProfileImage = true;
        _profileImage = File(pickedFile.path);
      });
    } else {
      setState(() {
        _newProfileImage = false;
        _profileImage = null;
      });
    }
  }

  void showProductErrorToast(msg, error) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 1,
        backgroundColor: error ? Colors.red : Colors.green,
        textColor: Colors.white);
  }

  RequestForBusinessAccount() async {
    if (!await validate()) return;
    try {
      FocusScope.of(context).requestFocus(new FocusNode());
      final result = await InternetAddress.lookup('google.com');
      setState(() {
        isBusy = true;
      });
      var position = await Global.determinePosition();
      if (_newProfileImage) {
        await uploadPicController.fetchPic(
            _profileImage!,
            _profileImage!.path.split("/").last.toString(),
            0,
            "Business Registration");
        print(uploadPicController.picINfo.value.status);
        if (uploadPicController.picINfo.value.status == 200) {
          print(position.longitude);
          print(position.latitude);
          try {
            Map<String, Object?> userData = {
              "user_type": "business",
              "business_name": nameController.text,
              "email": emailController.text,
              "description": descripationController.text,
              "password": passwordController.text,
              "business_image": uploadPicController.picINfo.value.data,
              "longitude": position.longitude.toString(),
              "latitude": position.latitude.toString()
            };
            print(userData);
            await registrationController.fetchRegistration(userData, 1);
          } catch (e) {
            setState(() {
              isBusy = false;
            });
            print("Registration Error!");
            print(e.toString());
          }
        }
      }
      setState(() {
        isBusy = false;
      });
      //   file = await context.read<ProductsProvider>().productUpload(
      //       _profileImage);
      // var uId = await SessionService.retrieveUser();
      // print(uId);

      //var res = await BusinessUserService.create(business);
      // if (res) {
      //   showProductErrorToast("Business account request submitted successfully", false);
      //   setState(() {
      //     Global.isDriverAccount=false;
      //     Global.isBusinessAccount=true;
      //   });
      //   Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //       builder: (_) => LoginBusiness(),
      //     ),
      //         (_) => false,
      //   );
      // }
      // else{
      //   showProductErrorToast("Business request could not be completed. Please try again later!",true);
      //   setState(() {
      //     isBusy=false;
      //   });
      // }
      //
      // setState(() {
      //   isBusy=false;
      // });
    } on SocketException catch (_) {
      showErrorToast("Please check your Internet Connection");
      return false;
    } catch (err) {
      setState(() {
        isBusy = false;
      });
      if (err.toString().contains("Location"))
        showProductErrorToast(err, true);
      else
        showProductErrorToast(
            "Business request could not be completed. Please try again later!",
            true);
    }
  }

  Future<bool> validate() async {
    if (nameController.text.isEmpty) {
      showErrorToast("Please enter Business Name");
      return false;
    }
    if (descripationController.text.isEmpty) {
      showErrorToast("Please enter Description");
      return false;
    }
    if (_profileImage == null) {
      showErrorToast("Please attach file");
      return false;
    }
    if (retypePasswordController.text != passwordController.text) {
      showErrorToast("Password and confirm password didn't match");
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
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/service/DriverAccount/driverAccount.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:video_player/video_player.dart';

import 'login_driver.dart';

class RegisterDeliver extends StatefulWidget {
  @override
  _RegisterDeliverState createState() => _RegisterDeliverState();
}

class _RegisterDeliverState extends State<RegisterDeliver> {
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController provinceController = TextEditingController();
  TextEditingController contactNumberController = TextEditingController();

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
    context.read<BusinessUsersProvider>().getCurrentUser();
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
    final indiUser = context.watch<BusinessUsersProvider>().userProfile!;
    TextEditingController firstNameController =
        TextEditingController(text: indiUser.name);
    TextEditingController lastNameController =
        TextEditingController(text: indiUser.userName);
    TextEditingController emailAddressController =
        TextEditingController(text: indiUser.emailAddress);
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text(
            'TIVELE',
            style: Global.style(
              size: 22,
              bold: true,
              caps: true,
            ),
          ),
          centerTitle: true,
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
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
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
                        SizedBox(height: 36),
                        Text(
                          'Upload Picture of Drivers License',
                          style: Global.style(
                            size: 16,
                          ),
                        ),
                        SizedBox(height: 12),
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
                        )
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
      setState(() {
        isBusy = true;
      });
      var file =
          await context.read<ProductsProvider>().productUpload(_profileImage!);
      // final result = await InternetAddress.lookup('google.com');
      var uId = await SessionService.retrieveUser();
      print(uId);
      var driver = {
        "userId": uId,
        "address": addressController.text,
        "city": cityController.text,
        "provience": provinceController.text,
        "status": 1,
        "drivingLicenceId": file["id"]
      };
      print(driver);
      var res = await DriverAccountService.create(driver);
      if (res) {
        showSuccessToast("Driver Account is Created Successfully");
        setState(() {
          Global.isDriverAccount = true;
          Global.isBusinessAccount = true;
        });
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => LoginDriver(),
          ),
          (_) => false,
        );
      } else {
        showProductErrorToast("Error while your request");
        setState(() {
          isBusy = false;
        });
      }
    } on SocketException catch (_) {
      showErrorToast("Please check your Internet Connection");
      return false;
    } catch (err) {
      final requestbody = json.decode(err.toString());
      final data = requestbody['error'];
      print(data);
      showProductErrorToast(data["message"]);
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

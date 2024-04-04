import 'dart:async';
import 'dart:io';

import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/service/BussinessUser/BusinessUser_service.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_2.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:video_player/video_player.dart';

import 'login_business.dart';

class RegisterBusiness2 extends StatefulWidget {
  @override
  _RegisterBusiness2State createState() => _RegisterBusiness2State();
}

class _RegisterBusiness2State extends State<RegisterBusiness2> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descripationController = TextEditingController();

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
    TextEditingController emailAddressController = TextEditingController();

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
                          hint: 'Bussiness Name',
                          controller: nameController,
                          //readOnly: false,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Email Address',
                          controller: emailAddressController,
                          // readOnly: true,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Description',
                          controller: descripationController,
                          // readOnly: false,
                        ),
                        SizedBox(height: 36),
                        InkWell(
                          onTap: _getImage,
                          child: Text("Upload Picture of Business",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold)),
                        ),
                        SizedBox(height: 12),
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
                  ),
                ),
              ),
            ],
          ),
          inAsyncCall: isBusy,
          //   opacity: 0.5,
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
      final result = await InternetAddress.lookup('google.com');
      setState(() {
        isBusy = true;
      });
      var position = await Global.determinePosition();
      String? file = null;
      if (_newProfileImage)
        file = await (context
            .read<ProductsProvider>()
            .productUpload(_profileImage!) as FutureOr<String?>);
      var uId = await SessionService.retrieveUser();
      print(uId);
      var business = {
        "name": nameController.text,
        "description": descripationController.text,
        "status": 0,
        "isReputable": false,
        "userId": uId,
        "businessAccountImageId": file,
        "location": {
          "address1": "137",
          "city": "lahore",
          "state": "punjab",
          "country": "pakistan",
          "postalCode": "54810",
          "latitude": position.latitude,
          "longitude": position.longitude,
        }
      };

      var res = await BusinessUserService.create(business);
      if (res) {
        showProductErrorToast(
            "Business account request submitted successfully", false);
        setState(() {
          Global.isDriverAccount = false;
          Global.isBusinessAccount = true;
        });
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => LoginBusiness(),
          ),
          (_) => false,
        );
      } else {
        showProductErrorToast(
            "Business request could not be completed. Please try again later!",
            true);
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

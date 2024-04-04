import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/GlobalProperties/GlobalProperties.dart';
import 'package:e_commerce_foods/service/account/userProfile_service.dart';
import 'package:e_commerce_foods/service/account/user_service.dart';
import 'package:e_commerce_foods/ui/auth/login_driver.dart';
import 'package:e_commerce_foods/ui/auth/login_user.dart';
import 'package:e_commerce_foods/ui/home/home_user.dart';
import 'package:e_commerce_foods/ui/sidebar/card.dart';
import 'package:e_commerce_foods/ui/sidebar/my_orders.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  late File ProfileImage;
  bool isGalleryImage = false;
  bool isBusy = false;
  String? ImageId;

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

  @override
  initState() {
    super.initState();
    context.read<ProductsProvider>().getProduct();
    context.read<BusinessUsersProvider>().getBussinessUser();
    context.read<BusinessUsersProvider>().getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    String image =
        'https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg';
    final user = context.watch<BusinessUsersProvider>().userProfile;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ModalProgressHUD(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pushAndRemoveUntil(
                              MaterialPageRoute(
                                builder: (_) => HomeUser(),
                              ),
                              (_) => false,
                            );
                          },
                          child: Text(
                            'Done',
                            style: Global.style(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _getImage();
                    },
                    child: Container(
                      height: 70,
                      width: 70,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        border: Border.all(
                          color: Colors.white,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                        child: isGalleryImage
                            ? Image.file(
                                ProfileImage,
                                fit: BoxFit.cover,
                              )
                            : Image.network(
                                GlobalProperties.defaultProfileImageUrl!,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),

                  SizedBox(height: 8),
                  Text(
                    'Change Profile Image',
                    style: Global.style(),
                  ),
                  SizedBox(height: 32),
//                Padding(
//                  padding: EdgeInsets.symmetric(horizontal: 16),
//                  child: Column(
//                    children: [
//                      MyTextField(
//                        hint: 'Name',
//                        controller: nameController,
//                      ),
//                      MyTextField(
//                        hint: 'Username',
//                        controller: usernameController,
//                      ),
//                    ],
//                  ),
//                ),
//                SizedBox(height: 32),
//                Container(
//                  width: double.infinity,
//                  height: 1,
//                  color: Colors.white,
//                ),
                  ListTile(
                    onTap: openChangePasswordDialog,
                    trailing: Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Change Password',
                      style: Global.style(),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.white,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentCard(),
                        ),
                      );
                    },
                    trailing: Icon(
                      Icons.credit_card_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Saved Cards',
                      style: Global.style(),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.white,
                  ),

                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.white,
                  ),
                  ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => MyOrders(),
                        ),
                      );
                    },
                    title: Text(
                      'My Orders',
                      style: Global.style(),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.white,
                  ),
                  Visibility(
                    visible: Global.isDriverAccount,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => LoginDriver(),
                          ),
                        );
                      },
                      title: Text(
                        'Deliver with Tivele?',
                        style: Global.style(),
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.white,
                  ),
                  ListTile(
                    onTap: openLogoutDialog,
                    trailing: Icon(
                      Icons.exit_to_app_outlined,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Logout',
                      style: Global.style(),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 1,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
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

  void openLogoutDialog() {
    showDialog(
      builder: (BuildContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (_, __) {
              return Container(
                height: 200,
                color: Colors.black,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Text(
                        'Logout',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Are you sure you want\nto logout?',
                      textAlign: TextAlign.center,
                      style: Global.style(),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: MaterialButton(
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => LoginUser(),
                                  ),
                                  (Route<dynamic> route) => false,
                                );
                              },
                              child: Text(
                                'Yes',
                                textAlign: TextAlign.center,
                                style: Global.style(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          height: 35,
                          width: 70,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'No',
                                textAlign: TextAlign.center,
                                style: Global.style(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
      context: context,
    );
  }

  void openChangePasswordDialog() {
    showDialog(
      builder: (BuildContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (_, __) {
              return Container(
                height: 350,
                color: Colors.black,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Text(
                        'Change Password',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(children: [
                        MyTextField(
                          obscureText: true,
                          hint: 'Current Password',
                          controller: currentPasswordController,
                          readOnly: false,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                            obscureText: true,
                            hint: 'New Password',
                            controller: newPasswordController,
                            readOnly: false),
                        SizedBox(height: 12),
                        MyTextField(
                            obscureText: true,
                            hint: 'Retype New Password',
                            controller: retypePasswordController,
                            readOnly: false),
                      ]),
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: Global.style(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          height: 35,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                ChangePassword();
                              },
                              child: Text(
                                'Save',
                                textAlign: TextAlign.center,
                                style: Global.style(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
      context: context,
    );
  }

  ChangePassword() async {
    if (!await validate()) return;
    try {
      setState(() {
        isBusy = true;
      });
// Try reading data from the counter key. If it doesn't exist, return 0.
      var passwordData = {
        "currentPassword": currentPasswordController.text,
        "newPassword": newPasswordController.text
      };
      var res = await UserProfileService.changePassword(passwordData);
      if (res) {
        showSuccessToast("Password is changed Successfully");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => HomeUser(),
          ),
          (_) => false,
        );
      } else {
        showErrorToast("Error occured while Changing Password");
        setState(() {
          isBusy = false;
        });
      }
    } catch (err) {
      // final requestbody = json.decode(err.body);
      // final data = requestbody['error'];
      // showErrorToast(data["message"]);
      showErrorToast(err.toString());
      setState(() {
        isBusy = false;
      });
      print(err);
    }
  }

  Future<bool> validate() async {
    if (currentPasswordController.text.isEmpty) {
      showErrorToast("Please enter current password");
      return false;
    }
    if (newPasswordController.text.isEmpty) {
      showErrorToast("Please enter New Password");
      return false;
    }
    if (retypePasswordController.text.isEmpty ||
        newPasswordController.text != retypePasswordController.text) {
      showErrorToast("New password and Retype Password must be match");
      return false;
    }
    return true;
  }

  _getImage() async {
    final picker = new ImagePicker();
    var pickedimage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedimage != null) {
      setState(() {
        isGalleryImage = true;
        ProfileImage = File(pickedimage.path);
      });
    } else {
      showErrorToast("Error occured while upload file");
      setState(() {
        isBusy = false;
      });
    }
    _UploadProfilePicture(ProfileImage);
  }

  _UploadProfilePicture(File imageFile) async {
    setState(() {
      isBusy = true;
    });
    var response = await UserProfileService.saveProfilePicture(imageFile);
    if (response != null) {
      setState(() {
        GlobalProperties.defaultProfileImageUrl = response["url"];
      });
      ImageId = response["id"];
      _UpdateProfile(ImageId);
    } else {
      setState(() {
        isBusy = false;
      });
    }
  }

  _UpdateProfile(String? ImageId) async {
    var imageid = {"userProfileId": ImageId};
    var response = await UserService.updateProfile(imageid);
    if (response) {
      _GetProfile();
    } else {
      setState(() {
        isBusy = false;
      });
    }
  }

  _GetProfile() async {
    var response = await UserService.getProfile();
    if (response != null) {
      var profileData = response["userProfile"];
      var url = profileData["url"];
      setState(() {
        GlobalProperties.defaultProfileImageUrl = url;
        isBusy = false;
      });
    } else {
      setState(() {
        isBusy = false;
      });
    }
  }
}

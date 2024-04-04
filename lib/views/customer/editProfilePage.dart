import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/controllers/customer/updateProfileImageController.dart';
import 'package:e_commerce_foods/controllers/customer/updateUserPasswordController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';
import 'package:e_commerce_foods/views/customer/customerHomePage.dart';
import 'package:e_commerce_foods/views/customer/customerLoginPage.dart';
import 'package:e_commerce_foods/views/customer/myOrdersPage.dart';

class EditProfilePage extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfilePage> {
  final UpdateProfileImageController updateProfileImageController =
      Get.put(UpdateProfileImageController());
  final UpdateUserPasswordController updateUserPasswordController =
      Get.put(UpdateUserPasswordController());
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();
  late File ProfileImage;
  bool isGalleryImage = false;
  String? useridCustomer = "";
  bool isBusy = false;
  String? ImageId;
  String? userName = "";
  String? myProfilePic =
      "https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg";
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

  Future<void> makePostRequest(String? userId) async {
    final url = Uri.parse('https://admin.tivele.com/deltUser.php');
    final json = {'user_id': userId};
    final response = await http.post(url, body: json);
    print('Status code: ${response.statusCode}');
    if (response.statusCode == 200) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => CustomerLoginPage()),
      );
    }
    print('Body: ${response.body}');
  }

  @override
  initState() {
    super.initState();
    if (!globals.checkLogin) {
      getUserName();
    }
  }

  getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString("user_name");
      myProfilePic = prefs.getString("user_image");
      useridCustomer = prefs.getString("user_id");
    });
  }

  @override
  Widget build(BuildContext context) {
    String image =
        'https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg';
    return WillPopScope(
      onWillPop: () {
        Get.offAll(CustomerHomePage());
      } as Future<bool> Function()?,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.black,
          body: globals.checkLogin
              ? InkWell(
                  onTap: () async {
                    Get.offAll(CustomerLoginPage());
                  },
                  child: Center(
                    child: Text(
                      'Login to continue (Click)',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 4,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                )
              : ModalProgressHUD(
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
                                    Get.offAll(CustomerHomePage());
                                  },
                                  child: Text(
                                    'Done',
                                    style: Global.style(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            userName!,
                            style: Global.style(
                              size: 18,
                              bold: true,
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
                                child: Stack(
                                  children: [
                                    isGalleryImage
                                        ? Image.file(
                                            ProfileImage,
                                            fit: BoxFit.cover,
                                          )
                                        : Image.network(
                                            URLS.BASEURL + myProfilePic!,
                                            fit: BoxFit.cover,
                                          ),
                                    Positioned(
                                        bottom: 5,
                                        right: 5,
                                        child: Icon(
                                          Icons.edit_location_outlined,
                                          color: Colors.grey[200],
                                        )),
                                  ],
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
                          // ListTile(
                          //   onTap: () {
                          //     Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         builder: (_) => PaymentCard(),
                          //       ),
                          //     );
                          //   },
                          //   trailing: Icon(
                          //     Icons.credit_card_outlined,
                          //     color: Colors.white,
                          //   ),
                          //   title: Text(
                          //     'Saved Cards',
                          //     style: Global.style(),
                          //   ),
                          // ),
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
                              Get.to(MyOrdersPage());
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
                          ListTile(
                            onTap: () {
                              openDeleteDialog();
                            },
                            trailing: Icon(
                              Icons.delete,
                              color: Colors.white,
                            ),
                            title: Text(
                              'Delete Account',
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
                        ],
                      ),
                    ),
                  ),
                  inAsyncCall: isBusy,
                  progressIndicator: Center(child: globals.circularIndicator()),
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
                                Navigator.of(context).pop();
                                Get.offAll(CustomerLoginPage());
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
                height: 430,
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
                                ChangePassword(context);
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

  ChangePassword(BuildContext context) async {
    if (!await validate()) return;
    try {
      Navigator.pop(context);
      FocusScope.of(context).requestFocus(new FocusNode());
      setState(() {
        isBusy = true;
      });
      Map<String, Object> passwordData = {
        "current_password": currentPasswordController.text,
        "new_password": newPasswordController.text,
        'user_type': "user"
      };
      await updateUserPasswordController.fetchUpdateUserPassword(passwordData);
      if (updateUserPasswordController.passwordINfo.value.status == 200) {
        showSuccessToast("Password is changed Successfully");
        setState(() {
          isBusy = false;
        });
        Get.offAll(CustomerLoginPage());
      } else if (updateUserPasswordController.passwordINfo.value.status ==
          900) {
        showErrorToast("Please enter correct current's password!");
        setState(() {
          isBusy = false;
        });
      } else {
        showErrorToast("Error occured during updation!");
        setState(() {
          isBusy = false;
        });
      }
      setState(() {
        currentPasswordController.text = "";
        newPasswordController.text = "";
        retypePasswordController.text = "";
      });
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
      _UploadProfilePicture(ProfileImage);
    } else {
      showErrorToast("Error occured while upload file");
      setState(() {
        isBusy = false;
      });
    }
  }

  _UploadProfilePicture(File _profileImage) async {
    setState(() {
      isBusy = true;
    });
    await updateProfileImageController.fetchUpdateImageData(
        _profileImage, _profileImage.path.split("/").last.toString(), "user");
    print(updateProfileImageController.imageINfo.value.status);
    if (updateProfileImageController.imageINfo.value.status == 200) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(
          "user_image", updateProfileImageController.imageINfo.value.data!);
      globals.showSuccessToast("Image Updated Successfully.");
      setState(() {
        isBusy = false;
      });
    } else {
      globals.showErrorToast("Error Updation!");
      setState(() {
        isBusy = false;
      });
    }
  }

  void openDeleteDialog() {
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
                        'Delete Account',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Are you sure you want\nto Delete Your Account?',
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
                                makePostRequest(useridCustomer);
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
}

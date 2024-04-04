import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/GlobalProperties/GlobalProperties.dart';
import 'package:e_commerce_foods/service/account/userProfile_service.dart';
import 'package:e_commerce_foods/ui/auth/login_business.dart';
import 'package:e_commerce_foods/ui/auth/login_driver.dart';
import 'package:e_commerce_foods/ui/auth/login_user.dart';
import 'package:e_commerce_foods/ui/home/businesses.dart';
import 'package:e_commerce_foods/ui/home/deals.dart';
import 'package:e_commerce_foods/ui/home/reviews.dart';
import 'package:e_commerce_foods/ui/home/search.dart';
import 'package:e_commerce_foods/ui/points.dart';
import 'package:e_commerce_foods/ui/sidebar/card.dart';
import 'package:e_commerce_foods/ui/sidebar/contact_us.dart';
import 'package:e_commerce_foods/ui/sidebar/edit_profile.dart';
import 'package:e_commerce_foods/ui/sidebar/my_orders.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';

class HomeUser extends StatefulWidget {
  @override
  _HomeUserState createState() => _HomeUserState();
}

class _HomeUserState extends State<HomeUser> {
  var tab = [
    Businesses(),
    Search(),
    Deals(),
    Reviews(),
    EditProfile(),
  ];
  int currentIndex = 0;
  bool isBusy = false;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController retypePasswordController = TextEditingController();

  initState() {
    super.initState();
    // context.read<ProductsProvider>().getProduct();
    // context.read<BusinessUsersProvider>().getBussinessUser();
    context.read<BusinessUsersProvider>().getCurrentUser();
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

  @override
  Widget build(BuildContext context) {
    String image =
        'https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg';
    final user = context.watch<BusinessUsersProvider>().userProfile;
    double width = MediaQuery.of(context).size.width / 5;
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.black,
        appBar: currentIndex == 0 || currentIndex == 2 || currentIndex == 3
            ? AppBar(
                iconTheme: IconThemeData(
                  color: Colors.black,
                ),
                elevation: 0,
                backgroundColor: Colors.black,
                title: Text(
                  currentIndex == 0
                      ? 'TIVELE'
                      : currentIndex == 2
                          ? 'TIVELE DEALS'
                          : currentIndex == 3
                              ? 'TIVELE'
                              : '',
                  style: Global.style(
                    size: currentIndex == 2 ? 18 : 22,
                    bold: true,
                    caps: true,
                  ),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                  )
                ],
              )
            : null,
        drawer: Drawer(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 16,
            ),
            decoration: BoxDecoration(
              color: Colors.black,
              border: Border.all(
                color: Colors.white,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Text(
                    'Kondravich',
                    style: Global.style(
                      bold: true,
                      size: 20,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Points(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.monetization_on_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    'My Points',
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
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => EditProfile(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.edit,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Edit Profile',
                    style: Global.style(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),
                ListTile(
                  onTap: openChangePasswordDialog,
                  leading: Icon(
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
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => PaymentCard(),
                      ),
                    );
                  },
                  leading: Icon(
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
                ListTile(
                  tileColor: Colors.white,
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MyOrders(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.food_bank_outlined,
                    color: Colors.white,
                  ),
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
                      Navigator.of(context).pop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LoginDriver(),
                        ),
                      );
                    },
                    leading: Text('T', style: Global.style(size: 32)),
                    title: Text(
                      'Deliver with Tivele',
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
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Contact(),
                      ),
                    );
                  },
                  leading: Icon(
                    Icons.call_outlined,
                    color: Colors.white,
                  ),
                  title: Text(
                    'Contact Us',
                    style: Global.style(),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),
                ListTile(
                  onTap: openLogoutDialog,
                  leading: Icon(
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
                Visibility(
                  visible: true,
                  //Global.isBusinessAccount,
                  child: ListTile(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => LoginBusiness(),
                        ),
                      );
                    },
                    leading: Icon(
                      Icons.person_outline,
                      color: Colors.white,
                    ),
                    title: Text(
                      'Business Owner',
                      style: Global.style(),
                    ),
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
        bottomNavigationBar: Container(
          height: 80,
          child: Row(
            children: [
              Container(
                width: width,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 0;
                    });
                  },
                  icon: Icon(
                    Icons.home_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: width,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 1;
                    });
                  },
                  icon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
                child: Container(
                  width: width,
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  child: Text(
                    'T',
                    textAlign: TextAlign.center,
                    style: Global.style(
                      color: Colors.black,
                      size: 36,
                    ),
                  ),
                ),
              ),
              Container(
                width: width,
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      currentIndex = 3;
                    });
                  },
                  icon: Icon(
                    Icons.favorite_border,
                    color: Colors.white,
                  ),
                ),
              ),
              Container(
                width: width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          currentIndex = 4;
                        });
                      },
                      child: Container(
                        height: 32,
                        width: 32,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(24),
                          ),
                          child: Image.network(
                            GlobalProperties.defaultProfileImageUrl == null
                                ? "https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg"
                                : GlobalProperties.defaultProfileImageUrl!,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: Container(
          color: Colors.black,
          child: ModalProgressHUD(
            child: tab[currentIndex],
            inAsyncCall: isBusy,
            // demo of some additional parameters
            // opacity: 0.5,
            color: Colors.black,
            dismissible: true,
            progressIndicator: Container(
              // color: Colors.black,
              child: Center(
                child: Container(
                  color: Colors.black,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
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
                color: Colors.black,
                height: 350,
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
                          hint: 'Current Password',
                          controller: currentPasswordController,
                          readOnly: false,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'New Password',
                          controller: newPasswordController,
                          readOnly: false,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Retype New Password',
                          controller: retypePasswordController,
                          readOnly: false,
                        ),
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

  ChangePassword() async {
    if (!await validate()) return;
    var cp = {
      "currentPassword": currentPasswordController.text,
      "newPassword": newPasswordController.text
    };
    try {
      setState(() {
        isBusy = true;
      });
      var res = await UserProfileService.changePassword(cp);
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
      final requestbody = json.decode(err.toString());
      final data = requestbody['error'];
      showErrorToast(data["message"]);
      setState(() {
        isBusy = false;
      });
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
}

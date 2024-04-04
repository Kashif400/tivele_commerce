import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/ui/auth/login.dart';
import 'package:e_commerce_foods/ui/card.dart';
import 'package:e_commerce_foods/ui/home/favourites.dart';
import 'package:e_commerce_foods/ui/home/item_list.dart';
import 'package:e_commerce_foods/ui/home/profile.dart';
import 'package:e_commerce_foods/ui/home/search.dart';
import 'package:e_commerce_foods/ui/sidebar/contact_us.dart';
import 'package:e_commerce_foods/ui/sidebar/edit_profile.dart';
import 'package:e_commerce_foods/ui/sidebar/my_orders.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var tab = [
    ItemList(),
    Search(),
    ItemList(),
    Favourites(),
    Profile(),
  ];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    String image =
        'https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg';
    double width = MediaQuery.of(context).size.width / 5;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
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
                  title: Text(
                    'My Orders',
                    style: Global.style(
                      color: Colors.black,
                      size: 16,
                      bold: true,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),
                ListTile(
                  onTap: () {},
                  leading: Text('T', style: Global.style(size: 32)),
                  title: Text(
                    'Deliver with Tivele',
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
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Login(),
                      ),
                    );
                  },
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
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => Login(),
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
              GestureDetector(
                onTap: () {
                  setState(() {
                    currentIndex = 2;
                  });
                },
                child: Container(
                  width: width,
                  child: Container(
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
                            image,
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
        body: tab[currentIndex],
      ),
    );
  }

  void openChangePasswordDialog() {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController retypePasswordController = TextEditingController();

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
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Text(
                        'Change Password',
                        textAlign: TextAlign.center,
                        style: Global.style(
                          color: Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(children: [
                        MyTextField(
                            hint: 'Current Password',
                            controller: currentPasswordController,
                            readOnly: false),
                        SizedBox(height: 12),
                        MyTextField(
                            hint: 'New Password',
                            controller: newPasswordController,
                            readOnly: false),
                        SizedBox(height: 12),
                        MyTextField(
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
                            color: Colors.black,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: MaterialButton(
                              onPressed: () {},
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: Global.style(),
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
                            color: Colors.black,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: MaterialButton(
                              onPressed: () {},
                              child: Text(
                                'Save',
                                textAlign: TextAlign.center,
                                style: Global.style(),
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

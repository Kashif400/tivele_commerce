import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/ui/auth/login_user.dart';
import 'package:e_commerce_foods/ui/home/businesses.dart';
import 'package:e_commerce_foods/ui/home/deals.dart';
import 'package:e_commerce_foods/ui/home/my_profile.dart';
import 'package:e_commerce_foods/ui/home/reviews.dart';
import 'package:e_commerce_foods/ui/home/search.dart';
import 'package:e_commerce_foods/ui/sidebar/card.dart';
import 'package:e_commerce_foods/ui/sidebar/contact_us.dart';
import 'package:e_commerce_foods/ui/sidebar/my_orders.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class HomeBusiness extends StatefulWidget {
  final String? businessAccountId;
  const HomeBusiness(this.businessAccountId);
  @override
  _HomeBusinessState createState() => _HomeBusinessState(businessAccountId);
}

class _HomeBusinessState extends State<HomeBusiness> {
  String? _busAccountId;
  _HomeBusinessState(String? busAccountId) {
    _busAccountId = busAccountId;
  }
  var tab = [];
  int currentIndex = 0;

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool isBusy = false;
  initState() {
    print("we are in init");
    print(_busAccountId);
    super.initState();
    tab = [
      Businesses(),
      Search(),
      Deals(),
      Reviews(),
      MyProfile(_busAccountId),
    ];
    context.read<ProductsProvider>().getProduct();
    context.read<BusinessUsersProvider>().getBussinessUser();
    context.read<BusinessUsersProvider>().getCurrentUser();
    context
        .read<BusinessUsersProvider>()
        .getBussinessUsers(widget.businessAccountId!);
  }

  @override
  Widget build(BuildContext context) {
    String image =
        'https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg';
    final bUser = context.watch<BusinessUsersProvider>().users;
    double width = MediaQuery.of(context).size.width / 5;

    return SafeArea(
      child: bUser == null
          ? Center(
              child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.black)))
          : Scaffold(
              key: scaffoldKey,
              appBar:
                  currentIndex == 0 || currentIndex == 2 || currentIndex == 3
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
                              size: 22,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                              builder: (_) =>
                                  MyProfile(widget.businessAccountId),
                            ),
                          );
                        },
                        leading: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        title: Text(
                          'My Profile',
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
                    ],
                  ),
                ),
              ),
              // bottomNavigationBar: Container(
              //   height: 80,
              //   child: Row(
              //     children: [
              //       Container(
              //         width: width,
              //         child: IconButton(
              //           onPressed: () {
              //             setState(() {
              //               currentIndex = 0;
              //             });
              //           },
              //           icon: Icon(
              //             Icons.home_outlined,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //       Container(
              //         width: width,
              //         child: IconButton(
              //           onPressed: () {
              //             setState(() {
              //               currentIndex = 1;
              //             });
              //           },
              //           icon: Icon(
              //             Icons.search,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //       Container(
              //         child: InkWell(
              //           onTap: () {
              //             setState(() {
              //               currentIndex = 2;
              //             });
              //           },
              //           child: Container(
              //             width: width,
              //             child: Container(
              //               padding: EdgeInsets.all(6),
              //               decoration: BoxDecoration(
              //                 shape: BoxShape.circle,
              //                 color: Colors.white,
              //               ),
              //               child: Text(
              //                 'T',
              //                 textAlign: TextAlign.center,
              //                 style: Global.style(
              //                   color: Colors.black,
              //                   size: 36,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Container(
              //         width: width,
              //         child: IconButton(
              //           onPressed: () {
              //             setState(() {
              //               currentIndex = 3;
              //             });
              //           },
              //           icon: Icon(
              //             Icons.favorite_border,
              //             color: Colors.white,
              //           ),
              //         ),
              //       ),
              //       Container(
              //         width: width,
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.center,
              //           children: [
              //             GestureDetector(
              //               onTap: () {
              //                 setState(() {
              //                   currentIndex = 4;
              //                 });
              //               },
              //               child: Container(
              //                 height: 32,
              //                 width: 32,
              //                 decoration: BoxDecoration(
              //                   shape: BoxShape.circle,
              //                 ),
              //                 child: ClipRRect(
              //                   borderRadius: BorderRadius.all(
              //                     Radius.circular(24),
              //                   ),
              //                   child:bUser!=null? Image.network(
              //                     bUser.businessAccountImage==null?"https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg":bUser.businessAccountImage.url,
              //                     fit: BoxFit.cover,
              //                   ):Icon(Icons.person),
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
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
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.black),
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
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController retypePasswordController = TextEditingController();

    showDialog(
      builder: (BuildContext context) {
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
                          hint: 'Current Password',
                          controller: currentPasswordController,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'New Password',
                          controller: newPasswordController,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Retype New Password',
                          controller: retypePasswordController,
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
                              onPressed: () {},
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
                              onPressed: () {},
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
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (_, __) {
              return Container(
                color: Colors.black,
                height: 200,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
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
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LoginUser(),
                                  ),
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
                              onPressed: () {},
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

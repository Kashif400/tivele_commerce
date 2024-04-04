import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/controllers/customer/getOrderByUserId.dart';
import 'package:e_commerce_foods/controllers/customer/orderReviewController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';
import 'package:e_commerce_foods/views/customer/customerLoginPage.dart';
import 'package:e_commerce_foods/views/customer/driverLocation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrdersPage extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrdersPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

  final getOrderByUserId getOrderByUserIdController =
      Get.put(getOrderByUserId());
  final OrderReviewController orderReviewController =
      Get.put(OrderReviewController());
  double _rating = 1;
  bool isBusy = false;
  double? updatedRating;
  int? OrderCount;
  String car =
      'https://static01.nyt.com/images/2007/06/15/automobiles/600-scion-01.jpg';

  @override
  initState() {
    super.initState();
    initdata();
    //  context.read<OrderProvider>().getOrderListByUserId();
    //context.read<BusinessUsersProvider>().getBussinessUser();
  }

  initdata() async {
    if (!globals.checkLogin) {
      setState(() {
        isBusy = true;
      });
      await getOrderByUserIdController.fetchorderbyuserid();
      setState(() {
        isBusy = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    //final ords = context.watch<OrderProvider>().myorder;
    if (!globals.checkLogin) {
      CheckListCount(getOrderByUserIdController.myorderList.length);
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text(
            'MY ORDERS',
            style: Global.style(
              size: 22,
              bold: true,
              caps: true,
            ),
          ),
          centerTitle: true,
        ),
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
                child: getOrderByUserIdController.myorderList.length == 0
                    ? Container(
                        child: Center(
                            child: Text(
                          "Not Data to show",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                        ),
                        child: getOrderByUserIdController.myorderList.length > 0
                            ? SingleChildScrollView(
                                child: Column(
                                  children: [
                                    ListView.separated(
                                      itemCount: getOrderByUserIdController
                                          .myorderList.length,
                                      physics: NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            vertical: 16,
                                          ),
                                          child: Row(
                                            children: [
                                              ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(24),
                                                ),
                                                child: getOrderByUserIdController
                                                            .myorderList[index]
                                                            .deliveryImage !=
                                                        ""
                                                    ? Image.network(
                                                        URLS.BASEURL +
                                                            getOrderByUserIdController
                                                                .myorderList[
                                                                    index]
                                                                .deliveryImage!,
                                                        height: 70,
                                                        width: 70,
                                                        fit: BoxFit.cover,
                                                      )
                                                    : Image.asset(
                                                        'assets/text.png',
                                                        height: 70,
                                                        width: MediaQuery.of(
                                                                    context)
                                                                .size
                                                                .width *
                                                            0.2,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.35,
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          getOrderByUserIdController
                                                              .myorderList[
                                                                  index]
                                                              .productName!,
                                                          style: Global.style(
                                                              size: 12,
                                                              bold: true),
                                                        ),
                                                        Text(
                                                          getOrderByUserIdController
                                                              .myorderList[
                                                                  index]
                                                              .status!,
                                                          // ords[index]
                                                          //     .product
                                                          //     .description,
                                                          style: Global.style(
                                                            size: 10,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(height: 8),
                                                ],
                                              ),
                                              SizedBox(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.05,
                                              ),
                                              Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      Get.to(DriverLocation(
                                                          getOrderByUserIdController
                                                              .myorderList[
                                                                  index]
                                                              .id));
                                                      print('iddddddddddddddddddddddddddddddddddddddddddddddddddd' +
                                                          getOrderByUserIdController
                                                              .myorderList[
                                                                  index]
                                                              .id!);
                                                      //          Get.to(AcceptDelivery(
                                                      // getOrderByIdController
                                                      //     .completedOrders[index],
                                                      // pickupAddress,
                                                      // getOrderByIdController
                                                      //     .completedOrders[index].id,
                                                      // customerAddress));
                                                    },
                                                    child: Image.asset(
                                                      'assets/traking.png',
                                                      height: 30,
                                                      width: 30,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.25,
                                                      child: Visibility(
                                                        visible:
                                                            getOrderByUserIdController
                                                                .myorderList[
                                                                    index]
                                                                .reviewOrder!,
                                                        child: InkWell(
                                                          child: Text(
                                                            "Leave Review",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          onTap: () {
                                                            leaveReviewDialog(
                                                                getOrderByUserIdController
                                                                    .myorderList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        ),
                                                      )),
                                                ],
                                              )
                                            ],
                                          ),
                                        );
                                      },
                                      separatorBuilder: (context, index) {
                                        return Container(
                                          height: 1,
                                          width: double.infinity,
                                          color: Colors.white,
                                        );
                                      },
                                    )

                                    // InkWell(
                                    //   onTap: (){
                                    //     leaveReviewDialog();
                                    //   },
                                    //   child: Padding(
                                    //     padding: EdgeInsets.symmetric(
                                    //       horizontal: 24,
                                    //       vertical: 16,
                                    //     ),
                                    //     child: Align(
                                    //       alignment: Alignment.centerRight,
                                    //       child: Text(
                                    //         'Leave Review',
                                    //         style: Global.style(
                                    //           size: 18,
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ),
                                    // )
                                  ],
                                ),
                              )
                            : Align(
                                alignment: Alignment.center,
                                child: Text(
                                  "",
                                  style: TextStyle(color: Colors.transparent),
                                )),
                      ),
                inAsyncCall: isBusy,
                // demo of some additional parameters
                // opacity: 0.5,
                progressIndicator: Container(
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  void leaveReviewDialog(orderId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? myName = prefs.getString("user_name");
    showAnimatedDialog(
      animationType: DialogTransitionType.sizeFade,
      curve: Curves.easeInCirc,
      duration: Duration(seconds: 1),
      builder: (BuildContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (_, __) {
              return Container(
                height: 390,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 4),
                ),
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
                        'Leave Review',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Text(
                            myName!,
                            textAlign: TextAlign.center,
                            style: Global.style(
                              size: 20,
                              bold: true,
                              caps: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          RatingBar.builder(
                            initialRating: 1,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            unratedColor: Colors.grey,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              _rating = rating;
                            },
                          ),
                          SizedBox(height: 12),
                          MyTextField(
                              hint: 'Review',
                              controller: reviewController,
                              lines: 3,
                              readOnly: false),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 110,
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
                        SizedBox(
                          width: 10,
                        ),
                        Container(
                          height: 35,
                          width: 110,
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
                                _Submit(orderId, context);
                              },
                              child: Text(
                                'Submit',
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

  CheckListCount(int count) async {
    if (count > 0) {
      if (isBusy) {
        setState(() {
          isBusy = true;
        });
      }
      await Future.delayed(Duration(seconds: 2));
      if (mounted) {
        setState(() {
          isBusy = false;
        });
      }
    } else {
      await Future.delayed(Duration(seconds: 2));
      if (mounted) {
        setState(() {
          isBusy = false;
        });
      }
    }
  }

  _Submit(orderId, BuildContext context) async {
    try {
      if (reviewController.text.isEmpty) {
        showErrorToast("Please enter Review");
        return;
      }
      Navigator.pop(context);
      setState(() {
        isBusy = true;
      });
      var userData = {
        'order_id': orderId,
        'review': reviewController.text,
        'rating': _rating.toString(),
      };
      await orderReviewController.fetchOrderReview(userData);
      setState(() {
        isBusy = false;
        reviewController.text = "";
        _rating = 1;
      });
      initdata();
    } catch (err) {
      showErrorToast(err.toString());
      setState(() {
        isBusy = false;
      });
      Navigator.pop(context);
      showErrorToast("Error while during your request");
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
}

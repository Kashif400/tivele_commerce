import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_foods/Provider/orders.dart';
import 'package:e_commerce_foods/controllers/customer/getOrderByUserId.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/service/Review/Reviews.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';

class MyOrders extends StatefulWidget {
  @override
  _MyOrdersState createState() => _MyOrdersState();
}

class _MyOrdersState extends State<MyOrders> {
  TextEditingController controller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  final getOrderByUserId getOrderByUserIdController =
      Get.put(getOrderByUserId());

  bool isBusy = false;
  double? updatedRating;
  int? OrderCount;
  String car =
      'https://static01.nyt.com/images/2007/06/15/automobiles/600-scion-01.jpg';

  @override
  initState() {
    super.initState();
    setState(() {
      isBusy = true;
    });
    initdata();
    //  context.read<OrderProvider>().getOrderListByUserId();
    //context.read<BusinessUsersProvider>().getBussinessUser();
  }

  initdata() async {
    await getOrderByUserIdController.fetchorderbyuserid();
    print(getOrderByUserIdController.myorderList[0].status);
  }

  @override
  Widget build(BuildContext context) {
    //final ords = context.watch<OrderProvider>().myorder;

    CheckListCount(getOrderByUserIdController.myorderList.length);
    double width = MediaQuery.of(context).size.width;
    // if (getOrderByUserIdController.myordersInfo.status == 200) {
    //   print(getOrderByUserIdController.myorderList[0].productName.toString() +
    //       "PRODUCT NAAAM");
    // }
    print(getOrderByUserIdController.myorderList.length);
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
        body: ModalProgressHUD(
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
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(24),
                                          ),
                                          child: Image.network(
                                            "https://static01.nyt.com/images/2007/06/15/automobiles/600-scion-01.jpg",
                                            // ords[index]
                                            //             .product
                                            //             .productImage ==
                                            //         null
                                            //     ? "https://static01.nyt.com/images/2007/06/15/automobiles/600-scion-01.jpg"
                                            //     : getOrderByUserIdController.myorderList[0].,
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Column(
                                          children: [
                                            Container(
                                              width: width - 118,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    getOrderByUserIdController
                                                        .myorderList[index]
                                                        .productName
                                                        .toString(),
                                                    style: Global.style(
                                                      size: 14,
                                                    ),
                                                  ),
                                                  Spacer(),
                                                  Container(
                                                    child: Row(
                                                      children: [
                                                        true
                                                            // ords[index]
                                                            //                 .product
                                                            //                 .ratingAverage ==
                                                            //             null ||
                                                            //         ords[index]
                                                            //                 .product
                                                            //                 .ratingAverage ==
                                                            //             0.0
                                                            ? InkWell(
                                                                child: Text(
                                                                  "Leave Review",
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .white),
                                                                ),
                                                                onTap: () {
                                                                  print(
                                                                      "called");
                                                                  leaveReviewDialog(
                                                                      getOrderByUserIdController
                                                                          .myorderList[
                                                                              index]
                                                                          .productId,
                                                                      getOrderByUserIdController
                                                                          .myorderList[
                                                                              index]
                                                                          .id);
                                                                },
                                                              )
                                                            // ignore: dead_code
                                                            : RatingBar.builder(
                                                                itemSize: 15,
                                                                initialRating:
                                                                    2,
                                                                // ords[
                                                                //         index]
                                                                //     .product
                                                                //     .ratingAverage,
                                                                minRating: 1,
                                                                direction: Axis
                                                                    .horizontal,
                                                                allowHalfRating:
                                                                    true,
                                                                itemCount: 5,
                                                                itemPadding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            4.0),
                                                                itemBuilder:
                                                                    (context,
                                                                            _) =>
                                                                        Icon(
                                                                  Icons.star,
                                                                  color: Colors
                                                                      .amber,
                                                                ),
                                                                onRatingUpdate:
                                                                    (rating) {
                                                                  print(rating);
                                                                },
                                                                ignoreGestures:
                                                                    true,
                                                              ),

                                                        // Icon(
                                                        //   Icons.star,
                                                        //   color: Colors.yellow[800],
                                                        //   size: 16,
                                                        // ),
                                                        // Icon(
                                                        //   Icons.star,
                                                        //   color: Colors.yellow[800],
                                                        //   size: 16,
                                                        // ),
                                                        // Icon(
                                                        //   Icons.star,
                                                        //   color: Colors.yellow[800],
                                                        //   size: 16,
                                                        // ),
                                                        // Icon(
                                                        //   Icons.star,
                                                        //   color: Colors.yellow[800],
                                                        //   size: 16,
                                                        // ),
                                                        // Icon(
                                                        //   Icons.star,
                                                        //   color: Colors.yellow[800],
                                                        //   size: 16,
                                                        // ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                            SizedBox(height: 8),
                                            Container(
                                              width: width - 118,
                                              child: Text(
                                                getOrderByUserIdController
                                                    .myorderList[index].status
                                                    .toString(),
                                                // ords[index]
                                                //     .product
                                                //     .description,
                                                style: Global.style(
                                                  size: 10,
                                                ),
                                              ),
                                            )
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
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void leaveReviewDialog(productId, orderId) {
    showDialog(
      builder: (context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (_, __) {
              return Container(
                  color: Colors.black,
                  height: 390,
                  child: SingleChildScrollView(
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
                              MyTextField(
                                hint: 'Your Name',
                                controller: nameController,
                                readOnly: false,
                              ),
                              SizedBox(height: 24),
                              RatingBar.builder(
                                initialRating: 5,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemPadding:
                                    EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  setState(() {
                                    updatedRating = rating;
                                  });
                                  print(rating);
                                },
                              ),
                              SizedBox(height: 12),
                              MyTextField(
                                hint: 'Review',
                                controller: reviewController,
                                lines: 3,
                                readOnly: false,
                              ),
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
                                    _Submit(productId, orderId);
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
                  ));
            },
          ),
        );
      },
      context: context,
    );
  }
  // Future<bool> _loadMore() async {
  //   print("onLoadMore");
  //   var length = context.read<OrderProvider>().myorder.length;
  //   await Future.delayed(Duration(seconds: 0, milliseconds: 100));
  //   await context.read<OrderProvider>().getMoreOrderListByUserId(length);
  //   return true;
  // }

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

  _Submit(productId, orderId) async {
    try {
      if (nameController.text.isEmpty) {
        showErrorToast("Please enter Name");
        return;
      }
      if (reviewController.text.isEmpty) {
        showErrorToast("Please enter Review");
        return;
      }
      setState(() {
        isBusy = true;
      });
      var userId = await SessionService.retrieveUserId();
      var review = {
        'userId': userId,
        'productId': productId,
        'orderId': orderId,
        'comment': reviewController.text,
        'rating': updatedRating == null ? 5 : updatedRating,
      };
      var response = await ReviewsService.create(review);
      if (response) {
        showSuccessToast("Review is submitted");
        Navigator.pop(context);
        context.read<OrderProvider>().getOrderListByUserId();
        setState(() {
          isBusy = false;
        });
      } else {
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

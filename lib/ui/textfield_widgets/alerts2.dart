import 'package:e_commerce_foods/Provider/driver.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/Order/orders.dart';
import 'package:e_commerce_foods/service/order/orders_service.dart';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Alerts2 extends StatefulWidget {
  @override
  _Alerts2State createState() => _Alerts2State();
}

class _Alerts2State extends State<Alerts2> {
  @override
  void initState() {
    super.initState();
    //context.read<DriversProvider>().getDriverOrders();
  }

  @override
  Widget build(BuildContext context) {
    // final loading = context.watch<DriversProvider>().loading;
    // final driverOrders = context.watch<DriversProvider>().DriverOrders;
    // final orderLocation = context.watch<DriversProvider>().Placemarks;
    // if (driverOrders.length > 0) {
    //   setState(() {
    //     isBusy = false;
    //   });
    // }
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            title: Text(
              'TIVELE ALERTS',
              style: Global.style(
                bold: true,
                size: 22,
              ),
            ),
          ),
          body: ModalProgressHUD(
            child: Container(
                padding: EdgeInsets.all(16),
                child: ListView.separated(
                  itemCount: 5,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: 48);
                  },
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Colors.orange,
                              size: 32,
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                "Food" + " to be delivered",
                                style: Global.style(
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Pickup " +
                              "Adress"
                                  ", " +
                              "City" +
                              ", " +
                              "State",
                          style: Global.style(
                            size: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          "Drop off: " + "Drop Location",
                          style: Global.style(
                            size: 16,
                          ),
                        ),
                        SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  // DeliveryAccepted(
                                  //     driverOrders[index],
                                  //     orderLocation[index],
                                  //     driverOrders[index].id);
                                },
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        // color: Colors.white,
                                        ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.check,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        'Accept',
                                        style: Global.style(
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    borderRadius: BorderRadius.circular(10),
                                    // border: Border.all(
                                    //   color: Colors.white,
                                    // ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.notifications_paused_outlined,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        'Ignore',
                                        style: Global.style(
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {},
                                child: Container(
                                  margin: EdgeInsets.only(right: 10),
                                  padding: EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                        // color: Colors.white,
                                        ),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.clear,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Text(
                                        'Decline',
                                        style: Global.style(
                                          size: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                )
                //     : //CloseLoader(),
                // Container(
                //   constraints: BoxConstraints.expand(),
                //   color: Colors.black,
                //   child: Center(
                //     child: Container(
                //       child: Text(
                //         "No Data to show",
                //         style: TextStyle(
                //             color: Colors.white, fontSize: 20.0),
                //       ),
                //     ),
                //   ),
                // )
                ),
            inAsyncCall: false,
            // demo of some additional parameters
            opacity: 0.5,
            progressIndicator: Container(
              color: Colors.black,
              constraints: BoxConstraints.expand(),
              child: Center(
                child: Container(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  DeliveryAccepted(OrdersItems order, String orderLocation, String Id) async {
    try {
      context.read<DriversProvider>().loading = true;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? accountid = await prefs.getString("DriverAccountID");
      var Order = {
        'driverAccountId': accountid,
        'id': Id,
      };
      var response = await OrdersService.AcceptOrder(Order);
      if (response) {
        // Navigator.of(context).push(
        //   MaterialPageRoute(
        //     builder: (_) => AcceptDelivery(order, orderLocation, Id),
        //   ),
        // );
      }
    } catch (err) {
      // final requestbody = json.decode(err.body);
      // final data = requestbody['error'];
      // showErrorToast(data["message"]);
      showErrorToast(err.toString());
      print(err);
    }
    context.read<DriversProvider>().loading = false;
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

  CloseLoader() {
    Future.delayed(const Duration(milliseconds: 4000), () {
      context.read<DriversProvider>().loading = false;
    });
  }
}

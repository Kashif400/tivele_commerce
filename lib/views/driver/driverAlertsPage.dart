import 'package:e_commerce_foods/Provider/driver.dart';
import 'package:e_commerce_foods/controllers/driver/acceptedOrderController.dart';
import 'package:e_commerce_foods/controllers/driver/declineOrderController.dart';
import 'package:e_commerce_foods/controllers/driver/orderController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/ordersModel.dart';
import 'package:e_commerce_foods/views/driver/accept_delivery.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class DriverAlertPage extends StatefulWidget {
  @override
  _DriverAlertPageState createState() => _DriverAlertPageState();
}

class _DriverAlertPageState extends State<DriverAlertPage> {
  final OrderController orderDataController = Get.put(OrderController());
  final DeclineOrderController declineOrderController =
      Get.put(DeclineOrderController());
  final AcceptedOrderController acceptedOrderController =
      Get.put(AcceptedOrderController());
  List<Datum> orderList = [];
  bool checkOrder = true;
  @override
  Widget build(BuildContext context) {
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
          body: Obx(() {
            if (orderDataController.isLoading.value) {
              return Container(
                color: Colors.black,
                constraints: BoxConstraints.expand(),
                child: Center(
                  child: Container(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                ),
              );
            } else if (orderDataController.isListNull.value) {
              return Container(
                constraints: BoxConstraints.expand(),
                color: Colors.black,
                child: Center(
                  child: Container(
                    child: Text(
                      "No orders available at the moment!",
                      style: TextStyle(color: Colors.white, fontSize: 20.0),
                    ),
                  ),
                ),
              );
            } else {
              if (checkOrder) {
                orderList = orderDataController.orderINfo.value.data!.toList();
                checkOrder = false;
              }
              return orderList.length >= 1
                  ? Container(
                      padding: EdgeInsets.all(16),
                      child: ListView.separated(
                        itemCount: orderList.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(height: 20);
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
                                      orderList[index].productName! +
                                          " to be delivered",
                                      style: Global.style(
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text.rich(
                                TextSpan(
                                  text: 'Pickup Location: ',
                                  style: Global.style(
                                    color: Colors.white70,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: orderDataController
                                          .pickupLocation[index],
                                      style: Global.style(
                                        bold: true,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text.rich(
                                TextSpan(
                                  text: 'Dropoff Location: ',
                                  style: Global.style(
                                    color: Colors.white70,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: orderDataController
                                          .dropoffLocation[index],
                                      style: Global.style(
                                        bold: true,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: 15),
                              Center(
                                child: Text.rich(
                                  TextSpan(
                                    text: 'Distance is: ',
                                    style: Global.style(
                                      color: Colors.white70,
                                    ),
                                    children: [
                                      TextSpan(
                                        // text: orderDataController.distance[index]+" km",
                                        text: double.parse(
                                                    orderList[index].distance!)
                                                .toStringAsFixed(2) +
                                            " km",
                                        style: Global.style(
                                          bold: true,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: GestureDetector(
                                      onTap: () {
                                        DeliveryAccepted(
                                            orderList[index],
                                            orderDataController
                                                .pickupLocation[index],
                                            orderList[index].id,
                                            orderDataController
                                                .pickupLocation[index]);
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.green,
                                          // border: Border.all(
                                          //   color: Colors.white,
                                          // ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                      onTap: () {
                                        setState(() {
                                          orderList.remove(orderList[index]);
                                          orderDataController.pickupLocation
                                              .remove(orderDataController
                                                  .pickupLocation[index]);
                                          orderDataController.dropoffLocation
                                              .remove(orderDataController
                                                  .dropoffLocation[index]);
                                          orderDataController.distance.remove(
                                              orderDataController
                                                  .distance[index]);
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.orange,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          // border: Border.all(
                                          //   color: Colors.white,
                                          // ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons
                                                  .notifications_paused_outlined,
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
                                      onTap: () {
                                        Map<String, Object?> userData = {
                                          'order_id': orderList[index].id,
                                        };
                                        declineOrderController
                                            .fetchDeclineOrder(userData);
                                        setState(() {
                                          orderList.remove(orderList[index]);
                                          orderDataController.pickupLocation
                                              .remove(orderDataController
                                                  .pickupLocation[index]);
                                          orderDataController.dropoffLocation
                                              .remove(orderDataController
                                                  .dropoffLocation[index]);
                                          orderDataController.distance.remove(
                                              orderDataController
                                                  .distance[index]);
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          border: Border.all(
                                              // color: Colors.white,
                                              ),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                      ))
                  : Container(
                      constraints: BoxConstraints.expand(),
                      color: Colors.black,
                      child: Center(
                        child: Container(
                          child: Text(
                            "No orders available at the moment!",
                            style:
                                TextStyle(color: Colors.white, fontSize: 20.0),
                          ),
                        ),
                      ),
                    );
            }
          })),
    );
  }

  DeliveryAccepted(
      Datum order, String pickup, String? Id, String userLocation) async {
    try {
      acceptedOrderController.fetchAcceptedOrder(Id).then((value) => {
            Get.to(AcceptDelivery(order, pickup, Id, userLocation)),
          });
    } catch (err) {
      // final requestbody = json.decode(err.body);
      // final data = requestbody['error'];
      // showErrorToast(data["message"]);
      showErrorToast(err.toString());
      print(err);
    }
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

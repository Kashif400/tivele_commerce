import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e_commerce_foods/controllers/driver/getOrderByIdController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/views/driver/accept_delivery.dart';
import 'package:e_commerce_foods/views/driver/order_delivery.dart';

import 'driverAlertsPage.dart';
import 'driverLoginPage.dart';

class DriverHomePage extends StatefulWidget {
  @override
  // final String driverAccountId;
  // const HomeDriver(this.driverAccountId);
  _DriverHomePageState createState() => _DriverHomePageState();
}

class _DriverHomePageState extends State<DriverHomePage> {
  TextEditingController controller = TextEditingController();
  bool remember = false;
  String AccountId = "asdasd";
  bool? isBusy;
  final GetOrderByIdController getOrderByIdController =
      Get.put(GetOrderByIdController());
  String? myName = "Driver";
  String? dLat;
  String? dLon;
  String? token;

  @override
  void initState() {
    super.initState();
    // setState(() {
    //   isBusy = true;
    // });
    initdata();

    // context.read<DriversProvider>().getCurrentDrivers();
  }

  initdata() async {
    setState(() {
      isBusy = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      myName = pref.getString("user_name");
      token = pref.getString("token");
      print("tokennnnnnnnnn driverrrr :::   " + token!);
    });
    await getOrderByIdController.fetchgetorderbyid().then((value) => {
          setState(() {
            isBusy = false;
          }),
        });
  }

  String _getDateText(DateTime? createdAt) {
    var txt = '-';
    var formatter = DateFormat('dd MMM yyyy');
    if (createdAt != null) {
      txt = formatter.format(createdAt);
    }
    return txt;
  }

  String? _getTimeText(DateTime? createdAt) {
    var txt = '-';
    var local;
    var local_modified;
    String? time;
    var formatter = DateFormat('hh:mm:ss');
    if (createdAt != null) {
      txt = formatter.format(createdAt);
      local = formatter.parseUTC(txt).toLocal();
      local_modified = DateFormat('hh:mm a').format(local);
      time = local_modified.toString();
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    String image =
        'https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg';
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: ModalProgressHUD(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 12,
              ),
              child: true
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              height: 80,
                              width: 80,
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
                                child: Image.network(
                                  "https://t4.ftcdn.net/jpg/02/23/50/73/360_F_223507349_F5RFU3kL6eMt5LijOaMbWLeHUTv165CB.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // SizedBox(width: 12),
                            Text(
                              myName!,
                              // divUser.driverName == null
                              //     ? "Driver"
                              //     : divUser.driverName,
                              style: Global.style(
                                bold: true,
                                size: 18,
                              ),
                            ),

                            SizedBox(
                              width: 20.0,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
                                Get.offAll(DriverLoginPage());
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Text(
                          'Completed Orders',
                          style: Global.style(
                            bold: true,
                            size: 22,
                          ),
                        ),
                        SizedBox(height: 32),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: false,
                            itemCount:
                                getOrderByIdController.completedOrders.length,
                            //divUser.orders.length,
                            itemBuilder: (_, index) {
                              return Container(
                                child: Row(
                                  children: [
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.3,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          getOrderByIdController
                                                      .completedOrders[index]
                                                      .productName ==
                                                  null
                                              ? "product Name"
                                              : getOrderByIdController
                                                  .completedOrders[index]
                                                  .productName!,
                                          textAlign: TextAlign.center,
                                          style: Global.style(size: 10),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _getDateText(getOrderByIdController
                                              .completedOrders[index]
                                              .deliveryTime),
                                          style: Global.style(size: 10),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.15,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.white,
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          _getTimeText(getOrderByIdController
                                              .completedOrders[index]
                                              .deliveryTime)!,
                                          style: Global.style(size: 10),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        // final pickupCoordinates = new Coordinates(double.parse(getOrderByIdController.completedOrders[index].productLatitude), double.parse(getOrderByIdController.completedOrders[index].productLongitude));
                                        // var pickupAddresses = await Geocoder.local.findAddressesFromCoordinates(pickupCoordinates);
                                        // var pickupFirst = pickupAddresses.first;
                                        List<geo.Placemark> placemarks =
                                            await geo.placemarkFromCoordinates(
                                                double.parse(
                                                    getOrderByIdController
                                                        .completedOrders[index]
                                                        .productLatitude!),
                                                double.parse(
                                                    getOrderByIdController
                                                        .completedOrders[index]
                                                        .productLongitude!));
                                        String pickupAddress = globals
                                            .addressFromLatLng(placemarks);

                                        // final dropCoordinates = new Coordinates(double.parse(getOrderByIdController.completedOrders[index].userLatitude), double.parse(getOrderByIdController.completedOrders[index].userLongitude));
                                        // var dropAddresses = await Geocoder.local.findAddressesFromCoordinates(dropCoordinates);
                                        // var dropFirst = dropAddresses.first;
                                        List<geo.Placemark> placemarks2 =
                                            await geo.placemarkFromCoordinates(
                                                double.parse(
                                                    getOrderByIdController
                                                        .completedOrders[index]
                                                        .productLatitude!),
                                                double.parse(
                                                    getOrderByIdController
                                                        .completedOrders[index]
                                                        .productLongitude!));
                                        String customerAddress = globals
                                            .addressFromLatLng(placemarks2);

                                        if (getOrderByIdController
                                                .completedOrders[index]
                                                .status ==
                                            "Accepted") {
                                          Get.to(AcceptDelivery(
                                              getOrderByIdController
                                                  .completedOrders[index],
                                              pickupAddress,
                                              getOrderByIdController
                                                  .completedOrders[index].id,
                                              customerAddress));
                                        }
                                        if (getOrderByIdController
                                                .completedOrders[index]
                                                .status ==
                                            "Picked") {
                                          Get.to(OrderDelivery(
                                              getOrderByIdController
                                                  .completedOrders[index],
                                              pickupAddress,
                                              getOrderByIdController
                                                  .completedOrders[index].id,
                                              customerAddress));
                                        }
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.25,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: getOrderByIdController
                                                      .completedOrders[index]
                                                      .status ==
                                                  "Accepted"
                                              ? Colors.orange
                                              : getOrderByIdController
                                                          .completedOrders[
                                                              index]
                                                          .status ==
                                                      "Picked"
                                                  ? Colors.blue
                                                  : Colors.transparent,
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            getOrderByIdController
                                                .completedOrders[index].status!,
                                            style: Global.style(size: 10),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                // Navigator.of(context).push(
                                //   MaterialPageRoute(
                                //     builder: (_) => Alerts(),
                                //   ),
                                // );
                                Get.to(DriverAlertPage());
                              },
                              icon: Icon(
                                Icons.notifications,
                                color: Colors.amber,
                                size: 36,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.volume_off,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : CloseLoader(),
            ),
            inAsyncCall: getOrderByIdController.isLoading.value,
            // demo of some additional parameters
            //opacity: 0.5,
            progressIndicator: Container(
              color: Colors.black,
              constraints: BoxConstraints.expand(),
              child: Center(
                child: Container(
                  //color: Colors.black,
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

  CloseLoader() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        isBusy = false;
      });
    });
  }
}

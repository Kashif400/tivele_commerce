import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/ordersModel.dart';
import 'package:e_commerce_foods/views/customer/explorePage.dart';

import '../../controllers/driver/orderPickedByDriverController.dart';

class DriverLocation extends StatefulWidget {
  // final Datum order;
  // final String pickUp;
  final String? OrderId;
  // final String dropOff;

  const DriverLocation(this.OrderId);

  @override
  State<DriverLocation> createState() => _DriverLocationState();
}

class _DriverLocationState extends State<DriverLocation> {
  Set<Marker> _markers = {};
  List<Datum> driverlocation = [];
  FirebaseFirestore db = FirebaseFirestore.instance;

  Position? position;
  late bool isBusy;
  var picker = ImagePicker();
  var latitude, longitude;
  var orderlongitude, orderlatitide;
  File? _profileImage;
  bool _newProfileImage = false;
  String? dropoffLocation;
  String? ImageId;
  double? driverlat, driverlong;
  DocumentSnapshot? documentSnapshot;

  final orderPickedByDriverController acceptOrderController =
      Get.put(orderPickedByDriverController());
  DocumentSnapshot? snapshot;
  void getData() async {
    //use a Async-await function to get the data
    final dynamic data = await db
        .collection('location')
        .doc(widget.OrderId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        print('Document data: ${documentSnapshot.get('latitide').toString()}');
        driverlat = documentSnapshot.get('latitide');
        driverlong = documentSnapshot.get('longitude');
      } else {
        print('Document does not exist on the database');
      }
    });
  }

  @override
  void initState() {
    super.initState();
    getData();

    // final dataa = db.collection("location").doc(widget.OrderId).get().then((value) {
    //   print('latitideeeeeeeeeeeeeeeeeeeeeeeee' + value.data()['latitide']);
    // orderlatitide = value.data()['latitide'];
    // driverlat =value.data()['latitide'];
    // driverlong =value.data()['longitude'];
    // });

    print("ali");
    print('order iddddddddddddddddddddd' + widget.OrderId!);

    setState(() {
      isBusy = true;

      orderlatitide = driverlat;
      orderlongitude = driverlong;

      // orderlongitude = widget.order.productLongitude;
      // driverlocation.add(Datum(driverId: latitude));
    });
    GetLocation();
    //makeaddress();
  }

  @override
  Widget build(BuildContext context) {
    getData();
    print('latttttttttt : ${driverlat.toString()}');

    double width = MediaQuery.of(context).size.width;
    // getData();
    String map =
        'https://cloud.google.com/maps-platform/images/maps-customizations.jpg';
    return WillPopScope(
      onWillPop: () {
        Get.offAll(ExplorePage());
      } as Future<bool> Function()?,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.black,
              title: Text(
                'Tracking Driver Location',
                style: Global.style(
                  bold: true,
                  size: 19,
                ),
              ),
            ),
            body: ModalProgressHUD(
              child: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: driverlat != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 200,
                              child: position != null
                                  ? Stack(
                                      children: [
                                        GoogleMap(
                                          onMapCreated: OnMapCreated,
                                          mapToolbarEnabled: true,
                                          onTap: (_) {
                                            tap();
                                          },
                                          markers: {
                                            Marker(
                                              position: LatLng(
                                                // double.parse(widget
                                                //     .order.productLatitude),
                                                // double.parse(widget
                                                //     .order.productLongitude)
                                                double.parse(
                                                    driverlat.toString()),
                                                double.parse(
                                                    driverlong.toString()),
                                                // double.parse('34.0071847'),
                                                // double.parse('71.6049872'),
                                              ),
                                              markerId:
                                                  MarkerId("secondMarker"),
                                              icon: BitmapDescriptor
                                                  .defaultMarkerWithHue(
                                                      BitmapDescriptor.hueRed),
                                              onTap: () {
                                                MapsLauncher.launchCoordinates(
                                                    position!.latitude,
                                                    position!.longitude);
                                              },
                                              draggable: false,
                                              consumeTapEvents: false,
                                              visible: true,
                                            ),
                                          },
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                              // double.parse(widget
                                              //     .order.productLatitude),
                                              // double.parse(widget
                                              //     .order.productLongitude)
                                              double.parse(
                                                  driverlat.toString()),
                                              double.parse(
                                                  driverlong.toString()),
                                              // double.parse('34.0071847'),
                                              // double.parse('71.6049872'),
                                            ),
                                            zoom: 15.0,
                                          ),
                                          myLocationEnabled: true,
                                          myLocationButtonEnabled: true,
                                        ),
                                        Positioned(
                                          top: 10,
                                          left: 10,
                                          child: SizedBox(
                                            height: 37,
                                            width: 37,
                                            child: MaterialButton(
                                                color: Colors.white
                                                    .withOpacity(0.8),
                                                padding: EdgeInsets.all(0),
                                                child: Center(
                                                  child: Icon(
                                                    Icons.directions,
                                                    color: Colors.black87,
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final availableMaps =
                                                      await MapLauncher
                                                          .installedMaps;
                                                  await availableMaps.first
                                                      .showMarker(
                                                    coords: Coords(
                                                      // double.parse(widget
                                                      //     .order
                                                      //     .productLatitude),
                                                      // double.parse(widget
                                                      //     .order
                                                      //     .productLongitude)
                                                      double.parse(
                                                          driverlat.toString()),
                                                      double.parse(driverlong
                                                          .toString()),
                                                      // double.parse(
                                                      //     '34.0071847'),
                                                      // double.parse(
                                                      //     '71.6049872'),
                                                    ),
                                                    title: "Pickup Order Place",
                                                  );
                                                  // if (await MapLauncher.isMapAvailable(availableMaps.google)) {
                                                  //     await MapLauncher.showMarker(
                                                  //     mapType: MapType.google,
                                                  //     coords: Coords(37.759392, -122.5107336),
                                                  //     title: title,
                                                  //     description: description,
                                                  //   );
                                                  //   }
                                                }),
                                          ),
                                        )
                                      ],
                                    )
                                  : SizedBox(),
                            ),
                            SizedBox(height: 32),
                          ],
                        )
                      : CloseLoader(),
                ),
              ),
              inAsyncCall: isBusy,
              // demo of some additional parameters
              opacity: 0.5,
              progressIndicator: Container(
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
              ),
            )),
      ),
    );
  }

  GetLocation() async {
    // position = await Geolocator.getCurrentPosition(
    //     desiredAccuracy: LocationAccuracy.high);
    Position? pos;
    try {
      pos = await Global.determinePosition();
      if (pos == null) {
        return;
      }
    } catch (e) {
      Fluttertoast.showToast(msg: e.toString());
    }

    setState(() {
      position = pos;
    });

    List<Placemark> placemarks = await placemarkFromCoordinates(
      // double.parse(widget.order.productLatitude),
      // double.parse(widget.order.productLongitude)
      // double.parse('34.0071847'), double.parse('71.6049872'),
      double.parse(driverlat.toString()), double.parse(driverlong.toString()),
    );

    if (placemarks.length > 0) {
      var driverCurrentLocation = placemarks[0];
      setState(() {
        dropoffLocation = driverCurrentLocation.name! +
            ", " +
            driverCurrentLocation.thoroughfare! +
            ", " +
            driverCurrentLocation.subLocality! +
            ", " +
            driverCurrentLocation.locality!;
      });
    }
  }

  CloseLoader() {
    Future.delayed(const Duration(milliseconds: 3000), () {
      setState(() {
        isBusy = false;
      });
    });
  }

  // Future<void> _SubmitDelivery() async {
  //   // var value = await Global.calculateDistanceJustValue(position.latitude, position.longitude, widget.order.product.businessAccount.location.latitude, widget.order.product.businessAccount.location.longitude);
  //   // var dis = double.parse(value);
  //   // if(dis > 0.5){
  //   //   Fluttertoast.showToast(msg: "You are not at pickup location!");
  //   //   return;
  //   // }
  //   if (_profileImage == null) {
  //     showErrorToast("Please attach file");
  //     return false;
  //   }
  //   setState(() {
  //     isBusy = true;
  //   });
  //   // var Status = {'status': 2, 'imageId': ImageId, 'id': widget.OrderId};
  //   // var response = await OrdersService.UpdateOrderStatus(Status);
  //   // if (response) {
  //   if (acceptOrderController.orderINfo.value.status == 200) {
  //     Navigator.of(context).pushAndRemoveUntil(
  //       MaterialPageRoute(
  //         builder: (_) => OrderDelivery(
  //             widget.order, widget.pickUp, widget.OrderId, widget.dropOff),
  //       ),
  //       (_) => false,
  //     );
  //   } else {
  //     globals
  //         .showErrorSnackBar("Error while uploading image \n please try again");
  //   }
  // }

  void OnMapCreated(GoogleMapController controller) {
    setState(() {
      if (position != null) {
        latitude = position!.latitude;
        longitude = position!.longitude;
        _markers.add(Marker(
          markerId: MarkerId("Id-1"),
          position: LatLng(position!.latitude, position!.longitude),
        ));
      }
    });
  }

  void tap() {
    MapsLauncher.launchCoordinates(latitude, longitude);
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

  // void makeaddress() async{
  //   final coordinate=new Coordinates(orderlatitide, orderlongitude);
  //   var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinate);
  //   var first=addresses.first;
  //  // OrderAddress=first.thoroughfare+first.locality+first.subLocality;
  //   print(first);
  // }
}

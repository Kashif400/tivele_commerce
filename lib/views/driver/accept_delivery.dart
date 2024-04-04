import 'dart:io';

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
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:e_commerce_foods/controllers/driver/orderPickedByDriverController.dart';
import 'package:e_commerce_foods/controllers/uploadPicController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/ordersModel.dart';
import 'package:e_commerce_foods/views/driver/driverHomePage.dart';
import 'package:e_commerce_foods/views/driver/order_delivery.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AcceptDelivery extends StatefulWidget {
  final Datum order;
  final String pickUp;
  final String? OrderId;
  final String dropOff;
  const AcceptDelivery(this.order, this.pickUp, this.OrderId, this.dropOff);
  @override
  _AcceptDeliveryState createState() => _AcceptDeliveryState();
}

class _AcceptDeliveryState extends State<AcceptDelivery> {
  String? OrderAddress;
  final UploadPicController uploadPicController =
      Get.put(UploadPicController());
  Map<MarkerId, Marker> markers = <MarkerId, Marker>{};
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

  final orderPickedByDriverController acceptOrderController =
      Get.put(orderPickedByDriverController());

  Future<void> addLoccation() async {
    // Call the user's CollectionReference to add a new user
    return await db
        .collection('location')
        .doc(widget.OrderId)
        .set({
          'orderId': widget.OrderId, //
          'longitude': longitude, //
          'latitide': latitude //
        })
        .then((value) => print(" Added"))
        .catchError((error) => print("Failed to add : $error"));
  }

  Future<void> locationUpdate() async {
    // Call the user's CollectionReference to add a new user
    return await db
        .collection('location')
        .doc(widget.OrderId)
        .update({'longitude': longitude, 'latitide': latitude})
        .then((value) => print(" update"))
        .catchError((error) => print("Failed to update : $error"));
  }

  @override
  void initState() {
    super.initState();
    print("ali");
    addLoccation();

    //print(widget.order.product.businessAccount.location.latitude);
    setState(() {
      isBusy = true;
      orderlatitide = widget.order.productLatitude;
      orderlongitude = widget.order.productLongitude;
      // driverlocation.add(Datum(driverId: latitude));
    });
    GetLocation();
    //makeaddress();
  }

  @override
  Widget build(BuildContext context) {
    locationUpdate();
    double width = MediaQuery.of(context).size.width;
    String map =
        'https://cloud.google.com/maps-platform/images/maps-customizations.jpg';
    return WillPopScope(
      onWillPop: () {
        Get.offAll(DriverHomePage());
      } as Future<bool> Function()?,
      child: SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.black,
              title: Text(
                'TIVELE DELIVERY',
                style: Global.style(
                  bold: true,
                  size: 22,
                ),
              ),
            ),
            body: ModalProgressHUD(
              child: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: dropoffLocation != null
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text.rich(
                              TextSpan(
                                text: 'Pickup Location: ',
                                style: Global.style(
                                  color: Colors.white70,
                                ),
                                children: [
                                  TextSpan(
                                    text: widget.pickUp,
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
                                    text: widget.dropOff,
                                    style: Global.style(
                                      bold: true,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
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
                                            // Marker(position: LatLng(position.latitude,position.longitude),
                                            //   markerId: MarkerId("firstMarker"),
                                            //   icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
                                            //   onTap: (){},
                                            //   draggable: false,
                                            //   consumeTapEvents: false,
                                            //   visible: true,
                                            // ),
                                            Marker(
                                              position: LatLng(
                                                  double.parse(widget
                                                      .order.productLatitude!),
                                                  double.parse(widget.order
                                                      .productLongitude!)),
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
                                                double.parse(widget
                                                    .order.productLatitude!),
                                                double.parse(widget
                                                    .order.productLongitude!)),
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
                                                        double.parse(widget
                                                            .order
                                                            .productLatitude!),
                                                        double.parse(widget
                                                            .order
                                                            .productLongitude!)),
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
                            Text(
                              'Upload  once received',
                              style: Global.style(
                                size: 18,
                              ),
                            ),
                            SizedBox(height: 12),
                            InkWell(
                              onTap: _getImage,
                              child: Container(
                                height: width / 1.9,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: _profileImage == null
                                    ? Icon(
                                        Icons.add_a_photo_outlined,
                                        color: Colors.white,
                                        size: 60,
                                      )
                                    : Image.file(_profileImage!),
                              ),
                            ),
                            SizedBox(height: 32),
                            Align(
                              alignment: Alignment.center,
                              child: ConfirmationSlider(
                                onConfirmation: () {
                                  _SubmitDelivery();
                                  // Navigator.of(context).pushAndRemoveUntil(
                                  //   MaterialPageRoute(
                                  //     builder: (_) => HomeDriver(),
                                  //   ), (_)=>false,
                                  // );
                                },
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                textStyle: Global.style(
                                  color: Colors.black,
                                  size: 16,
                                ),
                                text: 'Swipe to Pickup',
                                height: 50,
                              ),
                            ),
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
      // _markers.add(new Marker(position:  new LatLng(pos.latitude, pos.longitude),icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
      // _markers.add(new Marker(position:  new LatLng(31.502934, 74.364983),icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed)));
      // points.add(new LatLng( double.parse(widget.order.product.businessAccount.location.latitude) , double.parse(widget.order.product.businessAccount.location.longitude)));
    });
    // var uuid = Uuid();
    // var markerIdVal = uuid.v4();
    // final MarkerId markerId = MarkerId(markerIdVal);
    //
    // // creating a new MARKER
    // final Marker marker = Marker(
    //   markerId: markerId,
    //   position: LatLng(31.504453,74.367309),
    //   infoWindow: InfoWindow(title: markerIdVal, snippet: '*'),
    //   onTap: () {
    //     // _onMarkerTapped(markerId);
    //   },
    // );
    //
    // setState(() {
    //   // adding a new marker to map
    //   markers[markerId] = marker;
    // });
    //
    // var newMarkerIdVal = uuid.v4();
    // final MarkerId newMarkerId = MarkerId(newMarkerIdVal);
    //
    // // creating a new MARKER
    // final Marker newMarker = Marker(
    //   markerId: newMarkerId,
    //   position: LatLng(31.504453,74.367309),
    //   infoWindow: InfoWindow(title: newMarkerIdVal, snippet: '*'),
    //   onTap: () {
    //     // _onMarkerTapped(markerId);
    //   },
    // );
    //
    // setState(() {
    //   // adding a new marker to map
    //   markers[newMarkerId] = newMarker;
    // });

    List<Placemark> placemarks = await placemarkFromCoordinates(
        double.parse(widget.order.productLatitude!),
        double.parse(widget.order.productLongitude!));
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

  void _getImage() async {
    try {
      final pickedFile = await picker.pickImage(
          source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
      if (pickedFile != null) {
        setState(() {
          _newProfileImage = true;
          _profileImage = File(pickedFile.path);
        });

        uploadPic(_profileImage!);
        // var response = await OrdersService.productUpload(
        //     _profileImage); ///////////////////////////
        // if (response != null) {
        //   ImageId = response;
        // }
      } else {
        setState(() {
          _newProfileImage = false;
          _profileImage = null;
        });
      }
    } catch (err) {
      print(err);
    }
  }

  uploadPic(File file) async {
    setState(() {
      isBusy = true;
    });
    String medias = "";
    await uploadPicController.fetchPic(
        file, file.path.split("/").last.toString(), 4, "Pickp Selfie");
    if (uploadPicController.picINfo.value.status == 200) {
      medias = medias + uploadPicController.picINfo.value.data! + ",";
    } else {
      print("error 00");
      globals.showErrorToast("Upload Images Error!");
    }

    medias = medias.substring(
        0, medias.length - 1); //// this is file's name now transfer it to api

    await acceptOrderController.fetchorderpickedbydriver(
        medias, widget.order.id);
    if (acceptOrderController.orderINfo.value.status == 200) {
      setState(() {
        isBusy = false;
      });
    } else {
      globals.showErrorSnackBar("Error occured, Please try again");
      setState(() {
        isBusy = false;
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

  dynamic _SubmitDelivery() async {
    // var value = await Global.calculateDistanceJustValue(position.latitude, position.longitude, widget.order.product.businessAccount.location.latitude, widget.order.product.businessAccount.location.longitude);
    // var dis = double.parse(value);
    // if(dis > 0.5){
    //   Fluttertoast.showToast(msg: "You are not at pickup location!");
    //   return;
    // }
    if (_profileImage == null) {
      showErrorToast("Please attach file");
      return false;
    }
    setState(() {
      isBusy = true;
    });
    // var Status = {'status': 2, 'imageId': ImageId, 'id': widget.OrderId};
    // var response = await OrdersService.UpdateOrderStatus(Status);
    // if (response) {
    if (acceptOrderController.orderINfo.value.status == 200) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) => OrderDelivery(
              widget.order, widget.pickUp, widget.OrderId, widget.dropOff),
        ),
        (_) => false,
      );
    } else {
      globals
          .showErrorSnackBar("Error while uploading image \n please try again");
    }
  }

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

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
import 'package:e_commerce_foods/controllers/driver/orderDeliveredByDriverController.dart';
import 'package:e_commerce_foods/controllers/uploadPicController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/ordersModel.dart';
import 'package:e_commerce_foods/views/driver/driverHomePage.dart';

import '../../ui/auth/login_user.dart';

class OrderDelivery extends StatefulWidget {
  final Datum order;
  final String pickUp;
  final String? OrderId;
  final String dropOff;
  const OrderDelivery(this.order, this.pickUp, this.OrderId, this.dropOff);
  @override
  _OrderDeliveryState createState() => _OrderDeliveryState();
}

class _OrderDeliveryState extends State<OrderDelivery> {
  final UploadPicController uploadPicController =
      Get.put(UploadPicController());

  Set<Marker> _markers = {};
  Position? position;
  late bool isBusy;
  var latitude, longitude;

  var picker = ImagePicker();
  File? _profileImage;
  bool _newProfileImage = false;
  String? driverLocation;
  String? ImageId;
  final orderDeliveredByDriverController acceptOrderDeliveredController =
      Get.put(orderDeliveredByDriverController());
  @override
  void initState() {
    super.initState();
    setState(() {
      isBusy = true;
    });
    GetLocation();
  }

  @override
  Widget build(BuildContext context) {
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
              leading: IconButton(
                icon: Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => LoginUser(),
                    ),
                    (_) => false,
                  );
                },
              ),
            ),
            body: ModalProgressHUD(
              child: Container(
                padding: EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: driverLocation != null
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
                                          mapToolbarEnabled: true,
                                          onMapCreated: OnMapCreated,
                                          onTap: (_) {
                                            tap();
                                          },

                                          markers: {
                                            Marker(
                                              position: LatLng(
                                                  double.parse(widget
                                                      .order.userLatitude!),
                                                  double.parse(widget
                                                      .order.userLongitude!)),
                                              markerId: MarkerId("firstMarker"),
                                              //secondMarker
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
                                            )
                                          },
                                          // Marker(
                                          //   position: LatLng(
                                          //       double.parse(widget.order.latitude),
                                          //       double.parse(
                                          //           widget.order.longitude)),
                                          //   markerId: MarkerId(""),
                                          //   icon: BitmapDescriptor
                                          //       .defaultMarkerWithHue(
                                          //       BitmapDescriptor.hueRed),
                                          //   onTap: () {},
                                          //   draggable: false,
                                          //   consumeTapEvents: false,
                                          //   visible: true,
                                          // ),
                                          //},
                                          initialCameraPosition: CameraPosition(
                                            target: LatLng(
                                                double.parse(
                                                    widget.order.userLatitude!),
                                                double.parse(widget
                                                    .order.userLongitude!)),
                                            zoom: 15.0,
                                          ),
                                          myLocationEnabled: true,
                                          myLocationButtonEnabled: true,

                                          //polylines: {
                                          // Polyline(
                                          //     polylineId:
                                          //         PolylineId('overview_polyline'),
                                          //     color: Colors.red,
                                          //     width: 5,
                                          //     points: [
                                          //       LatLng(position.latitude,
                                          //           position.longitude),
                                          //       LatLng(
                                          //           double.parse(
                                          //               widget.order.latitude),
                                          //           double.parse(
                                          //               widget.order.longitude))
                                          //     ])
                                          //},
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
                                                            .userLatitude!),
                                                        double.parse(widget
                                                            .order
                                                            .userLongitude!)),
                                                    title:
                                                        "Dropoff Order Place",
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
                              'Upload Picture once Delivered',
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
                                  uploadPic(_profileImage!);
                                  //_SubmitDelivery();
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
                                text: 'Swipe to Deliver',
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
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position!.latitude, position!.longitude);
    if (placemarks.length > 0) {
      var driverCurrentLocation = placemarks[0];
      setState(() {
        driverLocation = driverCurrentLocation.name! +
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
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        isBusy = false;
      });
    });
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
      } else {
        setState(() {
          _newProfileImage = false;
          _profileImage = null;
        });

        // var response = await OrdersService.productUpload(_profileImage);
        // if (response != null) {
        //   ImageId = response;
        // }
      }
    } catch (err) {}
  }

  uploadPic(File file) async {
    setState(() {
      isBusy = true;
    });
    String medias = "";
    await uploadPicController.fetchPic(
        file, file.path.split("/").last.toString(), 4, "Pickp Selfie");
    if (uploadPicController.picINfo.value.status == 200) {
      print("delivery pic path");
      print(uploadPicController.picINfo.value.data);
      await acceptOrderDeliveredController.fetchorderdeliveredbydriver(
          uploadPicController.picINfo.value.data, widget.order.id);

      print("its to be print");
      if (acceptOrderDeliveredController.orderINfo.value.status == 200) {
        setState(() {
          isBusy = false;
        });
        Get.offAll(DriverHomePage());
        globals.showSuccessToast("Order successfully delivered");
      }
    } else {
      print("200 not printed");
      globals.showErrorToast("Upload Images Error!");
      setState(() {
        isBusy = false;
      });
    }
  }

  Future<void> _SubmitDelivery() async {
    try {
      // setState(() {
      //   isBusy = true;
      // });
      // if (_profileImage == null) {
      //   showErrorToast("Please attach file");
      //   setState(() {
      //     isBusy = false;
      //   });
      //   return false;
      // }
      // setState(() {
      //   isBusy = true;
      // });
      // var Status = {'status': 3, 'imageId': ImageId, 'id': widget.OrderId};
      // var response = await OrdersService.UpdateOrderStatus(Status);
      // if (response) {
      Get.offAll(DriverHomePage());
      globals.showSuccessToast("Order successfully delivered");
    } catch (err) {
      print(err);
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
}

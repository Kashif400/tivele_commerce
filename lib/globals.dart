library tivele.globals;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

String authorization = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJ1c2VybmFtZSI6Im15dHN1bSIsInVzZXJfaWQiOiJVMTYyOTg3NTEyODMifQ.xc_gOKTy462idysbrjOqR6ATu625p1Rag5dCGgXeRXI";
bool checkLogin = false;
showSuccesSnackBar(String message){
  Get.snackbar(
      "Notification",
      message,
      icon: Icon(
        Icons.download_done_rounded,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      snackbarStatus: (status) {
        print(status);
        if (status == SnackbarStatus.CLOSED) {
        }
      }
  );
}
showErrorSnackBar(String message){
  Get.snackbar(
      "Notification",
      message,
      icon: Icon(
        Icons.error_outline,
        color: Colors.white,
      ),
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackbarStatus: (status) {
        print(status);
        if (status == SnackbarStatus.CLOSED) {
        }
      }
  );
}
void showErrorToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      //timeInSecForIos: 1,
      backgroundColor: Colors.red,
      textColor: Colors.white
  );
}

void showSuccessToast(msg) {
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      //timeInSecForIos: 1,
      backgroundColor: Colors.green,
      textColor: Colors.white
  );
}
Widget circularIndicator(){
  return CircularProgressIndicator(
    backgroundColor: Colors.black.withOpacity(0.9),
    valueColor:  new AlwaysStoppedAnimation<Color>(Colors.white),
  );
}
String addressFromLatLng(List<Placemark> placemarks){
  return '${placemarks.first.name!.isNotEmpty ? placemarks.first.name! + ', ' : ''}${placemarks.first.thoroughfare!.isNotEmpty ? placemarks.first.thoroughfare! + ', ' : ''}${placemarks.first.subLocality!.isNotEmpty ? placemarks.first.subLocality!+ ', ' : ''}${placemarks.first.locality!.isNotEmpty ? placemarks.first.locality!+ ', ' : ''}${placemarks.first.subAdministrativeArea!.isNotEmpty ? placemarks.first.subAdministrativeArea! + ', ' : ''}${placemarks.first.postalCode!.isNotEmpty ? placemarks.first.postalCode! + ', ' : ''}${placemarks.first.administrativeArea!.isNotEmpty ? placemarks.first.administrativeArea : ''}';
}
Widget loadImage(String imageUrl, double progressSize, bool isCircular){
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        shape: isCircular?BoxShape.circle:BoxShape.rectangle,
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.fill,
        ),
      ),
    ),
    progressIndicatorBuilder: (context, url, downloadProgress) =>
        Padding(
          padding: EdgeInsets.all(progressSize),
          child: CircularProgressIndicator(value: downloadProgress.progress, color: Colors.white,),
        ),
    errorWidget: (context, url, error) => Image.asset("assets/text.png"),
  );
}
Widget loadImageWithBorderRadius(String imageUrl, double progressSize, double borderRadius){
  return CachedNetworkImage(
    imageUrl: imageUrl,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.fill,
          ),
          borderRadius: BorderRadius.circular(borderRadius)
      ),
    ),
    progressIndicatorBuilder: (context, url, downloadProgress) => Padding(
      padding: EdgeInsets.all(progressSize),
      child: CircularProgressIndicator(value: downloadProgress.progress, color: Colors.white,),
    ),
    errorWidget: (context, url, error) => Image.asset("assets/text.png"),
  );
}
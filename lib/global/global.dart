import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';

class Global {
  static TextStyle style({color, double? size, bool? bold, bool? caps, bool? cut}) {
    return GoogleFonts.poppins(
      color: color != null ? color : Colors.white,
      fontSize: size,
      fontWeight: bold != null && bold ? FontWeight.bold : FontWeight.normal,
      letterSpacing: caps != null && caps ? 4 : 0,
      decoration: cut != null && cut ? TextDecoration.lineThrough : null,
    );
  }

  static const stripePublishableKey =
      "pk_live_3ayggMnNp5g9v2tJdRbPA5sO00UlZ9bk9L";
  static String defaultUserPic =
      "https://growthchart.s3.us-east-2.amazonaws.com/e5bd44b0-3b8e-46d2-9a83-39f67b0c940b-profile.png";

  static String otherPic =
      'https://growthchart.s3.us-east-2.amazonaws.com/315885e3-3645-48dc-a92b-c6404f81d9ec-chromatic.png';

  static String burger =
      'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg';
  static bool isBusinessAccount = true;
  static bool isDriverAccount = true;

  static String calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos as double Function(num?);
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double value = 12742 * asin(sqrt(a));
    return value.toStringAsFixed(2) + " km away";
  }

  static String calculateDistanceJustValue(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos as double Function(num?);
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    double value = 12742 * asin(sqrt(a));
    return value.toStringAsFixed(2);
  }

  static Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, handle appropriately.
        return Future.error(
            'Location permissions are permanently denied, we cannot request permissions.');
      }

      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

//  static Widget svg(asset, color, double size) {
//    return SvgPicture.asset(
//      'assets/$asset.svg',
//      color: color,
//      height: size,
//    );
//  }
}

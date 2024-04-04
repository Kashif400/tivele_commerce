import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_foods/views/splashPage.dart';

import 'Provider/card.dart';
import 'Provider/driver.dart';
import 'Provider/orders.dart';
import 'Provider/product.dart';
import 'Provider/productCategory.dart';
import 'Provider/reviews.dart';
import 'Provider/user.dart';

import 'global/global.dart';

Future<void> main() async {
  Stripe.publishableKey = Global.stripePublishableKey;
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  Stripe.merchantIdentifier = 'MerchantIdentifier';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => BusinessUsersProvider()),
        ChangeNotifierProvider(create: (_) => ProductsCategoryProvider()),
        ChangeNotifierProvider(create: (_) => ReviewsProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => CardsProvider()),
        ChangeNotifierProvider(create: (_) => DriversProvider()),
        // ChangeNotifierProvider(create: (_) => AcceptOrderController())
      ],
      child: GetMaterialApp(
        title: 'Tivele',
        debugShowCheckedModeBanner: false,
        /*navigatorObservers: [
          FirebaseAnalyticsObserver(analytics: analytics),
        ],*/
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: RootPage(),
      ),
    );
  }
}

class RootPage extends StatefulWidget {
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late bool serviceEnabled;
  Location location = new Location();
  bool checkLocation = false;
  PermissionStatus? _permissionGranted;
  @override
  void initState() {
    //context.read<AppSettings>().getAppStartStatus();
    super.initState();
    getLocationAddress();
  }

  getLocationAddress() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      print("asli");
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Get.snackbar("Notification",
            "Please Enable your GPS/Location first for getting nearby orders!",
            icon: Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white, snackbarStatus: (status) {
          print(status);
          if (status == SnackbarStatus.CLOSED) {
            if (Platform.isAndroid) {
              setState(() {
                checkLocation = true;
              });
            } else if (Platform.isIOS) {
              try {
                setState(() {
                  checkLocation = true;
                });
              } catch (e) {
                print(e.toString());
              }
            }
          }
        });
      } else {
        print("locationnnnnnnnnnnnnnn");
        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            Get.snackbar("Notification",
                "Please Enable your GPS/Location first for getting nearby orders!",
                icon: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white, snackbarStatus: (status) {
              print(status);
              if (status == SnackbarStatus.CLOSED) {
                if (Platform.isAndroid) {
                  setState(() {
                    checkLocation = true;
                  });
                } else if (Platform.isIOS) {
                  try {
                    setState(() {
                      checkLocation = true;
                    });
                  } catch (e) {
                    print(e.toString());
                  }
                }
              }
            });
          } else {
            setState(() {
              checkLocation = true;
            });
          }
        } else {
          setState(() {
            checkLocation = true;
          });
        }
      }
    } else {
      print("locationnnnnnnnnnnnnnn");
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          Get.snackbar("Notification",
              "Please Enable your GPS/Location first for getting nearby orders!",
              icon: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white, snackbarStatus: (status) {
            print(status);
            if (status == SnackbarStatus.CLOSED) {
              if (Platform.isAndroid) {
                setState(() {
                  checkLocation = true;
                });
              } else if (Platform.isIOS) {
                try {
                  setState(() {
                    checkLocation = true;
                  });
                } catch (e) {
                  print(e.toString());
                }
              }
            }
          });
        } else {
          setState(() {
            checkLocation = true;
          });
        }
      } else {
        setState(() {
          checkLocation = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return
        // checkLocation
        //   ?
        SplashPage()
        // : Container(
        //     color: Colors.black,
        //   )
        ;
  }
}

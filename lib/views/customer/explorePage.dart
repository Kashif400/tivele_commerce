import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/controllers/business/getCategoriesController.dart';
import 'package:e_commerce_foods/controllers/customer/getExploreDataController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/business/getCategoriesModel.dart';
import 'package:e_commerce_foods/models/customer/getExploreDataModel.dart';
import 'package:e_commerce_foods/models/productModel.dart';
import 'package:e_commerce_foods/views/customer/businessProfileFollowPage.dart';
import 'package:e_commerce_foods/views/customer/customerDetailPage.dart';
import 'package:e_commerce_foods/views/customer/customerLoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:mime/mime.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class ExplorePage extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<ExplorePage> {
  TextEditingController filter = TextEditingController();

  bool checkLocation = true;
  final GetCategoriesController getCategoriesController =
      Get.put(GetCategoriesController());
  final GetExploreDataController getExploreDataController =
      Get.put(GetExploreDataController());
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isBusy = true;
  bool isListNull = true;
  int pageIndex = 1;
  List<Datum>? categories = [];
  List<ProductDatum> productsData = [];
  String? currentCategoryId = null;
  int currentCategoryIndex = 0;
  List itemPhotoUrls = [];
  List checkMedia = [];
  String burger =
      'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg';
  bool _isLoading = true;
  bool _hasMore = true;
  String address = "NuN";
  bool checkCurrentLocation = false;
  final ItemScrollController itemScrollController = ItemScrollController();
  Location location = new Location();
  late bool serviceEnabled;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  @override
  initState() {
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
            "Please Enable your GPS/Location first to get nearby goods/order",
            icon: Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white, snackbarStatus: (status) {
          print(status);
          if (status == SnackbarStatus.CLOSED) {
            //Get.offAll(CustomerHomePage());
            setState(() {
              checkLocation = false;
              checkCurrentLocation = false;
            });
            getInitialDataWithoutLocation(currentCategoryId);
          }
        });
      } else {
        print("locationnnnnnnnnnnnnnn");
        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            Get.snackbar("Notification",
                "Please Enable your GPS/Location first to get nearby goods/order",
                icon: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white, snackbarStatus: (status) {
              print(status);
              if (status == SnackbarStatus.CLOSED) {
                //Get.offAll(CustomerHomePage());
                setState(() {
                  checkLocation = false;
                  checkCurrentLocation = false;
                });
                getInitialDataWithoutLocation(currentCategoryId);
              }
            });
          } else {
            var position = await location.getLocation();
            //final coordinates = new Coordinates(position.latitude, position.longitude);
            //var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
            //var first = addresses.first;
            //print("${first.featureName} : ${first.addressLine}");
            List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
                position.latitude!, position.longitude!);
            setState(() {
              address = "${placemarks[0].locality}, ${placemarks[0].country}";
            });
            setState(() {
              checkCurrentLocation = true;
              checkLocation = true;
            });
            getInitialData(currentCategoryId);
          }
        } else {
          var position = await location.getLocation();
          // final coordinates =
          //     new Coordinates(position.latitude, position.longitude);
          // var addresses =
          //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
          // var first = addresses.first;
          // print("${first.featureName} : ${first.addressLine}");
          List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
              position.latitude!, position.longitude!);
          setState(() {
            address = "${placemarks[0].locality}, ${placemarks[0].country}";
          });
          setState(() {
            checkCurrentLocation = true;
            checkLocation = true;
          });
          getInitialData(currentCategoryId);
        }
      }
    } else {
      print("locationnnnnnnnnnnnnnn");
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          Get.snackbar("Notification",
              "Please Enable your GPS/Location first to get nearby goods/order",
              icon: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white, snackbarStatus: (status) {
            print(status);
            if (status == SnackbarStatus.CLOSED) {
              //Get.offAll(CustomerHomePage());
              setState(() {
                checkLocation = false;
                checkCurrentLocation = false;
              });
              getInitialDataWithoutLocation(currentCategoryId);
            }
          });
        } else {
          var position = await location.getLocation();
          // final coordinates =
          //     new Coordinates(position.latitude, position.longitude);
          // var addresses =
          //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
          // var first = addresses.first;
          // print("${first.featureName} : ${first.addressLine}");
          List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
              position.latitude!, position.longitude!);
          setState(() {
            address = "${placemarks[0].locality}, ${placemarks[0].country}";
          });
          setState(() {
            checkCurrentLocation = true;
            checkLocation = true;
          });
          getInitialData(currentCategoryId);
        }
      } else {
        var position = await location.getLocation();

        // final coordinates =
        //     new Coordinates(position.latitude, position.longitude);
        // var addresses =
        //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
        // var first = addresses.first;
        // print("${first.featureName} : ${first.addressLine}");
        List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
            position.latitude!, position.longitude!);
        setState(() {
          address = "${placemarks[0].locality}, ${placemarks[0].country}";
        });
        getInitialData(currentCategoryId);
        setState(() {
          checkCurrentLocation = true;
          checkLocation = true;
        });
      }
    }
  }

  bool showResult = true;

  List<dynamic> itemsAll = [];

  void filterSearchResultsAll(String query) {
    List<dynamic> dummySearchList = [];
    dummySearchList.addAll(productsData.map((e) => e.name.toString()));
    if (query.isNotEmpty) {
      List<dynamic> dummyListData = [];
      dummySearchList.forEach((item) {
        if (item.contains(query)) {
          dummyListData.add(item);
        }
      });
      setState(() {
        itemsAll.clear();
        itemsAll.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        itemsAll.clear();
        itemsAll.addAll(productsData);
      });
    }
  }

  Icon customIcon = const Icon(Icons.search);
  Widget customSearchBar = Column(
    children: [
      Text(
        "TIVELE EXPLORE",
        style: Global.style(
          size: 22,
          bold: true,
          caps: true,
        ),
      ),
      Text.rich(
        TextSpan(
          text: 'Your Location: ',
          style: Global.style(color: Colors.white70, size: 12),
          children: [
            TextSpan(
              text: "pes",
              style: Global.style(bold: true, color: Colors.white, size: 12),
            ),
          ],
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              backgroundColor: Colors.black,
              title: customSearchBar,
              // Column(
              //   children: [
              //     Text(
              //       "TIVELE EXPLORE",
              //       style: Global.style(
              //         size: 22,
              //         bold: true,
              //         caps: true,
              //       ),
              //     ),
              //     Text.rich(
              //       TextSpan(
              //         text: 'Your Location: ',
              //         style: Global.style(color: Colors.white70, size: 12),
              //         children: [
              //           TextSpan(
              //             text: address,
              //             style: Global.style(
              //                 bold: true, color: Colors.white, size: 12),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
              centerTitle: true,
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  ////////////////////// search icon
                  // icon: Icon(
                  //   Icons.search,
                  //   color: Colors.white,
                  //   size: 29,
                  // ),
                  icon: customIcon,

                  onPressed: () {
                    print("not working");
                    if (customIcon.icon == Icons.search) {
                      customIcon = const Icon(Icons.cancel);
                      customSearchBar = ListTile(
                        leading: Icon(
                          Icons.search,
                          color: Colors.white,
                          size: 28,
                        ),
                        title: TextFormField(
                          onChanged: ((value) {
                            filterSearchResultsAll(value);
                            setState(() {
                              if (value.length > 0) {
                                showResult = false;
                              } else {
                                showResult = true;
                              }
                            });
                          }),
                          // controller: filter,
                          decoration: InputDecoration(
                            hintText: 'Searching....',
                            hintStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontStyle: FontStyle.italic,
                            ),
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                  },
                )
              ],
            ),
            body: Row(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: [
                        Obx(() {
                          if (getCategoriesController.isLoading.value) {
                            return Center(child: globals.circularIndicator());
                          } else if (getCategoriesController.isListNull.value) {
                            return Center(
                              child: Text(
                                'No Categories Found!',
                                style: Global.style(
                                  bold: false,
                                  size: 20,
                                ),
                              ),
                            );
                          } else {
                            if (currentCategoryId == null) {
                              categories = getCategoriesController
                                  .categoryINfo.value.data;
                              currentCategoryId = categories![0].id;
                              if (checkCurrentLocation) {
                                getInitialData(currentCategoryId);
                              } else {
                                getInitialDataWithoutLocation(
                                    currentCategoryId);
                              }
                            }
                            return Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              alignment: Alignment.centerLeft,
                              height: 50,
                              child: ListView.builder(
                                  itemCount: categories!.length,
                                  padding: EdgeInsets.all(0),
                                  scrollDirection: Axis.horizontal,
                                  itemBuilder: (context, index) {
                                    return InkWell(
                                      onTap: () {
                                        setState(() {
                                          currentCategoryId =
                                              categories![index].id;
                                          currentCategoryIndex = index;
                                          pageIndex = 1;
                                        });
                                        if (checkCurrentLocation) {
                                          getInitialData(currentCategoryId);
                                        } else {
                                          getInitialDataWithoutLocation(
                                              currentCategoryId);
                                        }
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: 100,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              //                   <--- left side
                                              color:
                                                  index == currentCategoryIndex
                                                      ? Colors.white
                                                      : Colors.transparent,
                                              width: 3.0,
                                            ),
                                          ),
                                        ),
                                        child: Text(
                                          categories![index].name!,
                                          style: Global.style(
                                            size: 14,
                                            bold: true,
                                            caps: false,
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                          }
                        }),
                        SizedBox(
                          height: 10,
                        ),
                        !checkLocation
                            ? InkWell(
                                onTap: () {
                                  getLocationAddress();
                                },
                                child: Text(
                                  'Enable GPS/Location Permission to get nearby results! ',
                                  textAlign: TextAlign.center,
                                  style: Global.style(
                                    bold: true,
                                    size: 14,
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          height: 10,
                        ),
                        isBusy
                            ? Expanded(
                                child:
                                    Center(child: globals.circularIndicator()))
                            : isListNull
                                ? Expanded(
                                    child: Center(
                                      child: Text(
                                        "No Data Found!",
                                        style: Global.style(
                                          size: 20,
                                          bold: true,
                                          caps: false,
                                        ),
                                      ),
                                    ),
                                  )
                                : Expanded(
                                    child: SmartRefresher(
                                      enablePullDown: true,
                                      enablePullUp: true,
                                      header: WaterDropHeader(),
                                      footer: CustomFooter(
                                        builder: (BuildContext context,
                                            LoadStatus? mode) {
                                          Widget body;
                                          // if(mode==LoadStatus.idle){
                                          //   body =  Text(
                                          //     "Pull up to load more item...",
                                          //     style: Global.style(
                                          //       size: 14,
                                          //       bold: true,
                                          //     ),
                                          //   );
                                          // }
                                          if (mode == LoadStatus.loading) {
                                            body = globals.circularIndicator();
                                          } else if (mode ==
                                              LoadStatus.failed) {
                                            body = Text(
                                              "Load Failed!Click retry!",
                                              style: Global.style(
                                                size: 14,
                                                bold: true,
                                              ),
                                            );
                                          } else if (mode ==
                                              LoadStatus.canLoading) {
                                            body = Text(
                                              "Release to load more",
                                              style: Global.style(
                                                size: 14,
                                                bold: true,
                                              ),
                                            );
                                          } else {
                                            body = Text(
                                              "No more item founds!",
                                              style: Global.style(
                                                size: 14,
                                                bold: true,
                                              ),
                                            );
                                          }
                                          return Container(
                                            // height: 55.0,
                                            child: Center(child: body),
                                          );
                                        },
                                      ),
                                      controller: _refreshController,
                                      onRefresh: _onRefresh,
                                      onLoading: _onLoading,
                                      child: showResult
                                          ? ListView.builder(
                                              itemCount: productsData.length,
                                              padding: EdgeInsets.all(0),
                                              itemBuilder: (context, index) {
                                                itemPhotoUrls.clear();
                                                checkMedia.clear();
                                                if (productsData[index]
                                                    .productImages!
                                                    .contains(",")) {
                                                  itemPhotoUrls =
                                                      productsData[index]
                                                          .productImages!
                                                          .split(",");
                                                  for (int i = 0;
                                                      i < itemPhotoUrls.length;
                                                      i++) {
                                                    String mimeStr =
                                                        lookupMimeType(
                                                            itemPhotoUrls[i])!;
                                                    var fileType =
                                                        mimeStr.split('/');
                                                    checkMedia.add(fileType[0]);
                                                  }
                                                } else {
                                                  itemPhotoUrls.add(
                                                      productsData[index]
                                                          .productImages);
                                                  String mimeStr =
                                                      lookupMimeType(
                                                          itemPhotoUrls[0])!;
                                                  var fileType =
                                                      mimeStr.split('/');
                                                  checkMedia.add(fileType[0]);
                                                }
                                                return InkWell(
                                                  onTap: () async {
                                                    List<ProductM> productD =
                                                        [];
                                                    productD.add(ProductM(
                                                        productsData[index].id,
                                                        productsData[index]
                                                            .businessId,
                                                        productsData[index]
                                                            .categoryName,
                                                        productsData[index]
                                                            .name,
                                                        productsData[index]
                                                            .description,
                                                        productsData[index]
                                                            .productImages,
                                                        productsData[index]
                                                            .status,
                                                        double.parse(
                                                            productsData[index]
                                                                .newPrice!),
                                                        double.parse(
                                                            productsData[index]
                                                                .oldPrice!),
                                                        double.parse(
                                                            productsData[index]
                                                                .tiveleFee!),
                                                        double.parse(
                                                            productsData[index]
                                                                .gstAmount!),
                                                        double.parse(
                                                            productsData[index]
                                                                .shippingCost!),
                                                        productsData[index]
                                                            .latitude,
                                                        productsData[index]
                                                            .longitude));
                                                    if (globals.checkLogin) {
                                                      showLoginErrorDialog();
                                                    } else {
                                                      await checkLocationPermissionForRefresh();
                                                      if (checkLocation) {
                                                        Get.to(
                                                            CustomerDetailPage(),
                                                            arguments: [
                                                              productD,
                                                              productsData[
                                                                      index]
                                                                  .likes,
                                                              productsData[
                                                                      index]
                                                                  .rating,
                                                              productsData[
                                                                      index]
                                                                  .isLiked,
                                                              productsData[
                                                                  index]
                                                            ]);
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 120,
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          //                   <--- left side
                                                          color: Colors.white,
                                                          width: 3.0,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.60,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  print(
                                                                      "indexxxxxxxxxxxxxxxxxxxxxxxx");
                                                                  print(index);
                                                                  print(productsData[
                                                                          index]
                                                                      .businessId);
                                                                  if (globals
                                                                      .checkLogin) {
                                                                    showLoginErrorDialog();
                                                                  } else {
                                                                    Get.to(
                                                                        BusinessProfileFollowPage(),
                                                                        arguments: [
                                                                          productsData[index]
                                                                              .businessId
                                                                        ]);
                                                                  }
                                                                },
                                                                child: Text(
                                                                  productsData[
                                                                          index]
                                                                      .businessName!,
                                                                  style: Global
                                                                      .style(
                                                                    size: 14,
                                                                    bold: true,
                                                                    caps: false,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                productsData[
                                                                        index]
                                                                    .name!,
                                                                style: Global
                                                                    .style(
                                                                  size: 12,
                                                                  bold: true,
                                                                  caps: false,
                                                                ),
                                                              ),
                                                              Text(
                                                                //productsData[index].description*6,
                                                                //(productsData[index].description).length.toString(),
                                                                productsData[index]
                                                                            .description!
                                                                            .length >
                                                                        120
                                                                    ? productsData[
                                                                            index]
                                                                        .description!
                                                                        .substring(
                                                                            0,
                                                                            120)
                                                                    : productsData[
                                                                            index]
                                                                        .description!,
                                                                style: Global
                                                                    .style(
                                                                  size: 9,
                                                                  bold: false,
                                                                  caps: false,
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Text.rich(
                                                                TextSpan(
                                                                  text: "\$ " +
                                                                      productsData[
                                                                              index]
                                                                          .newPrice!,
                                                                  style: Global
                                                                      .style(
                                                                    size: 12,
                                                                    bold: true,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: " \$ " +
                                                                          productsData[index]
                                                                              .oldPrice!,
                                                                      style: Global
                                                                          .style(
                                                                        size:
                                                                            10,
                                                                        bold:
                                                                            true,
                                                                        cut:
                                                                            true,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Text.rich(
                                                                TextSpan(
                                                                  text:
                                                                      'Distance: ',
                                                                  style: Global.style(
                                                                      color: Colors
                                                                          .white70,
                                                                      size: 10),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: (double.parse(productsData[index].distance!) / 1000)
                                                                              .toStringAsFixed(2) +
                                                                          " km away",
                                                                      style: Global.style(
                                                                          bold:
                                                                              true,
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              10),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.30,
                                                          height: 100,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.white,
                                                            image:
                                                                DecorationImage(
                                                              image: (checkMedia[
                                                                          0] !=
                                                                      "image"
                                                                  ? AssetImage(
                                                                      "assets/text.png",
                                                                    )
                                                                  : NetworkImage(URLS
                                                                          .BASEURL +
                                                                      itemPhotoUrls[
                                                                          0])) as ImageProvider<
                                                                  Object>,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                          child: Text.rich(
                                                            TextSpan(
                                                              text: "\$ " +
                                                                  productsData[
                                                                          index]
                                                                      .newPrice!,
                                                              style:
                                                                  Global.style(
                                                                size: 12,
                                                                bold: true,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: " \$ " +
                                                                      productsData[
                                                                              index]
                                                                          .oldPrice!,
                                                                  style: Global
                                                                      .style(
                                                                    size: 10,
                                                                    bold: true,
                                                                    cut: true,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              })
                                          : ListView.builder(
                                              itemCount: itemsAll.length,
                                              padding: EdgeInsets.all(0),
                                              itemBuilder: (context, index) {
                                                itemPhotoUrls.clear();
                                                checkMedia.clear();
                                                if (productsData[index]
                                                    .productImages!
                                                    .contains(",")) {
                                                  itemPhotoUrls =
                                                      productsData[index]
                                                          .productImages!
                                                          .split(",");
                                                  for (int i = 0;
                                                      i < itemPhotoUrls.length;
                                                      i++) {
                                                    String mimeStr =
                                                        lookupMimeType(
                                                            itemPhotoUrls[i])!;
                                                    var fileType =
                                                        mimeStr.split('/');
                                                    checkMedia.add(fileType[0]);
                                                  }
                                                } else {
                                                  itemPhotoUrls.add(
                                                      productsData[index]
                                                          .productImages);
                                                  String mimeStr =
                                                      lookupMimeType(
                                                          itemPhotoUrls[0])!;
                                                  var fileType =
                                                      mimeStr.split('/');
                                                  checkMedia.add(fileType[0]);
                                                }
                                                return InkWell(
                                                  onTap: () async {
                                                    List<ProductM> productD =
                                                        [];
                                                    productD.add(ProductM(
                                                        productsData[index].id,
                                                        productsData[index]
                                                            .businessId,
                                                        productsData[index]
                                                            .categoryName,
                                                        productsData[index]
                                                            .name,
                                                        productsData[index]
                                                            .description,
                                                        productsData[index]
                                                            .productImages,
                                                        productsData[index]
                                                            .status,
                                                        double.parse(
                                                            productsData[index]
                                                                .newPrice!),
                                                        double.parse(
                                                            productsData[index]
                                                                .oldPrice!),
                                                        double.parse(
                                                            productsData[index]
                                                                .tiveleFee!),
                                                        double.parse(
                                                            productsData[index]
                                                                .gstAmount!),
                                                        double.parse(
                                                            productsData[index]
                                                                .shippingCost!),
                                                        productsData[index]
                                                            .latitude,
                                                        productsData[index]
                                                            .longitude));
                                                    if (globals.checkLogin) {
                                                      showLoginErrorDialog();
                                                    } else {
                                                      await checkLocationPermissionForRefresh();
                                                      if (checkLocation) {
                                                        Get.to(
                                                            CustomerDetailPage(),
                                                            arguments: [
                                                              productD,
                                                              productsData[
                                                                      index]
                                                                  .likes,
                                                              productsData[
                                                                      index]
                                                                  .rating,
                                                              productsData[
                                                                      index]
                                                                  .isLiked,
                                                              productsData[
                                                                  index]
                                                            ]);
                                                      }
                                                    }
                                                  },
                                                  child: Container(
                                                    height: 120,
                                                    margin: EdgeInsets.only(
                                                        top: 10),
                                                    decoration: BoxDecoration(
                                                      border: Border(
                                                        bottom: BorderSide(
                                                          //                   <--- left side
                                                          color: Colors.white,
                                                          width: 3.0,
                                                        ),
                                                      ),
                                                    ),
                                                    child: Row(
                                                      children: [
                                                        Container(
                                                          alignment: Alignment
                                                              .centerLeft,
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.60,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              InkWell(
                                                                onTap: () {
                                                                  print(
                                                                      "indexxxxxxxxxxxxxxxxxxxxxxxx");
                                                                  print(index);
                                                                  print(productsData[
                                                                          index]
                                                                      .businessId);
                                                                  if (globals
                                                                      .checkLogin) {
                                                                    showLoginErrorDialog();
                                                                  } else {
                                                                    Get.to(
                                                                        BusinessProfileFollowPage(),
                                                                        arguments: [
                                                                          productsData[index]
                                                                              .businessId
                                                                        ]);
                                                                  }
                                                                },
                                                                child: Text(
                                                                  productsData[
                                                                          index]
                                                                      .businessName!,
                                                                  style: Global
                                                                      .style(
                                                                    size: 14,
                                                                    bold: true,
                                                                    caps: false,
                                                                  ),
                                                                ),
                                                              ),
                                                              Text(
                                                                itemsAll[index]
                                                                    .toString(),
                                                                style: Global
                                                                    .style(
                                                                  size: 12,
                                                                  bold: true,
                                                                  caps: false,
                                                                ),
                                                              ),
                                                              Text(
                                                                //productsData[index].description*6,
                                                                //(productsData[index].description).length.toString(),
                                                                productsData[index]
                                                                            .description!
                                                                            .length >
                                                                        120
                                                                    ? productsData[
                                                                            index]
                                                                        .description!
                                                                        .substring(
                                                                            0,
                                                                            120)
                                                                    : productsData[
                                                                            index]
                                                                        .description!,
                                                                style: Global
                                                                    .style(
                                                                  size: 9,
                                                                  bold: false,
                                                                  caps: false,
                                                                ),
                                                              ),
                                                              Spacer(),
                                                              Text.rich(
                                                                TextSpan(
                                                                  text: "\$ " +
                                                                      productsData[
                                                                              index]
                                                                          .newPrice!,
                                                                  style: Global
                                                                      .style(
                                                                    size: 12,
                                                                    bold: true,
                                                                  ),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: " \$ " +
                                                                          productsData[index]
                                                                              .oldPrice!,
                                                                      style: Global
                                                                          .style(
                                                                        size:
                                                                            10,
                                                                        bold:
                                                                            true,
                                                                        cut:
                                                                            true,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              Text.rich(
                                                                TextSpan(
                                                                  text:
                                                                      'Distance: ',
                                                                  style: Global.style(
                                                                      color: Colors
                                                                          .white70,
                                                                      size: 10),
                                                                  children: [
                                                                    TextSpan(
                                                                      text: (double.parse(productsData[index].distance!) / 1000)
                                                                              .toStringAsFixed(2) +
                                                                          " km away",
                                                                      style: Global.style(
                                                                          bold:
                                                                              true,
                                                                          color: Colors
                                                                              .white,
                                                                          size:
                                                                              10),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 5,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Container(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width *
                                                              0.30,
                                                          height: 100,
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20),
                                                            color: Colors.white,
                                                            image:
                                                                DecorationImage(
                                                              image: (checkMedia[
                                                                          0] !=
                                                                      "image"
                                                                  ? AssetImage(
                                                                      "assets/text.png",
                                                                    )
                                                                  : NetworkImage(URLS
                                                                          .BASEURL +
                                                                      itemPhotoUrls[
                                                                          0])) as ImageProvider<
                                                                  Object>,
                                                              fit: BoxFit.fill,
                                                            ),
                                                          ),
                                                          child: Text.rich(
                                                            TextSpan(
                                                              text: "\$ " +
                                                                  productsData[
                                                                          index]
                                                                      .newPrice!,
                                                              style:
                                                                  Global.style(
                                                                size: 12,
                                                                bold: true,
                                                              ),
                                                              children: [
                                                                TextSpan(
                                                                  text: " \$ " +
                                                                      productsData[
                                                                              index]
                                                                          .oldPrice!,
                                                                  style: Global
                                                                      .style(
                                                                    size: 10,
                                                                    bold: true,
                                                                    cut: true,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              }),
                                    ),
                                  ),
                      ],
                    )),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.05,
                ),
              ],
            )));
  }

  void getInitialData(String? currentCategoryId) async {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      setState(() {
        isBusy = true;
        isListNull = true;
        productsData.clear();
      });
      var position = await Global.determinePosition();
      await getExploreDataController.fetchCustomerHomeData(
          "0",
          position.longitude.toString(),
          position.latitude.toString(),
          currentCategoryId!);
      if (getExploreDataController.exploreINfo.value.status == 200) {
        setState(() {
          productsData.addAll(getExploreDataController.exploreINfo.value.data!);
          isBusy = false;
          isListNull = false;
        });
      } else {
        setState(() {
          isBusy = false;
          isListNull = true;
        });
      }
    });
  }

  void getInitialDataWithoutLocation(String? currentCategoryId) async {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      setState(() {
        isBusy = true;
        isListNull = true;
        productsData.clear();
      });
      await getExploreDataController.fetchCustomerHomeData(
          "0", "0", "0", currentCategoryId!);
      if (getExploreDataController.exploreINfo.value.status == 200) {
        setState(() {
          productsData.addAll(getExploreDataController.exploreINfo.value.data!);
          isBusy = false;
          isListNull = false;
        });
      } else {
        setState(() {
          isBusy = false;
          isListNull = true;
        });
      }
    });
  }

  void loadData() async {
    print("getting data");
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      setState(() {
        _hasMore = true;
        _isLoading = false;
      });
      var position = await Global.determinePosition();
      await getExploreDataController.fetchCustomerHomeData(
          pageIndex.toString(),
          position.longitude.toString(),
          position.latitude.toString(),
          currentCategoryId!);
      if (getExploreDataController.exploreINfo.value.status == 200) {
        setState(() {
          productsData.addAll(getExploreDataController.exploreINfo.value.data!);
          _isLoading = true;
          pageIndex++;
        });
      } else {
        setState(() {
          _isLoading = true;
          _hasMore = false;
        });
      }
    });
    //_isLoading = true;
    // _itemFetcher.fetch().then((List<WordPair> fetchedList) {
    //   if (fetchedList.isEmpty) {
    //     setState(() {
    //       _isLoading = false;
    //       _hasMore = false;
    //     });
    //   } else {
    //     setState(() {
    //       _isLoading = false;
    //       productDataList.addAll(customerHomeController.homeINfo.value.data);
    //       _hasMore = true;
    //     });
    //   }
    // });
  }

  void _onRefresh() async {
    // monitor network fetch
    //await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    await checkLocationPermissionForRefresh();
    if (checkLocation) {
      setState(() {
        isBusy = true;
        isListNull = true;
        productsData.clear();
      });
      var position = await Global.determinePosition();
      await getExploreDataController.fetchCustomerHomeData(
          "0",
          position.longitude.toString(),
          position.latitude.toString(),
          currentCategoryId!);
      if (getExploreDataController.exploreINfo.value.status == 200) {
        setState(() {
          productsData.addAll(getExploreDataController.exploreINfo.value.data!);
          _isLoading = true;
          isBusy = false;
          isListNull = false;
          pageIndex++;
        });
      } else {
        setState(() {
          isBusy = false;
          isListNull = true;
        });
      }
    } else {
      setState(() {
        isBusy = true;
        isListNull = true;
        productsData.clear();
      });
      await getExploreDataController.fetchCustomerHomeData(
          "0", "0", "0", currentCategoryId!);
      if (getExploreDataController.exploreINfo.value.status == 200) {
        setState(() {
          productsData.addAll(getExploreDataController.exploreINfo.value.data!);
          _isLoading = true;
          isBusy = false;
          isListNull = false;
          pageIndex++;
        });
      } else {
        setState(() {
          isBusy = false;
          isListNull = true;
        });
      }
    }
    _refreshController.refreshCompleted();
  }

  Future _onLoading() async {
    //await Future.delayed(Duration(milliseconds: 1000));
    await checkLocationPermissionForRefresh();
    if (checkLocation) {
      var position = await Global.determinePosition();
      await getExploreDataController.fetchCustomerHomeData(
          pageIndex.toString(),
          position.longitude.toString(),
          position.latitude.toString(),
          currentCategoryId!);
      if (getExploreDataController.exploreINfo.value.status == 200) {
        productsData.addAll(getExploreDataController.exploreINfo.value.data!);
        _isLoading = true;
        pageIndex++;
      }
    } else {
      await getExploreDataController.fetchCustomerHomeData(
          pageIndex.toString(), "0", "0", currentCategoryId!);
      if (getExploreDataController.exploreINfo.value.status == 200) {
        productsData.addAll(getExploreDataController.exploreINfo.value.data!);
        _isLoading = true;
        pageIndex++;
      }
    }
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  checkLocationPermissionForRefresh() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Get.snackbar("Notification",
            "Please Enable your GPS/Location first to get nearby goods/order",
            icon: Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white, snackbarStatus: (status) {
          print(status);
          if (status == SnackbarStatus.CLOSED) {
            //Get.offAll(CustomerHomePage());
          }
        });
        setState(() {
          checkLocation = false;
        });
      } else {
        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            Get.snackbar("Notification",
                "Please Enable your GPS/Location first to get nearby goods/order",
                icon: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white, snackbarStatus: (status) {
              print(status);
              if (status == SnackbarStatus.CLOSED) {}
            });
            setState(() {
              checkLocation = false;
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
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          Get.snackbar("Notification",
              "Please Enable your GPS/Location first to get nearby goods/order",
              icon: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white, snackbarStatus: (status) {
            print(status);
            if (status == SnackbarStatus.CLOSED) {
              //Get.offAll(CustomerHomePage());
            }
            setState(() {
              checkLocation = false;
            });
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

  void showLoginErrorDialog() async {
    showAnimatedDialog(
      animationType: DialogTransitionType.sizeFade,
      curve: Curves.easeInCirc,
      duration: Duration(seconds: 1),
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (_, __) {
              return Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.white, width: 4),
                ),
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
                        'LOGIN',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          Text(
                            "Kindly login to book order/ see business!",
                            textAlign: TextAlign.center,
                            style: Global.style(
                              size: 16,
                              bold: true,
                              caps: true,
                              color: Colors.orange,
                            ),
                          ),
                          SizedBox(height: 10),
                          InkWell(
                            onTap: () async {
                              Navigator.pop(context);
                              Get.offAll(CustomerLoginPage());
                            },
                            child: Center(
                              child: Text(
                                'Click to login',
                                textAlign: TextAlign.center,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 18,
                                  letterSpacing: 4,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30),
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
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Ok',
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
              );
            },
          ),
        );
      },
      context: Get.context!,
    );
  }
}

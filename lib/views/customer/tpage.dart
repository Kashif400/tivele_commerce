import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:mime/mime.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/controllers/customer/customerLikeController.dart';
import 'package:e_commerce_foods/controllers/customer/getTiveleDataController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/customer/getExploreDataModel.dart';
import 'package:e_commerce_foods/models/productModel.dart';
import 'package:e_commerce_foods/views/customer/businessProfileFollowPage.dart';
import 'package:e_commerce_foods/views/customer/customerDetailPage.dart';
import 'package:e_commerce_foods/views/customer/customerLoginPage.dart';

class TPage extends StatefulWidget {
  @override
  _TPageState createState() => _TPageState();
}

class _TPageState extends State<TPage> {
  TextEditingController controller = TextEditingController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  List<ProductDatum> productDataList = [];
  bool isBusy = true;
  bool isListNull = true;
  final GetTiveleDataController getTiveleDataController =
      Get.put(GetTiveleDataController());
  final CustomerAddLikeController customerAddLikeController =
      Get.put(CustomerAddLikeController());
  String burger =
      'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg';
  late bool serviceEnabled;
  PermissionStatus? _permissionGranted;
  Location location = new Location();
  int page = 1;
  @override
  void initState() {
    super.initState();

    checkLocationPermission();
  }

  bool checkLocation = true;
  List itemPhotoUrls = [];
  List checkMedia = [];
  checkLocationPermission() async {
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
        getInitialDataWithoutLocation();
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
            getInitialDataWithoutLocation();
          } else {
            setState(() {
              checkLocation = true;
            });
            getInitialData();
          }
        } else {
          setState(() {
            checkLocation = true;
          });
          getInitialData();
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
            }
            setState(() {
              checkLocation = false;
            });
            getInitialDataWithoutLocation();
          });
        } else {
          setState(() {
            checkLocation = true;
          });
          getInitialData();
        }
      } else {
        getInitialData();
        setState(() {
          checkLocation = true;
        });
      }
    }
  }

  void getInitialDataWithoutLocation() async {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      setState(() {
        isBusy = true;
        isListNull = true;
        productDataList.clear();
      });
      await getTiveleDataController.fetchTiveleData(
        "0",
        "0",
        "0",
      );
      if (getTiveleDataController.tiveleDataINfo.value.status == 200) {
        setState(() {
          productDataList
              .addAll(getTiveleDataController.tiveleDataINfo.value.data!);
          isBusy = false;
          isListNull = false;
          page = 1;
        });
      } else {
        setState(() {
          isBusy = false;
          isListNull = true;
        });
      }
    });
  }

  void getInitialData() async {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      setState(() {
        isBusy = true;
        isListNull = true;
        productDataList.clear();
      });
      var position = await Global.determinePosition();
      await getTiveleDataController.fetchTiveleData(
        "0",
        position.longitude.toString(),
        position.latitude.toString(),
      );
      if (getTiveleDataController.tiveleDataINfo.value.status == 200) {
        setState(() {
          productDataList
              .addAll(getTiveleDataController.tiveleDataINfo.value.data!);
          isBusy = false;
          isListNull = false;
          page = 1;
        });
      } else {
        setState(() {
          isBusy = false;
          isListNull = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text(
            'TIVELE ',
            style: Global.style(
              size: 22,
              bold: true,
              caps: true,
            ),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            !checkLocation
                ? InkWell(
                    onTap: () {
                      checkLocationPermission();
                    },
                    child: Text(
                      'Enable GPS/Location Permission to get nearby results!   ',
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
                ? Expanded(child: Center(child: globals.circularIndicator()))
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
                            builder: (BuildContext context, LoadStatus? mode) {
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
                              } else if (mode == LoadStatus.failed) {
                                body = Text(
                                  "Load Failed!Click retry!",
                                  style: Global.style(
                                    size: 14,
                                    bold: true,
                                  ),
                                );
                              } else if (mode == LoadStatus.canLoading) {
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
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: productDataList.length,
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 0,
                              );
                            },
                            itemBuilder: (context, index) {
                              itemPhotoUrls.clear();
                              checkMedia.clear();
                              if (productDataList[index]
                                  .productImages!
                                  .contains(",")) {
                                itemPhotoUrls = productDataList[index]
                                    .productImages!
                                    .split(",");
                                for (int i = 0; i < itemPhotoUrls.length; i++) {
                                  String mimeStr =
                                      lookupMimeType(itemPhotoUrls[i])!;
                                  if (mimeStr.isNotEmpty) {
                                    var fileType = mimeStr.split('/');
                                    checkMedia.add(fileType[0]);
                                  }
                                }
                              } else {
                                itemPhotoUrls
                                    .add(productDataList[index].productImages);
                                String mimeStr =
                                    lookupMimeType(itemPhotoUrls[0])!;
                                var fileType = mimeStr.split('/');
                                checkMedia.add(fileType[0]);
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 8),
                                    child: InkWell(
                                      onTap: () {
                                        if (globals.checkLogin) {
                                          showLoginErrorDialog();
                                        } else {
                                          Get.to(BusinessProfileFollowPage(),
                                              arguments: [
                                                productDataList[index]
                                                    .businessId
                                              ]);
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            productDataList[index]
                                                .businessName!,
                                            style: Global.style(
                                              size: 18,
                                              bold: true,
                                            ),
                                          ),
                                          Icon(
                                            productDataList[index]
                                                        .isReputable ==
                                                    "1"
                                                ? Icons.verified
                                                : null,
                                            color: Colors.blue,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Stack(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          List<ProductM> productD = [];
                                          productD.add(ProductM(
                                              productDataList[index].id,
                                              productDataList[index].businessId,
                                              productDataList[index]
                                                  .categoryName,
                                              productDataList[index].name,
                                              productDataList[index]
                                                  .description,
                                              productDataList[index]
                                                  .productImages,
                                              productDataList[index].status,
                                              double.parse(
                                                  productDataList[index]
                                                      .newPrice!),
                                              double.parse(
                                                  productDataList[index]
                                                      .oldPrice!),
                                              double.parse(
                                                  productDataList[index]
                                                      .tiveleFee!),
                                              double.parse(
                                                  productDataList[index]
                                                      .gstAmount!),
                                              double.parse(
                                                  productDataList[index]
                                                      .shippingCost!),
                                              productDataList[index].latitude,
                                              productDataList[index]
                                                  .longitude));
                                          if (globals.checkLogin) {
                                            showLoginErrorDialog();
                                          } else {
                                            checkLocationToBookOrder(
                                                productD,
                                                productDataList[index].likes,
                                                productDataList[index].rating,
                                                productDataList[index].isLiked,
                                                productDataList[index]);
                                          }
                                        },
                                        child: Container(
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(0),
                                            ),
                                            child: itemPhotoUrls.isNotEmpty
                                                ? Container(
                                                    height:
                                                        MediaQuery.of(context)
                                                                    .size
                                                                    .width /
                                                                1.3 -
                                                            25,
                                                    width:
                                                        MediaQuery.of(context)
                                                            .size
                                                            .width,
                                                    child: picsListView())
                                                : Image.asset(
                                                    "assets/text.png",
                                                    fit: BoxFit.cover,
                                                    height: width / 1.3 - 25,
                                                    width: width,
                                                  ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        right: 16,
                                        child: Text.rich(
                                          TextSpan(
                                            text: "\$" +
                                                productDataList[index]
                                                    .newPrice!,
                                            style: Global.style(
                                              size: 16,
                                              bold: true,
                                            ),
                                            children: [
                                              TextSpan(
                                                text: " \$" +
                                                    productDataList[index]
                                                        .oldPrice!,
                                                style: Global.style(
                                                  size: 13,
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
                                  // itemPhotoUrls.isNotEmpty?Container(
                                  //   alignment: Alignment.center,
                                  //   margin: EdgeInsets.only(top: 10),
                                  //   child: Row(
                                  //       mainAxisAlignment: MainAxisAlignment.center,
                                  //       children: List.generate(
                                  //           itemPhotoUrls.length,
                                  //               (index) =>
                                  //               Container(
                                  //                   margin: EdgeInsets.all(2),
                                  //                   width: 10,
                                  //                   height: 10,
                                  //                   decoration: BoxDecoration(
                                  //
                                  //                     // color: checkPhotoIndex==0 &&index==0?Colors.white:
                                  //                     // checkPhotoIndex==1 &&index==1?Colors.white:
                                  //                     // checkPhotoIndex==2 &&index==2?Colors.white:
                                  //                     color:Colors.white,
                                  //                     shape: BoxShape.circle,
                                  //                   )
                                  //               )
                                  //       )
                                  //   ),
                                  // ):Container(),
                                  Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            RatingBar.builder(
                                              initialRating: double.parse(
                                                  productDataList[index]
                                                      .rating!),
                                              minRating: 1,
                                              unratedColor: Colors.grey,
                                              glowColor: Colors.orange,
                                              direction: Axis.horizontal,
                                              allowHalfRating: true,
                                              ignoreGestures: true,
                                              itemCount: 5,
                                              itemSize: 20,
                                              itemPadding: EdgeInsets.symmetric(
                                                  horizontal: 0),
                                              itemBuilder: (context, _) => Icon(
                                                Icons.star,
                                                color: Colors.yellow[800],
                                                size: 20,
                                              ),
                                              onRatingUpdate: (rating) {
                                                print(rating);
                                              },
                                            )
                                          ],
                                        )),
                                        Row(
                                          children: [
                                            !productDataList[index].isLiked!
                                                ? IconButton(
                                                    icon: Icon(
                                                        Icons.favorite_border,
                                                        color: Colors.grey),
                                                    padding:
                                                        EdgeInsets.all(1.0),
                                                    onPressed: () {
                                                      if (globals.checkLogin) {
                                                        showLoginErrorDialog();
                                                      } else {
                                                        setState(() {
                                                          productDataList[index]
                                                                  .isLiked =
                                                              !productDataList[
                                                                      index]
                                                                  .isLiked!;
                                                          productDataList[index]
                                                                  .likes! +
                                                              1;
                                                          _pressed(
                                                              productDataList[
                                                                      index]
                                                                  .id);
                                                        });
                                                      }
                                                    },
                                                  )
                                                : IconButton(
                                                    icon: Icon(Icons.favorite,
                                                        color: Colors.red),
                                                    padding:
                                                        EdgeInsets.all(1.0),
                                                    onPressed: () {
                                                      if (globals.checkLogin) {
                                                        showLoginErrorDialog();
                                                      } else {
                                                        setState(() {
                                                          productDataList[index]
                                                                  .isLiked =
                                                              !productDataList[
                                                                      index]
                                                                  .isLiked!;
                                                          productDataList[index]
                                                                  .likes! -
                                                              1;
                                                          _pressed(
                                                              productDataList[
                                                                      index]
                                                                  .id);
                                                        });
                                                      }
                                                    },
                                                  ),
                                            SizedBox(width: 8),
                                            Text(
                                              "Like by " +
                                                  productDataList[index]
                                                      .likes
                                                      .toString() +
                                                  " people",
                                              style: Global.style(),
                                            ),
                                          ],
                                        ),
                                        // SizedBox(height: 8),
                                        // Text(
                                        //   requests[index].description/*== null? "":requests[index].description*/,
                                        //   style: Global.style(),
                                        // ),
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }

  checkLocationToBookOrder(List<ProductM> productD, int? likes, String? rating,
      bool? isLiked, ProductDatum productDataList) async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      print("asli");
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Get.snackbar(
            "Notification", "Please Enable your GPS/Location to  book order",
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
      } else {
        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            Get.snackbar("Notification",
                "Please Enable your GPS/Location to  book order",
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
          } else {
            Get.to(CustomerDetailPage(),
                arguments: [productD, likes, rating, isLiked, productDataList]);
          }
        } else {
          Get.to(CustomerDetailPage(),
              arguments: [productD, likes, rating, isLiked, productDataList]);
        }
      }
    } else {
      print("locationnnnnnnnnnnnnnn");
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          Get.snackbar(
              "Notification", "Please Enable your GPS/Location to  book order",
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
        } else {
          Get.to(CustomerDetailPage(),
              arguments: [productD, likes, rating, isLiked, productDataList]);
        }
      } else {
        Get.to(CustomerDetailPage(),
            arguments: [productD, likes, rating, isLiked, productDataList]);
      }
    }
  }

  PageController pageController = PageController();
  int checkPhotoIndex = 0;
  Widget picsListView() {
    return PageView.builder(
      itemCount: 1,
      onPageChanged: (i) {
        setState(() {
          checkPhotoIndex = i;
        });
      },
      controller: pageController,
      itemBuilder: (context, index) => pic_listget(itemPhotoUrls[index], index),
    );
  }

  Widget pic_listget(itemPhotoUrl, int index) {
    print(checkMedia[index]);
    print(itemPhotoUrl);
    return checkMedia[index] == "image"
        ? Image.network(
            URLS.BASEURL + itemPhotoUrl,
            fit: BoxFit.cover,
            height: MediaQuery.of(context).size.width / 1.3 - 25,
            width: 50,
          )
        : checkMedia[index] == "video"
            ? AspectRatio(
                aspectRatio: 16.0 / 9.0,
                child: BetterPlayer(
                  controller: BetterPlayerController(
                    BetterPlayerConfiguration(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      looping: true,
                      controlsConfiguration: BetterPlayerControlsConfiguration(
                        controlBarColor: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    betterPlayerDataSource: BetterPlayerDataSource(
                      BetterPlayerDataSourceType.network,
                      URLS.BASEURL + itemPhotoUrl,
                      placeholder: Image.asset(
                        'assets/text.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              )
            // ? AspectRatio(
            //     aspectRatio: 16.0 / 9.0,
            //     child: BetterVideoPlayer(
            //       controller: BetterVideoPlayerController(),
            //       // Controller manages the video playback
            //       configuration: BetterVideoPlayerConfiguration(
            //         placeholder: Image.asset(
            //           'assets/text.png',
            //           fit: BoxFit.contain,
            //         ),
            //       ), // Configuration for video player appearance and behavior
            //       dataSource: BetterVideoPlayerDataSource(
            //           BetterVideoPlayerDataSourceType.network,
            //           URLS.BASEURL + itemPhotoUrl),
            //       isFullScreen: false,
            //     ))
            : Container();
  }

  _pressed(String? productId) async {
    print("PRESSED BADAR");
    Map userData = {
      'product_id': productId,
    };
    await customerAddLikeController.fetchAddLike(userData);
    if (customerAddLikeController.addLikeINfo.value.status == 200) {
      print(customerAddLikeController.addLikeINfo.value.data);
    } else {
      print(customerAddLikeController.addLikeINfo.value.status.toString() +
          ": status code _pressed");
    }
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
        productDataList.clear();
      });
      var position = await Global.determinePosition();
      await getTiveleDataController.fetchTiveleData(
        "0",
        position.longitude.toString(),
        position.latitude.toString(),
      );
      if (getTiveleDataController.tiveleDataINfo.value.status == 200) {
        setState(() {
          productDataList
              .addAll(getTiveleDataController.tiveleDataINfo.value.data!);
          isBusy = false;
          isListNull = false;
          page = 1;
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
        productDataList.clear();
      });
      await getTiveleDataController.fetchTiveleData("0", "0", "0");
      if (getTiveleDataController.tiveleDataINfo.value.status == 200) {
        setState(() {
          productDataList
              .addAll(getTiveleDataController.tiveleDataINfo.value.data!);
          isBusy = false;
          isListNull = false;
          page = 1;
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

  dynamic _onLoading() async {
    //await Future.delayed(Duration(milliseconds: 1000));
    print(page);
    await checkLocationPermissionForRefresh();
    if (checkLocation) {
      var position = await Global.determinePosition();
      await getTiveleDataController.fetchTiveleData(
        page.toString(),
        position.longitude.toString(),
        position.latitude.toString(),
      );
      if (getTiveleDataController.tiveleDataINfo.value.status == 200) {
        productDataList
            .addAll(getTiveleDataController.tiveleDataINfo.value.data!);
        page++;
      }
    } else {
      await getTiveleDataController.fetchTiveleData(page.toString(), "0", "0");
      if (getTiveleDataController.tiveleDataINfo.value.status == 200) {
        productDataList
            .addAll(getTiveleDataController.tiveleDataINfo.value.data!);
        page++;
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

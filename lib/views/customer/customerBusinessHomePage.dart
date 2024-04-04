import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:location/location.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/reviews.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/controllers/customer/customerHomeController.dart';
import 'package:e_commerce_foods/controllers/customer/customerHomeController2.dart';
import 'package:e_commerce_foods/controllers/customer/customerLikeController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/GlobalProperties/GlobalProperties.dart';
import 'package:e_commerce_foods/models/customer/getExploreDataModel.dart';
import 'package:e_commerce_foods/models/productModel.dart';
import 'package:e_commerce_foods/service/account/userProfile_service.dart';
import 'package:e_commerce_foods/service/account/user_service.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/views/customer/businessProfileFollowPage.dart';
import 'package:e_commerce_foods/views/customer/customerDetailPage.dart';
import 'package:e_commerce_foods/views/customer/customerLoginPage.dart';

class CustomerBusinessesHomePage extends StatefulWidget {
  @override
  _BusinessesState createState() => _BusinessesState();
}

class _BusinessesState extends State<CustomerBusinessesHomePage> {
  TextEditingController controller = TextEditingController();
  final CustomerHomeController customerHomeController =
      Get.put(CustomerHomeController());
  final CustomerHomeController2 customerHomeController2 =
      Get.put(CustomerHomeController2());
  final CustomerAddLikeController customerAddLikeController =
      Get.put(CustomerAddLikeController());
  //Items _product;
  bool Liked = false;
  int checkRefreshIndex = 0;
  bool isBusy = false;
  int addIndex = 0;
  bool checkInitialProducts = true;
  List<ProductDatum>? productDataList = [];
  int pageIndex = 1;
  // int userId = 0;
  String burger =
      'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg';
  List itemPhotoUrls = [];
  List checkMedia = [];
  int checkPhotoIndex = 0;
  bool isLike = false;
  bool _isLoading = false;
  bool _hasMore = true;
  Location location = new Location();
  late bool serviceEnabled;
  PermissionStatus? _permissionGranted;
  ScrollController scrollController = ScrollController();
  final ItemScrollController itemScrollController = ItemScrollController();
  @override
  initState() {
    super.initState();
    if (!globals.checkLogin) {
      getHomeData();
    }
  }

  getHomeData() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      customerHomeController.fetchCustomerHomeData("0");
    });
  }

  getLocationAddress(List<ProductM> productD, int? likes, String? rating,
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

  void loadData() async {
    print("getting data");
    //await customerHomeController.fetchCustomerHomeData("1");

    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      setState(() {
        _hasMore = true;
        _isLoading = false;
      });
      await customerHomeController2.fetchCustomerHomeData(pageIndex.toString());
      if (customerHomeController2.homeINfo.value.status == 200) {
        setState(() {
          productDataList!.addAll(customerHomeController2.homeINfo.value.data!);
          print("lengthhhh");
          print(productDataList!.length);
          print(pageIndex);
          pageIndex++;
        });
      } else {
        setState(() {
          _isLoading = true;
          _hasMore = false;
        });
      }
    });
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  void _onRefresh() async {
    // monitor network fetch
    // await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    setState(() {
      checkInitialProducts = true;
    });
    productDataList!.clear();
    await customerHomeController.fetchCustomerHomeData("0");
    _refreshController.refreshCompleted();
  }

  Future _onLoading() async {
    // await Future.delayed(Duration(milliseconds: 1000));
    await customerHomeController2.fetchCustomerHomeData(pageIndex.toString());
    if (customerHomeController2.homeINfo.value.status == 200) {
      productDataList!.addAll(customerHomeController2.homeINfo.value.data!);
      pageIndex++;
    }
    if (mounted) setState(() {});
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    // final requests = context.watch<ProductsProvider>().product;
    // final likedProducts = context.watch<ProductsProvider>().productlikebyUser;
    // final user = context.watch<BusinessUsersProvider>().userProfile;
    //final product = Provider.of<Items>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: globals.checkLogin
            ? InkWell(
                onTap: () async {
                  Get.offAll(CustomerLoginPage());
                },
                child: Center(
                  child: Text(
                    'Login to see products/ follow business',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 14,
                      letterSpacing: 3,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              )
            : Obx(() {
                if (customerHomeController.isLoading.value) {
                  return Center(child: globals.circularIndicator());
                } else if (customerHomeController.isListNull.value) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "No Items Found!",
                            textAlign: TextAlign.center,
                            style: Global.style(
                              size: 18,
                              bold: true,
                            ),
                          ),
                          Text(
                            "Goto Eplore/Tivele Deals page or Follow business to see items.",
                            textAlign: TextAlign.center,
                            style: Global.style(
                              size: 14,
                              bold: true,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  if (checkInitialProducts) {
                    productDataList =
                        customerHomeController.homeINfo.value.data;
                  }
                  checkInitialProducts = false;
                  return SmartRefresher(
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
                    child: ListView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                      itemCount: productDataList!.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        itemPhotoUrls.clear();
                        checkMedia.clear();
                        if (productDataList![index]
                            .productImages!
                            .contains(",")) {
                          itemPhotoUrls =
                              productDataList![index].productImages!.split(",");
                          for (int i = 0; i < itemPhotoUrls.length; i++) {
                            String mimeStr = lookupMimeType(itemPhotoUrls[i])!;
                            if (mimeStr.isNotEmpty) {
                              var fileType = mimeStr.split('/');
                              checkMedia.add(fileType[0]);
                            }
                          }
                        } else {
                          itemPhotoUrls
                              .add(productDataList![index].productImages);
                          String mimeStr = lookupMimeType(itemPhotoUrls[0])!;
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
                                  print("BAAAAAAAAAADAR");
                                  print(productDataList![index].businessId);
                                  Get.to(BusinessProfileFollowPage(),
                                      arguments: [
                                        productDataList![index].businessId
                                      ]);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      productDataList![index].businessName!,
                                      style: Global.style(
                                        size: 18,
                                        bold: true,
                                      ),
                                    ),
                                    Icon(
                                      productDataList![index].isReputable == "1"
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
                                        productDataList![index].id,
                                        productDataList![index].businessId,
                                        productDataList![index].categoryName,
                                        productDataList![index].name,
                                        productDataList![index].description,
                                        productDataList![index].productImages,
                                        productDataList![index].status,
                                        double.parse(
                                            productDataList![index].newPrice!),
                                        double.parse(
                                            productDataList![index].oldPrice!),
                                        double.parse(
                                            productDataList![index].tiveleFee!),
                                        double.parse(
                                            productDataList![index].gstAmount!),
                                        double.parse(productDataList![index]
                                            .shippingCost!),
                                        productDataList![index].latitude,
                                        productDataList![index].longitude));
                                    getLocationAddress(
                                        productD,
                                        productDataList![index].likes,
                                        productDataList![index].rating,
                                        productDataList![index].isLiked,
                                        productDataList![index]);
                                  },
                                  child: Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(0),
                                      ),
                                      child: itemPhotoUrls.isNotEmpty
                                          ? Container(
                                              height: MediaQuery.of(context)
                                                          .size
                                                          .width /
                                                      1.3 -
                                                  25,
                                              width: MediaQuery.of(context)
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
                                          productDataList![index].newPrice!,
                                      style: Global.style(
                                        size: 16,
                                        bold: true,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: " \$" +
                                              productDataList![index].oldPrice!,
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
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      RatingBar.builder(
                                        initialRating: double.parse(
                                            productDataList![index].rating!),
                                        minRating: 1,
                                        unratedColor: Colors.grey,
                                        glowColor: Colors.orange,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        ignoreGestures: true,
                                        itemCount: 5,
                                        itemSize: 20,
                                        itemPadding:
                                            EdgeInsets.symmetric(horizontal: 0),
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
                                      !productDataList![index].isLiked!
                                          ? IconButton(
                                              icon: Icon(Icons.favorite_border,
                                                  color: Colors.grey),
                                              padding: EdgeInsets.all(1.0),
                                              onPressed: () {
                                                setState(() {
                                                  productDataList![index]
                                                          .isLiked =
                                                      !productDataList![index]
                                                          .isLiked!;
                                                  productDataList![index]
                                                          .likes! +
                                                      1;
                                                  _pressed(
                                                      productDataList![index]
                                                          .id);
                                                });
                                              },
                                            )
                                          : IconButton(
                                              icon: Icon(Icons.favorite,
                                                  color: Colors.red),
                                              padding: EdgeInsets.all(1.0),
                                              onPressed: () {
                                                setState(() {
                                                  productDataList![index]
                                                          .isLiked =
                                                      !productDataList![index]
                                                          .isLiked!;
                                                  productDataList![index]
                                                          .likes! -
                                                      1;
                                                  _pressed(
                                                      productDataList![index]
                                                          .id);
                                                });
                                              },
                                            ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Like by " +
                                            productDataList![index]
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
                  );
                }
              }),
      ),
    );
  }

  PageController pageController = PageController();
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
            // ? AspectRatio(
            //     aspectRatio: 16.0 / 9.0,
            //     child: BetterVideoPlayer(
            //       controller: BetterVideoPlayerController.configuration(
            //         BetterVideoPlayerConfiguration(
            //           placeholder: Image.asset(
            //             'assets/text.png',
            //             fit: BoxFit.contain,
            //           ),
            //         ),
            //       ),
            //       isFullScreen: false,
            //       dataSource: BetterVideoPlayerDataSource(
            //         BetterVideoPlayerDataSourceType.network,
            //         URLS.BASEURL + itemPhotoUrl,
            //       ),
            //     ),
            //   )
            : Container();
  }

  getProductDetail(String id, BuildContext ctx) async {
    ctx.read<ProductsProvider>().getProducts(id);
  }

  getBusinessUserProfile(String id, BuildContext ctx) async {
    ctx.read<BusinessUsersProvider>().getBussinessUsers(id);
  }

  getProductReview(String id, BuildContext ctx) async {
    ctx.read<ReviewsProvider>().getReviewByProductId(id);
  }

  GetAccountType() async {
    var userId = await SessionService.retrieveUserId();
    var response = await UserProfileService.getAccountType(userId);
    if (response != null) {
      if (response == 0) {
        setState(() {
          Global.isBusinessAccount = false;
          Global.isDriverAccount = false;
        });
      } else if (response == 1) {
        setState(() {
          Global.isBusinessAccount = true;
          Global.isDriverAccount = true;
        });
      } else if (response == 2) {
        setState(() {
          Global.isBusinessAccount = false;
          Global.isDriverAccount = true;
        });
      }
    }
  }

  _GetProfile() async {
    try {
      if (this.mounted) {
        setState(() {
          isBusy = true;
        });
      }
      var response = await UserService.getProfile();
      if (response != null) {
        var profileData = response["userProfile"];
        var url = profileData["url"];
        setState(() {
          GlobalProperties.defaultProfileImageUrl = url;
        });
        if (this.mounted) {
          setState(() {
            isBusy = false;
          });
        }
      } else {
        if (this.mounted) {
          setState(() {
            isBusy = false;
          });
        }
      }
    } catch (err) {
      if (this.mounted) {
        setState(() {
          isBusy = false;
        });
      }
    }
  }
}

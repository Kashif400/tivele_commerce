import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/controllers/customer/GetFavoriteProductsController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/productModel.dart';
import 'package:e_commerce_foods/views/customer/customerDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Reviews extends StatefulWidget {
  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final GetFavoriteProductsController _favoriteProductsController =
      Get.put(GetFavoriteProductsController());

  TextEditingController controller = TextEditingController();
  List itemPhotoUrls = [];
  List checkMedia = [];
  String car =
      'https://static01.nyt.com/images/2007/06/15/automobiles/600-scion-01.jpg';
  Position? currentLocation;
  bool isBusy = false;

  initData() async {
    _favoriteProductsController.fetchfavouriteproduct();
    var loc = await Global.determinePosition();
    setState(() {
      currentLocation = loc;
    });
  }

  @override
  initState() {
    super.initState();
    setState(() {
      isBusy = true;
    });
    initData();
    // context.read<ProductsProvider>().getProductLikeByUser();
    // context.read<BusinessUsersProvider>().getBussinessUser();
  }

  @override
  Widget build(BuildContext context) {
    //  var fav = context.watch<ProductsProvider>().productlikebyUser;
    CheckListCount(_favoriteProductsController.myFavList.length);
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
//        appBar: AppBar(
//          elevation: 0,
//          backgroundColor: Colors.black,
//          title: Text(
//            'TIVELE',
//            style: Global.style(
//              size: 22,
//              bold: true,
//              caps: true,
//            ),
//          ),
//          centerTitle: true,
//        ),
        body: ModalProgressHUD(
          child: _favoriteProductsController.myFavList.length == 0
              ? Center(
                  child: Container(
                      child: Text(
                    "No Data to show",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  )),
                )
              : Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: ListView.separated(
//              physics: NeverScrollableScrollPhysics(),

                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        itemPhotoUrls.clear();
                        checkMedia.clear();
                        if (_favoriteProductsController
                            .myFavList[index].productImages!
                            .contains(",")) {
                          itemPhotoUrls = _favoriteProductsController
                              .myFavList[index].productImages!
                              .split(",");
                          for (int i = 0; i < itemPhotoUrls.length; i++) {
                            String mimeStr = lookupMimeType(itemPhotoUrls[i])!;
                            var fileType = mimeStr.split('/');
                            checkMedia.add(fileType[0]);
                          }
                        } else {
                          itemPhotoUrls.add(_favoriteProductsController
                              .myFavList[index].productImages);
                          String mimeStr = lookupMimeType(itemPhotoUrls[0])!;
                          var fileType = mimeStr.split('/');
                          checkMedia.add(fileType[0]);
                        }
                        return Padding(
                          padding: EdgeInsets.symmetric(
                            //horizontal: 16,
                            vertical: 16,
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                isBusy = true;
                              });
                              List<ProductM> productD = [];
                              productD.add(ProductM(
                                  _favoriteProductsController
                                      .myFavList[index].id,
                                  _favoriteProductsController
                                      .myFavList[index].businessId,
                                  _favoriteProductsController
                                      .myFavList[index].categoryName,
                                  _favoriteProductsController
                                      .myFavList[index].name,
                                  _favoriteProductsController
                                      .myFavList[index].description,
                                  _favoriteProductsController
                                      .myFavList[index].productImages,
                                  _favoriteProductsController
                                      .myFavList[index].status,
                                  double.parse(_favoriteProductsController
                                      .myFavList[index].newPrice!),
                                  double.parse(_favoriteProductsController
                                      .myFavList[index].oldPrice!),
                                  double.parse(_favoriteProductsController
                                      .myFavList[index].tiveleFee!),
                                  double.parse(_favoriteProductsController
                                      .myFavList[index].gstAmount!),
                                  double.parse(_favoriteProductsController
                                      .myFavList[index].shippingCost!),
                                  _favoriteProductsController
                                      .myFavList[index].latitude,
                                  _favoriteProductsController
                                      .myFavList[index].longitude));
                              Get.to(CustomerDetailPage(), arguments: [
                                productD,
                                _favoriteProductsController
                                    .myFavList[index].likes,
                                _favoriteProductsController
                                    .myFavList[index].rating,
                                _favoriteProductsController
                                    .myFavList[index].isLiked
                              ]);
                            },
                            child: Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(24),
                                        ),
                                        child: checkMedia[0] == "image"
                                            ? Image.network(
                                                URLS.BASEURL + itemPhotoUrls[0],
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.cover,
                                              )
                                            : Image.asset(
                                                "assets/text.png",
                                                height: 70,
                                                width: 70,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        currentLocation != null
                                            ? Global.calculateDistance(
                                                currentLocation!.latitude,
                                                currentLocation!.longitude,
                                                double.parse(
                                                    _favoriteProductsController
                                                        .myFavList[index]
                                                        .latitude!),
                                                double.parse(
                                                    _favoriteProductsController
                                                        .myFavList[index]
                                                        .longitude!))
                                            : "",
                                        style: Global.style(
                                          size: 9,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  padding: EdgeInsets.only(right: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        child: Row(
                                          children: [
                                            Container(
                                              child: Row(
                                                children: [
                                                  RatingBar.builder(
                                                    glowColor: Colors.orange,
                                                    unratedColor: Colors.orange,
                                                    initialRating: 4,
                                                    // _favoriteProductsController
                                                    //             .myFavList[
                                                    //                 index]
                                                    //             .rating ==
                                                    //         null
                                                    //     ? 0
                                                    //     : _favoriteProductsController
                                                    //         .myFavList[index]
                                                    //         .rating,
                                                    minRating: 1,
                                                    direction: Axis.horizontal,
                                                    allowHalfRating: true,
                                                    ignoreGestures: true,
                                                    itemCount: 5,
                                                    itemSize: 20,
                                                    itemPadding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 0),
                                                    itemBuilder: (context, _) =>
                                                        Icon(
                                                      Icons.star,
                                                      color: Colors.orange,
                                                      size: 20,
                                                    ),
                                                    onRatingUpdate: (rating) {
                                                      print(rating);
                                                    },
                                                  )
                                                ],
                                              ),
                                            ),
                                            Spacer(),
                                            Text(
                                              _favoriteProductsController
                                                          .myFavList[index]
                                                          .rating ==
                                                      null
                                                  ? ''
                                                  : _favoriteProductsController
                                                      .myFavList[index].rating!,
                                              style: Global.style(
                                                size: 18,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        _favoriteProductsController
                                            .myFavList[index].name!,
                                        style: Global.style(
                                          size: 14,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        _favoriteProductsController
                                            .myFavList[index].description!,
                                        style: Global.style(
                                          size: 10,
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Container(
                          height: 1,
                          width: double.infinity,
                          color: Colors.white,
                        );
                      },
                      itemCount: _favoriteProductsController.myFavList.length),
                ),
          inAsyncCall: isBusy,
          // demo of some additional parameters
          //opacity: 0.5,
          color: Colors.black,
          progressIndicator: Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.transparent,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  CheckListCount(int count) async {
    if (count > 0) {
      await Future.delayed(Duration(seconds: 0));
      if (mounted) {
        setState(() {
          isBusy = false;
        });
      }
    } else {
      await Future.delayed(Duration(seconds: 0));
      if (mounted) {
        setState(() {
          isBusy = false;
        });
      }
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/reviews.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/GlobalProperties/GlobalProperties.dart';
import 'package:e_commerce_foods/service/Like/like.dart';
import 'package:e_commerce_foods/service/account/userProfile_service.dart';
import 'package:e_commerce_foods/service/account/user_service.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/business_profile.dart';
import 'package:e_commerce_foods/ui/item_details.dart';

class Businesses extends StatefulWidget {
  @override
  _BusinessesState createState() => _BusinessesState();
}

class _BusinessesState extends State<Businesses> {
  TextEditingController controller = TextEditingController();
  //Items _product;
  bool Liked = false;
  bool isBusy = false;
  // int userId = 0;
  String burger =
      'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg';

  @override
  initState() {
    super.initState();
    context.read<ProductsProvider>().getProduct();
    context.read<ProductsProvider>().getProductLikeByUser();
    context.read<BusinessUsersProvider>().getCurrentUser();
    _GetProfile();
    GetAccountType();

    // userId = await SessionService.retrieveUser();
  }

  _pressed(liked, req, user) async {
    if (liked) {
      setState(() {
        isBusy = true;
      });
      // var userId = await SessionService.retrieveUser();
      // final requests = context.read<ProductsProvider>().products;
      var data = {"userId": user.id, "productId": req.id};
      var like = await LikeService.deleteForMobile(data);
      context.read<ProductsProvider>().getProduct();
      context.read<ProductsProvider>().getProductLikeByUser();
    } else {
      setState(() {
        isBusy = true;
      });
      // var userId = await SessionService.retrieveUser();
      // final requests = context.read<ProductsProvider>().products;
      var data = {"userId": user.id, "productId": req.id};
      var like = await LikeService.create(data);
      context.read<ProductsProvider>().getProduct();
      context.read<ProductsProvider>().getProductLikeByUser();
    }
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final requests = context.watch<ProductsProvider>().product;
    final likedProducts = context.watch<ProductsProvider>().productlikebyUser;
    final user = context.watch<BusinessUsersProvider>().userProfile;
    //final product = Provider.of<Items>(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: ModalProgressHUD(
          child: requests.length == 0
              ? Center(
                  child: Container(
                  child: Text(
                    "No Data to show",
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                ))
              : Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  child: requests != null && requests.length != 0
                      ? ListView.separated(
                          shrinkWrap: true,
                          itemCount: requests.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 0,
                            );
                          },
                          itemBuilder: (context, index) {
                            //request = requests[index];
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 8),
                                  child: InkWell(
                                    onTap: () {
                                      getBusinessUserProfile(
                                          requests[index].businessAccount!.id!,
                                          context);
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => BusinessProfile(
                                              requests[index]
                                                  .businessAccount!
                                                  .id),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      requests[index].businessAccount!.name!,
                                      /* == null? "" : requests[index].businessAccount.name*/
                                      style: Global.style(
                                        size: 18,
                                        bold: true,
                                      ),
                                    ),
                                  ),
                                ),
                                Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        getProductDetail(
                                            requests[index].id, context);
                                        getProductReview(
                                            requests[index].id, context);
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => ItemDetails(
                                                id: requests[index].id),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(0),
                                          ),
                                          child: Image.network(
                                            //burger,
                                            requests[index].productImage != null
                                                ? requests[index]
                                                    .productImage!
                                                    .url!
                                                : "https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg" /*== null? "" :requests[index].productImage.url == null*/,
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
                                          text:
                                              "\$ ${requests[index].newPrice == null ? 0 : requests[index].newPrice}",
                                          style: Global.style(
                                            size: 16,
                                            bold: true,
                                          ),
                                          children: [
                                            TextSpan(
                                              text:
                                                  "\$ ${requests[index].oldPrice == null ? 0 : requests[index].oldPrice}",
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
                                            initialRating:
                                                requests[index].ratingAverage!,
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
                                      )
                                          /*Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 20,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 20,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 20,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 20,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 20,
                              ),
                            ],
                          ),*/
                                          ),
                                      Row(
                                        children: [
                                          likedProducts == null ||
                                                  likedProducts.length == 0 ||
                                                  !likedProducts.any(
                                                      (element) =>
                                                          element.id ==
                                                          requests[index].id)
                                              ? IconButton(
                                                  icon: Icon(
                                                      Icons.favorite_border,
                                                      color: Colors.grey),
                                                  padding: EdgeInsets.all(1.0),
                                                  onPressed: () {
                                                    _pressed(false,
                                                        requests[index], user);
                                                  },
                                                )
                                              : IconButton(
                                                  icon: Icon(Icons.favorite,
                                                      color: Colors.red),
                                                  padding: EdgeInsets.all(1.0),
                                                  onPressed: () {
                                                    _pressed(true,
                                                        requests[index], user);
                                                  },
                                                ),
                                          SizedBox(width: 8),
                                          Text(
                                            "Like by " +
                                                (requests[index].likeCount !=
                                                        null
                                                    ? requests[index]
                                                        .likeCount
                                                        .toString()
                                                    : "0") +
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
                        )
                      : Align(
                          alignment: Alignment.center,
                          child: Text(
                            "",
                            style: TextStyle(color: Colors.transparent),
                          )),
                ),
          inAsyncCall: isBusy,
          // demo of some additional parameters
          // opacity: 0.5,
          color: Colors.black,
          progressIndicator: Container(
            color: Colors.black,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
              ),
            ),
          ),
        ),
      ),
    );
  }

  getProductDetail(String? id, BuildContext ctx) async {
    ctx.read<ProductsProvider>().getProducts(id);
  }

  getBusinessUserProfile(String id, BuildContext ctx) async {
    ctx.read<BusinessUsersProvider>().getBussinessUsers(id);
  }

  getProductReview(String? id, BuildContext ctx) async {
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

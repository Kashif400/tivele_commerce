import 'dart:async';

import 'package:better_player/better_player.dart';
import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/reviews.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/Order/SingleOrder.dart';
import 'package:e_commerce_foods/models/Rules/Rule.dart';
import 'package:e_commerce_foods/models/product/SingleProduct.dart';
import 'package:e_commerce_foods/models/product/products.dart';
import 'package:e_commerce_foods/service/Like/like.dart';
import 'package:e_commerce_foods/service/Review/Reviews.dart';
import 'package:e_commerce_foods/service/Rules/Rules.dart';
import 'package:e_commerce_foods/service/order/orders_service.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';
import 'package:e_commerce_foods/ui/thank_you.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mime/mime.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class ItemDetails extends StatefulWidget {
  final String? id;
  ItemDetails({Key? key, required this.id}) : super(key: key);
  @override
  _ItemDetailsState createState() => _ItemDetailsState(id);
}

class _ItemDetailsState extends State<ItemDetails> {
  bool checkTip = false;
  String? orderTotal;
  double? tipValue = 0.0, totalTemp = 0.0;
  int orderIndex = -1;
  String? prodId;
  _ItemDetailsState(this.prodId);
  TextEditingController tipController = TextEditingController();
  TextEditingController controller = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  //TextEditingController controller = TextEditingController();
  // BetterPlayerController _betterPlayerController;
  List itemPhotoUrls = [];
  List checkMedia = [];
  int checkPhotoIndex = 0;
  Items? _product;
  double? _rating;
  bool isPaid = false;
  bool isBusy = true;
  SingleProduct? product;
  bool isChecked = false;
  double? TiveleFee;
  double? OrderGst;
  double? ProductAmount;
  double? GrandTotalAmount, OrderTotalAmount;
  bool isLoading = true;
  late double totalBeforeTax;
  String? GrandtotalAmountText, OrdertotalAmountText;
  String? tiveleFeeText;
  String? orderGstText;
  SingleOrder order = new SingleOrder();
  String burger =
      'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg';

//  Token _paymentToken;
  // PaymentMethod _paymentMethod;
  late String _error;
  final String? _paymentIntentClientSecret = null;
  //PaymentIntentResult _paymentIntent;
  //Source _source;
  ScrollController _controller = ScrollController();
  /* final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
  );
 */
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    initData();
  }

  void initData() async {
    await context.read<ProductsProvider>().getSingleProduct(prodId);
    context.read<ReviewsProvider>().getProductReviews(prodId);
/*
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_51Igno7CVzIpv7T9Kc656wg8BDpPtSFhPtMYScVu4tDJPck5bvIQurnY7hWUvr0RrmivCiEFyNFiBww5kSOK6BiuI00taaojvaH",
        merchantId: "Test",
        androidPayMode: 'test'));
*/
    var myId = await SessionService.retrieveUser();
    var rules = await RulesService.getAll();
    var pos = await Global.determinePosition();
    setState(() {
      for (var item in rules) {
        var rule = Rule.fromJson(item);
        if (rule.name!.contains("Gst")) {
          order.gst = double.parse(rule.value!);
        } else if (rule.name!.contains("Fee")) {
          order.tiveleFee = double.parse(rule.value!);
        } else if (rule.name!.contains("Shipping")) {
          order.shippingCost = double.parse(rule.value!);
        }
      }
      order.quantity = 1;
      if (product!.newPrice != null) {
        totalBeforeTax =
            product!.newPrice! + order.shippingCost! + order.tiveleFee!;
        order.totalAmount = product!.newPrice! +
            order.gst! +
            order.shippingCost! +
            order.tiveleFee!;
        order.userId = myId;
        order.productId = product!.id;
        order.latitude = pos.latitude.toString();
        order.longitude = pos.longitude.toString();
        order.orderProductAttributes = [];
        for (var item in product!.productAttributes!) {
          if (item.attributeType == 0) {
            OrderProductAttributes attr = new OrderProductAttributes();
            attr.productAttributeId = item.id;
            order.orderProductAttributes!.add(attr);
          }
        }
      }

      if (order != null && TiveleFee != null && OrderGst != null) {
        setState(() {
          order.totalAmount =
              order.shippingCost! + totalBeforeTax + TiveleFee! + OrderGst!;
        });
      }

      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var loader = context.watch<ProductsProvider>().ProductLoading;
    final _product = context.watch<ProductsProvider>().singleProduct;
    loader = isBusy;
    if (_product != null) {
      product = _product;
      if (product!.description!.contains("@#@#@")) {
        itemPhotoUrls = product!.description!.split("@#@#@");
        product!.description =
            itemPhotoUrls[itemPhotoUrls.length - 1].toString();
        for (int i = 0; i < itemPhotoUrls.length - 1; i++) {
          String mimeStr = lookupMimeType(itemPhotoUrls[i])!;
          var fileType = mimeStr.split('/');
          checkMedia.add(fileType[0]);
        }
      }
      if (ProductAmount == null) {
        ProductAmount = product!.newPrice;
      }

      if (TiveleFee == null && order.tiveleFee != null) {
        TiveleFee = order.tiveleFee! / 100 * product!.newPrice!;
        tiveleFeeText = TiveleFee!.toStringAsFixed(1);
      }
      if (OrderGst == null && order.gst != null) {
        OrderGst = order.gst! / 100 * product!.newPrice!;
        orderGstText = OrderGst!.toStringAsFixed(1);
      }
      if (GrandTotalAmount == null && order.shippingCost != null) {
        GrandTotalAmount =
            order.shippingCost! + product!.newPrice! + TiveleFee! + OrderGst!;
        GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);

        OrderTotalAmount =
            order.shippingCost! + product!.newPrice! + TiveleFee! + OrderGst!;
        OrdertotalAmountText = OrderTotalAmount!.toStringAsFixed(1);
        totalTemp = GrandTotalAmount;
      }
    }
    final likedProducts = context.watch<ProductsProvider>().productlikebyUser;
    final rev = context.watch<ReviewsProvider>().reviewbyProduct;
    context.watch<ReviewsProvider>().reviewbyProduct;

    double width = MediaQuery.of(context).size.width;

    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text(
            'TIVELE',
            style: Global.style(
              size: 22,
              bold: true,
              caps: true,
            ),
          ),
          centerTitle: true,
        ),
        body: ModalProgressHUD(
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: product != null && order.quantity != null
                ? SingleChildScrollView(
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                product!.name!,
                                style: Global.style(
                                  size: 18,
                                  bold: true,
                                ),
                              ),
                            ),
                            Stack(
                              children: [
                                Container(
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
                                        : Image.network(
                                            //burger,
                                            product!.productImage != null
                                                ? product!.productImage!.url!
                                                : "https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg",
                                            fit: BoxFit.cover,
                                            height: width / 1.3 - 25,
                                            width: width,
                                          ),
                                  ),
                                ),
                                Positioned(
                                  bottom: 8,
                                  right: 16,
                                  child: Text.rich(
                                    TextSpan(
                                      text:
                                          "\$ ${product!.newPrice == null ? 0 : product!.newPrice}",
                                      style: Global.style(
                                        size: 16,
                                        bold: true,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              "\$ ${product!.oldPrice == null ? 0 : product!.oldPrice}",
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
                            itemPhotoUrls.isNotEmpty
                                ? Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 10),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                            itemPhotoUrls.length - 1,
                                            (index) => Container(
                                                margin: EdgeInsets.all(2),
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: checkPhotoIndex == 0 &&
                                                          index == 0
                                                      ? Colors.white
                                                      : checkPhotoIndex == 1 &&
                                                              index == 1
                                                          ? Colors.white
                                                          : checkPhotoIndex ==
                                                                      2 &&
                                                                  index == 2
                                                              ? Colors.white
                                                              : Colors.grey,
                                                  shape: BoxShape.circle,
                                                )))),
                                  )
                                : Container(),
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
                                          glowColor: Colors.orange,
                                          unratedColor: Colors.grey,
                                          initialRating:
                                              product!.ratingAverage!,
                                          minRating: 1,
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
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      likedProducts == null ||
                                              likedProducts.length == 0 ||
                                              !likedProducts.any((element) =>
                                                  element.id == product!.id)
                                          ? IconButton(
                                              icon: Icon(Icons.favorite_border,
                                                  color: Colors.grey),
                                              padding: EdgeInsets.all(1.0),
                                              onPressed: () {
                                                _pressed(false);
                                              },
                                            )
                                          : IconButton(
                                              icon: Icon(Icons.favorite,
                                                  color: Colors.red),
                                              padding: EdgeInsets.all(1.0),
                                              onPressed: () {
                                                _pressed(true);
                                              },
                                            ),
                                      SizedBox(width: 8),
                                      Text(
                                        "Liked by " +
                                            product!.likeCount.toString() +
                                            " people",
                                        style: Global.style(),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    product!.description!,
                                    style: Global.style(),
                                  ),
                                  SizedBox(height: 12),
                                ],
                              ),
                            )
                          ],
                        ),
                        Visibility(
                          visible: false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 8),
                                child: Text(
                                  'Reviews',
                                  style: Global.style(
                                    size: 18,
                                    bold: true,
                                  ),
                                ),
                              ),
                              ListView.separated(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      vertical: 16,
                                      horizontal: 16,
                                    ),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(24),
                                          ),
                                          child: Image.network(
                                            rev[index].user!.userProfile != null
                                                ? rev[index]
                                                    .user!
                                                    .userProfile!
                                                    .url!
                                                : Global.defaultUserPic,
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        SizedBox(width: 16),
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Container(
                                                width: width - 118,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      rev[index]
                                                          .user!
                                                          .fullName!,
                                                      style: Global.style(
                                                        size: 14,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          RatingBar.builder(
                                                            initialRating:
                                                                rev[index]
                                                                    .rating!,
                                                            minRating: 1,
                                                            direction:
                                                                Axis.horizontal,
                                                            allowHalfRating:
                                                                true,
                                                            itemCount: 5,
                                                            itemSize: 20,
                                                            itemPadding: EdgeInsets
                                                                .symmetric(
                                                                    horizontal:
                                                                        0),
                                                            itemBuilder:
                                                                (context, _) =>
                                                                    Icon(
                                                              Icons.star,
                                                              color: Colors
                                                                  .yellow[800],
                                                              size: 20,
                                                            ),
                                                            onRatingUpdate:
                                                                (rating) {
                                                              print(rating);
                                                            },
                                                            ignoreGestures:
                                                                true,
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 8),
                                              Container(
                                                width: width - 118,
                                                child: Text(
                                                  rev[index].comment!,
                                                  style: Global.style(
                                                    size: 10,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        )
                                      ],
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
                                itemCount: rev.length,
                              ),
                              // InkWell(
                              //   onTap: leaveReviewDialog,
                              //   child: Padding(
                              //     padding: EdgeInsets.symmetric(
                              //       horizontal: 24,
                              //       vertical: 16,
                              //     ),
                              //     child: Align(
                              //       alignment: Alignment.centerRight,
                              //       child: Text(
                              //         'Leave the Review',
                              //         style: Global.style(
                              //           size: 18,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        ),

                        SizedBox(height: 16),
                        // ConfirmationSlider(
                        //   onConfirmation: () {
                        //     getProductDetail(product.id,context);
                        //     Navigator.of(context).push(
                        //       MaterialPageRoute(
                        //      builder: (_) => OrderConfirmation(prod:product),
                        //       ),
                        //     );
                        //   },
                        //   backgroundColor: Colors.white,
                        //   foregroundColor: Colors.black,
                        //   textStyle: Global.style(
                        //     color: Colors.black,
                        //     size: 16,
                        //   ),
                        //   text: 'Swipe to Confirm',
                        //   height: 50,
                        // ),
                        //NextPageData
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: product!.productAttributes!.length,
                                itemBuilder: (context, index) {
                                  // return Text("Hello");
                                  return buildAttributeValuesWidget(context,
                                      product!.productAttributes![index]);
                                },
                              ),
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    'Quantity',
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  IconButton(
                                      icon: Icon(Icons.remove,
                                          color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          if (order.quantity == 1) {
                                            Fluttertoast.showToast(
                                                msg:
                                                    "Quantity can not be less than 1",
                                                toastLength: Toast.LENGTH_SHORT,
                                                gravity: ToastGravity.BOTTOM,
                                                backgroundColor: Colors.red,
                                                textColor: Colors.white);
                                            return;
                                          }
                                          order.quantity! - 1;
                                          ProductAmount = ProductAmount! -
                                              product!.newPrice!;
                                          TiveleFee = order.tiveleFee! /
                                              100 *
                                              ProductAmount!;
                                          OrderGst =
                                              order.gst! / 100 * ProductAmount!;
                                          OrderTotalAmount =
                                              order.shippingCost! +
                                                  ProductAmount! +
                                                  TiveleFee! +
                                                  OrderGst!;
                                          OrdertotalAmountText =
                                              OrderTotalAmount!
                                                  .toStringAsFixed(1);
                                          if (tipController.text.isEmpty) {
                                            GrandTotalAmount =
                                                order.shippingCost! +
                                                    ProductAmount! +
                                                    TiveleFee! +
                                                    OrderGst!;
                                          } else {
                                            GrandTotalAmount =
                                                order.shippingCost! +
                                                    ProductAmount! +
                                                    TiveleFee! +
                                                    OrderGst! +
                                                    double.parse(
                                                        tipController.text);
                                          }
                                          if (orderIndex == 0) {
                                            tipValue =
                                                (5 / 100) * OrderTotalAmount!;
                                            orderTotal =
                                                (OrderTotalAmount! + tipValue!)
                                                    .toStringAsFixed(1);
                                            GrandTotalAmount =
                                                order.shippingCost! +
                                                    ProductAmount! +
                                                    TiveleFee! +
                                                    OrderGst! +
                                                    tipValue!;
                                          } else if (orderIndex == 1) {
                                            tipValue =
                                                (10 / 100) * OrderTotalAmount!;
                                            orderTotal =
                                                (OrderTotalAmount! + tipValue!)
                                                    .toStringAsFixed(1);
                                            GrandTotalAmount =
                                                order.shippingCost! +
                                                    ProductAmount! +
                                                    TiveleFee! +
                                                    OrderGst! +
                                                    tipValue!;
                                          } else if (orderIndex == 2) {
                                            tipValue =
                                                (15 / 100) * OrderTotalAmount!;
                                            orderTotal =
                                                (OrderTotalAmount! + tipValue!)
                                                    .toStringAsFixed(1);
                                            GrandTotalAmount =
                                                order.shippingCost! +
                                                    ProductAmount! +
                                                    TiveleFee! +
                                                    OrderGst! +
                                                    tipValue!;
                                          } else if (orderIndex == 3) {
                                            tipValue =
                                                (20 / 100) * OrderTotalAmount!;
                                            orderTotal =
                                                (OrderTotalAmount! + tipValue!)
                                                    .toStringAsFixed(1);
                                            GrandTotalAmount =
                                                order.shippingCost! +
                                                    ProductAmount! +
                                                    TiveleFee! +
                                                    OrderGst! +
                                                    tipValue!;
                                          }
                                          GrandtotalAmountText =
                                              GrandTotalAmount!
                                                  .toStringAsFixed(1);
                                          orderGstText =
                                              OrderGst!.toStringAsFixed(1);
                                          tiveleFeeText =
                                              TiveleFee!.toStringAsFixed(1);
                                          totalTemp = GrandTotalAmount;
                                          // order.tiveleFee=TiveleFee;
                                          // order.gst=OrderGst;
                                          // order.totalAmount=TotalAmount;
                                        });
                                      }),
                                  Text(
                                    order.quantity.toString(),
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                  IconButton(
                                      icon:
                                          Icon(Icons.add, color: Colors.white),
                                      onPressed: () {
                                        setState(() {
                                          order.quantity! + 1;
                                          ProductAmount = ProductAmount! +
                                              product!.newPrice!;
                                          TiveleFee = order.tiveleFee! /
                                              100 *
                                              ProductAmount!;
                                          OrderGst =
                                              order.gst! / 100 * ProductAmount!;
                                          OrderTotalAmount =
                                              order.shippingCost! +
                                                  ProductAmount! +
                                                  TiveleFee! +
                                                  OrderGst!;
                                          OrdertotalAmountText =
                                              OrderTotalAmount!
                                                  .toStringAsFixed(1);
                                          if (tipController.text.isEmpty) {
                                            GrandTotalAmount =
                                                order.shippingCost! +
                                                    ProductAmount! +
                                                    TiveleFee! +
                                                    OrderGst!;
                                          } else {
                                            GrandTotalAmount =
                                                order.shippingCost! +
                                                    ProductAmount! +
                                                    TiveleFee! +
                                                    OrderGst! +
                                                    double.parse(
                                                        tipController.text);
                                          }
                                          if (orderIndex == 0) {
                                            tipValue =
                                                (5 / 100) * OrderTotalAmount!;
                                            orderTotal =
                                                (OrderTotalAmount! + tipValue!)
                                                    .toStringAsFixed(1);
                                            GrandTotalAmount =
                                                order.shippingCost! +
                                                    ProductAmount! +
                                                    TiveleFee! +
                                                    OrderGst! +
                                                    tipValue!;
                                          } else if (orderIndex == 1) {
                                            tipValue =
                                                (10 / 100) * OrderTotalAmount!;
                                            orderTotal =
                                                (OrderTotalAmount! + tipValue!)
                                                    .toStringAsFixed(1);
                                            GrandTotalAmount =
                                                order.shippingCost! +
                                                    ProductAmount! +
                                                    TiveleFee! +
                                                    OrderGst! +
                                                    tipValue!;
                                          } else if (orderIndex == 2) {
                                            tipValue =
                                                (15 / 100) * OrderTotalAmount!;
                                            orderTotal =
                                                (OrderTotalAmount! + tipValue!)
                                                    .toStringAsFixed(1);
                                            GrandTotalAmount =
                                                order.shippingCost! +
                                                    ProductAmount! +
                                                    TiveleFee! +
                                                    OrderGst! +
                                                    tipValue!;
                                          } else if (orderIndex == 3) {
                                            tipValue =
                                                (20 / 100) * OrderTotalAmount!;
                                            orderTotal =
                                                (OrderTotalAmount! + tipValue!)
                                                    .toStringAsFixed(1);
                                            GrandTotalAmount =
                                                order.shippingCost! +
                                                    ProductAmount! +
                                                    TiveleFee! +
                                                    OrderGst! +
                                                    tipValue!;
                                          }
                                          GrandtotalAmountText =
                                              GrandTotalAmount!
                                                  .toStringAsFixed(1);
                                          orderGstText =
                                              OrderGst!.toStringAsFixed(1);
                                          tiveleFeeText =
                                              TiveleFee!.toStringAsFixed(1);
                                          totalTemp = GrandTotalAmount;
                                          // order.tiveleFee=TiveleFee;
                                          // order.gst=OrderGst;
                                          // order.totalAmount=TotalAmount;
                                        });
                                      })
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Shipping & Handling Delivery',
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                  Text(
                                    "\$ ${order.shippingCost}",
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total Before Tax',
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                  Text(
                                    //'\$5.99',
                                    // ProductAmount!=null?
                                    // "\$ ${ProductAmount}":
                                    "\$ ${ProductAmount}",
                                    // (totalBeforeTax).toString(),
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tivele Fee',
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                  Text(
                                    TiveleFee == null
                                        ? "\$ "
                                        : "\$ $tiveleFeeText",
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Estimated GST/HST',
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                  Text(
                                    OrderGst == null
                                        ? "\$ "
                                        : "\$ $orderGstText",
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'ORDER TOTAL',
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                  Text(
                                    "\$ $OrdertotalAmountText",
                                    //'\$23.99',
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              Container(
                                alignment: Alignment.center,
                                width: double.infinity,
                                child: Text(
                                  'Add Tip \$ (Optional)',
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  tipButton(0),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  tipButton(1),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  tipButton(2),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  tipButton(3),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.03,
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding:
                                        EdgeInsets.only(left: 10, right: 0),
                                    //margin: EdgeInsets.only(left: 50, right: 50),
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    height: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: orderIndex != 4
                                            ? Colors.black
                                            : Colors.white,
                                        border: Border.all(
                                            color: Colors.white, width: 4)),
                                    child: tip_TextField(),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Tip',
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                  Text(
                                    "\$ " + tipValue!.toStringAsFixed(1),
                                    //'\$23.99',
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Grand TOTAL',
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                  Text(
                                    "\$ $GrandtotalAmountText",
                                    //'\$23.99',
                                    style: Global.style(
                                      size: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 24),
                              Align(
                                alignment: Alignment.center,
                                child: ConfirmationSlider(
                                  onConfirmation: () {
                                    if (!checkTip) {
                                      CreateProductOrder();
                                    } else {
                                      showErrorToast2("Invalid Tip value!");
                                    }
                                    /*Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ThankYou(),
                          ),
                        );*/
                                  },
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  textStyle: Global.style(
                                    color: Colors.black,
                                    size: 16,
                                  ),
                                  text: 'Swipe to Pay',
                                  height: 50,
                                ),
                              ),
                              SizedBox(height: 24),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : _closeLoader(),
          ),

          inAsyncCall: isLoading,
          // demo of some additional parameters
          //opacity: 0.5,
          progressIndicator: Container(
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

  PageController pageController = PageController();
  Widget picsListView() {
    return PageView.builder(
      itemCount: itemPhotoUrls.length - 1,
      onPageChanged: (i) {
        setState(() {
          checkPhotoIndex = i;
        });
      },
      controller: pageController,
      itemBuilder: (context, index) => pic_listget(itemPhotoUrls[index], index),
    );
  }

  Widget pic_listget(String itemPhotoUrl, int index) {
    return checkMedia[index] == "image"
        ? Image.network(
            itemPhotoUrl,
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
                      itemPhotoUrl,
                      placeholder: Image.asset(
                        'assets/text.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              )
            : Container();
  }
  // Widget pic_listget(itemPhotoUrl, int index) {
  //   return checkMedia[index] == "image"
  //       ? Image.network(
  //           itemPhotoUrl,
  //           fit: BoxFit.cover,
  //           height: MediaQuery.of(context).size.width / 1.3 - 25,
  //           width: 50,
  //         )
  //       : checkMedia[index] == "video"
  //           ? AspectRatio(
  //               aspectRatio: 16.0 / 9.0,
  //               child: BetterVideoPlayer(
  //                 controller: BetterVideoPlayerController(),
  //                 // Controller manages the video playback
  //                 configuration: BetterVideoPlayerConfiguration(
  //                   placeholder: Image.asset(
  //                     'assets/text.png',
  //                     fit: BoxFit.contain,
  //                   ),
  //                 ), // Configuration for video player appearance and behavior
  //                 dataSource: BetterVideoPlayerDataSource(
  //                     BetterVideoPlayerDataSourceType.network, itemPhotoUrl),
  //                 isFullScreen: false,
  //               ),
  //             )
  //           : Container();
  // }

  Widget tipButton(int index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.12,
      height: 40,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: BorderSide(color: Colors.white, width: 3)),
        padding: const EdgeInsets.only(top: 0),
        textColor: orderIndex == 0 && index == 0
            ? Colors.black
            : orderIndex == 1 && index == 1
                ? Colors.black
                : orderIndex == 2 && index == 2
                    ? Colors.black
                    : orderIndex == 3 && index == 3
                        ? Colors.black
                        : Colors.white,
        splashColor: orderIndex == 0 && index == 0
            ? Colors.black
            : orderIndex == 1 && index == 1
                ? Colors.black
                : orderIndex == 2 && index == 2
                    ? Colors.black
                    : orderIndex == 3 && index == 3
                        ? Colors.black
                        : Colors.white,
        color: orderIndex == 0 && index == 0
            ? Colors.white
            : orderIndex == 1 && index == 1
                ? Colors.white
                : orderIndex == 2 && index == 2
                    ? Colors.white
                    : orderIndex == 3 && index == 3
                        ? Colors.white
                        : Colors.black,
        onPressed: () {
          FocusScope.of(context).unfocus();
          tipController.clear();
          if (index == 0) {
            if (orderIndex != 0) {
              setState(() {
                tipValue = (5 / 100) * OrderTotalAmount!;
                orderTotal = (OrderTotalAmount! + tipValue!).toStringAsFixed(1);
                orderIndex = 0;
                ProductAmount = order.quantity! * product!.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount!;
                OrderGst = order.gst! / 100 * ProductAmount!;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount! +
                    TiveleFee! +
                    OrderGst! +
                    tipValue!;
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              });
            } else {
              setState(() {
                tipValue = 0;
                orderIndex = -1;
                ProductAmount = order.quantity! * product!.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount!;
                OrderGst = order.gst! / 100 * ProductAmount!;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount! +
                    TiveleFee! +
                    OrderGst!;
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              });
            }
          } else if (index == 1) {
            if (orderIndex != 1) {
              setState(() {
                tipValue = (10 / 100) * OrderTotalAmount!;
                orderTotal = (OrderTotalAmount! + tipValue!).toStringAsFixed(1);
                orderIndex = 1;
                ProductAmount = order.quantity! * product!.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount!;
                OrderGst = order.gst! / 100 * ProductAmount!;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount! +
                    TiveleFee! +
                    OrderGst! +
                    tipValue!;
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              });
            } else {
              setState(() {
                tipValue = 0;
                orderIndex = -1;
                ProductAmount = order.quantity! * product!.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount!;
                OrderGst = order.gst! / 100 * ProductAmount!;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount! +
                    TiveleFee! +
                    OrderGst!;
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              });
            }
          } else if (index == 2) {
            if (orderIndex != 2) {
              setState(() {
                tipValue = (15 / 100) * OrderTotalAmount!;
                orderTotal = (OrderTotalAmount! + tipValue!).toStringAsFixed(1);
                orderIndex = 2;
                ProductAmount = order.quantity! * product!.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount!;
                OrderGst = order.gst! / 100 * ProductAmount!;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount! +
                    TiveleFee! +
                    OrderGst! +
                    tipValue!;
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              });
            } else {
              setState(() {
                tipValue = 0;
                orderIndex = -1;
                ProductAmount = order.quantity! * product!.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount!;
                OrderGst = order.gst! / 100 * ProductAmount!;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount! +
                    TiveleFee! +
                    OrderGst!;
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              });
            }
          } else if (index == 3) {
            if (orderIndex != 3) {
              setState(() {
                tipValue = (20 / 100) * OrderTotalAmount!;
                orderTotal = (OrderTotalAmount! + tipValue!).toStringAsFixed(1);
                orderIndex = 3;
                ProductAmount = order.quantity! * product!.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount!;
                OrderGst = order.gst! / 100 * ProductAmount!;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount! +
                    TiveleFee! +
                    OrderGst! +
                    tipValue!;
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              });
            } else {
              setState(() {
                tipValue = 0;
                orderIndex = -1;
                ProductAmount = order.quantity! * product!.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount!;
                OrderGst = order.gst! / 100 * ProductAmount!;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount! +
                    TiveleFee! +
                    OrderGst!;
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              });
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              index == 0
                  ? "5 %"
                  : index == 1
                      ? "10 %"
                      : index == 2
                          ? "15 %"
                          : "20 %",
              style: TextStyle(
                  color: orderIndex == 0 && index == 0
                      ? Colors.black
                      : orderIndex == 1 && index == 1
                          ? Colors.black
                          : orderIndex == 2 && index == 2
                              ? Colors.black
                              : orderIndex == 3 && index == 3
                                  ? Colors.black
                                  : Colors.white,
                  fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget tip_TextField() {
    return TextFormField(
        controller: tipController,
        keyboardType: TextInputType.number,
        onTap: () async {
          if (orderIndex != 4) {
            setState(() {
              orderIndex = 4;
              tipValue = 0.0;
              ProductAmount = order.quantity! * product!.newPrice!;
              TiveleFee = order.tiveleFee! / 100 * ProductAmount!;
              OrderGst = order.gst! / 100 * ProductAmount!;
              GrandTotalAmount =
                  order.shippingCost! + ProductAmount! + TiveleFee! + OrderGst!;
              GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
            });
          }
        },
        onChanged: (tip) {
          setState(() {
            if (tip.isNotEmpty) {
              try {
                tipValue = double.parse(tip);
                checkTip = false;
                ProductAmount = order.quantity! * product!.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount!;
                OrderGst = order.gst! / 100 * ProductAmount!;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount! +
                    TiveleFee! +
                    OrderGst! +
                    double.parse(tipController.text);
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              } catch (e) {
                showErrorToast2("Invalid Value!");
                checkTip = true;
              }
            } else {
              tipValue = 0.0;
              ProductAmount = order.quantity! * product!.newPrice!;
              TiveleFee = order.tiveleFee! / 100 * ProductAmount!;
              OrderGst = order.gst! / 100 * ProductAmount!;
              GrandTotalAmount =
                  order.shippingCost! + ProductAmount! + TiveleFee! + OrderGst!;
              GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
            }
          });
        },
        maxLines: 1,
        style: TextStyle(
            color: orderIndex != 4 ? Colors.white : Colors.black, fontSize: 16),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(top: 0, bottom: 13),
          hintText: "",
          hintStyle: TextStyle(
              color: orderIndex != 4 ? Colors.white : Colors.black,
              fontSize: 18),
          suffixIcon: Icon(
            Icons.monetization_on_sharp,
            color: orderIndex != 4 ? Colors.white : Colors.black,
          ),
          border: InputBorder.none,
        ));
  }

  Widget buildAttributeValuesWidget(
      BuildContext context, ProductAttributes attribute) {
    int? i;
    if (attribute != null &&
        order != null &&
        order.orderProductAttributes != null) {
      if (attribute.attributeType == 0) {
        var attr = order.orderProductAttributes!
            .where((at) => at.productAttributeId == attribute.id)
            .first;
        i = order.orderProductAttributes!.indexOf(attr);
      }
    }

    return i != null
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                attribute.name!,
                style: Global.style(
                  size: 18,
                ),
              ),
              SizedBox(height: 8),
              attribute.productAttributeValues!.length > 0 && attribute != null
                  ? ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: attribute.productAttributeValues!.length,
                      itemBuilder: (context, index) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              attribute.productAttributeValues![index].name!,
                              style: Global.style(
                                size: 18,
                              ),
                            ),
                            Theme(
                              data: ThemeData.dark(),
                              child: attribute.attributeType == 1
                                  ? Radio(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      activeColor: Colors.white,
                                      toggleable: true,
                                      groupValue: order
                                          .orderProductAttributes![i!]
                                          .productAttributeValueId,
                                      value: attribute
                                          .productAttributeValues![index].id,
                                      onChanged: (dynamic newValue) {
                                        setState(() {
                                          order.orderProductAttributes![i!]
                                                  .productAttributeValueId =
                                              attribute
                                                  .productAttributeValues![
                                                      index]
                                                  .id;
                                          // topping = newValue;
                                        });
                                      },
                                    )
                                  : Checkbox(
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      activeColor: Colors.white,
                                      value: attribute
                                          .productAttributeValues![index]
                                          .isChecked,
                                      onChanged: (newValue) {
                                        var value;
                                        setState(() {
                                          value = newValue;
                                          var atr = new OrderProductAttributes(
                                              productAttributeId: attribute.id,
                                              productAttributeValueId: attribute
                                                  .productAttributeValues![
                                                      index]
                                                  .id);
                                          if (value == true) {
                                            order.orderProductAttributes!
                                                .add(atr);
                                            attribute
                                                .productAttributeValues![index]
                                                .isChecked = newValue;

                                            print(attribute
                                                .productAttributeValues![index]
                                                .isChecked);
                                            order.orderProductAttributes![i!]
                                                    .productAttributeValueId =
                                                attribute
                                                    .productAttributeValues![
                                                        index]
                                                    .id;
                                          } else {
                                            order.orderProductAttributes!
                                                .remove(atr);
                                            attribute
                                                .productAttributeValues![index]
                                                .isChecked = newValue;
                                            print(attribute
                                                .productAttributeValues![index]
                                                .isChecked);
                                          }
                                          // topping = newValue;
                                        });
                                      },
                                    ),
                            ),
                          ],
                        );
                      },
                    )
                  : Text(""),
              SizedBox(height: 32),
            ],
          )
        : Text("");
  }

  _closeLoader() {
    Timer(Duration(seconds: 0), () {
      setState(() {
        if (order.quantity != null) {
          isBusy = false;
        }
      });
    });
  }

  void leaveReviewDialog() {
    TextEditingController nameController = TextEditingController();
    final product = context.read<ProductsProvider>().products;

    showDialog(
      builder: (BuildContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (_, __) {
              return Container(
                height: 390,
                color: Colors.black,
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
                        'Leave Review',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          MyTextField(
                              hint: 'Your Name',
                              controller: nameController,
                              readOnly: false),
                          SizedBox(height: 24),
                          RatingBar.builder(
                            initialRating: 5,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {
                              _rating = rating;
                            },
                          ),
                          SizedBox(height: 12),
                          MyTextField(
                              hint: 'Review',
                              controller: reviewController,
                              lines: 3,
                              readOnly: false),
                        ],
                      ),
                    ),
                    SizedBox(height: 32),
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
                                CreateReview();
                              },
                              child: Text(
                                'Submit',
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
      context: context,
    );
  }

  getProductDetail(String id, BuildContext ctx) async {
    ctx.read<ProductsProvider>().getProducts(id);
  }

  CreateReview() async {
    var product = context.read<ProductsProvider>().products!;
    //var proId = await ProductService.get(id);
    setState(() {
      isBusy = true;
    });
    try {
      var userId = await SessionService.retrieveUser();
      var rev = {
        'userId': userId,
        'productId': product.id,
        'comment': reviewController.text,
        'rating': _rating
      };
      var signUpRes = await ReviewsService.create(rev);
      if (signUpRes) {
        Text('Registerd SuccessFully');
        setState(() {
          isBusy = false;
        });
      } else {
        setState(() {
          isBusy = false;
        });
      }
    } catch (err) {
      setState(() {
        isBusy = false;
      });
    }
  }

  void showErrorToast() {
    Fluttertoast.showToast(
        msg: 'Something went wrong, please try again later',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  void showErrorToast2(String text) {
    Fluttertoast.showToast(
        msg: text,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  _pressed(liked) async {
    try {
      if (liked) {
        setState(() {
          isBusy = true;
        });
        var user = context.read<BusinessUsersProvider>().userProfile!;
        var prod = context.read<ProductsProvider>().products!;
        var data = {"userId": user.id, "productId": prod.id};
        var like = await LikeService.deleteForMobile(data);
        context.read<ProductsProvider>().getProducts(prod.id);
        context.read<ProductsProvider>().getProductLikeByUser();
        context.read<ProductsProvider>().getSingleProduct(prodId);
        context.read<ReviewsProvider>().getProductReviews(prodId);
        // var userId = await SessionService.retrieveUser();
        // final requests = context.read<ProductsProvider>().products;
      } else {
        setState(() {
          isBusy = true;
        });
        // var userId = await SessionService.retrieveUser();
        // final requests = context.read<ProductsProvider>().products;
        var user = context.read<BusinessUsersProvider>().userProfile!;
        var prod = context.read<ProductsProvider>().products!;
        var data = {"userId": user.id, "productId": prod.id};
        var like = await LikeService.create(data);
        context.read<ProductsProvider>().getProducts(prod.id);
        context.read<ProductsProvider>().getProductLikeByUser();
        context.read<ProductsProvider>().getSingleProduct(prodId);
        context.read<ReviewsProvider>().getProductReviews(prodId);
      }
    } catch (err) {
      setState(() {
        isBusy = false;
      });
    }
  }

  Future<void> CreateProductOrder() async {
    for (var item in order.orderProductAttributes!) {
      if (item.productAttributeValueId == null) {
        var attr = product!.productAttributes!
            .where((element) => element.id == item.productAttributeId)
            .first;
        Fluttertoast.showToast(
            msg: "Please select option from " + attr.name!,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.red,
            textColor: Colors.white);
        return;
      }
    }
    try {
      setState(() {
        isBusy = true;
      });
      //  await NativePayment();
      if (isPaid) {
        print("paid1234");
        order.gst = OrderGst;
        order.tiveleFee = TiveleFee;
        order.totalAmount = GrandTotalAmount;
        var js = order.toJson();
        var res = await OrdersService.create(js);
        if (res != null) {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (_) => ThankYou(ref: res['referenceId']),
            ),
            (_) => false,
          );
        } else {
          showErrorToast();
        }
      }
      setState(() {
        isLoading = false;
      });
    } catch (ex) {
      if (_error.isEmpty) {
        showErrorToast();
      }
      setState(() {
        isPaid = isLoading = false;
      });
    }
    setState(() {
      isLoading = false;
    });
  }

/*
  void NativePayment() async{
    // StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
    //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
    //   setState(() {
    //     _paymentMethod = paymentMethod;
    //     isPaid = true;
    //   });
    // }).catchError(setError);
    // StripePayment.createTokenWithCard(
    //   testCard,
    // ).then((token) {
    //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
    //   setState(() {
    //     _paymentToken = token;
    //     isPaid = true;
    //   });
    // }).catchError(setError);
    //
    await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: GrandtotalAmountText,
        currencyCode: "USD",
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'US',
        currencyCode: 'USD',
        items: [
          ApplePayItem(
            label: "ProductId: "+ order.productId,
            amount: GrandtotalAmountText,
          )
        ],
      ),
    ).then((token){
      setState(() {
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text('Payment Completed')));
        _paymentToken = token;
      });
      setState(() {
        isPaid = true;
      });
    }).catchError(setError);
  }
*/
  void setError(dynamic error) {
    final snackBar = SnackBar(
      content: Text((error as PlatformException).message!.toString()),
    );

    // Find the ScaffoldMessenger in the widget tree
    // and use it to show a SnackBar.
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    // _scaffoldKey.currentState.showSnackBar(SnackBar(
    //     content: Text((error as PlatformException).message!.toString())));

    setState(() {
      _error = error.toString();
      isLoading = false;
      isPaid = false;
    });
  }
}

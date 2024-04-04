import 'dart:async';
import 'dart:convert';

import 'package:better_player/better_player.dart';
import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/controllers/customer/customerLikeController.dart';
import 'package:e_commerce_foods/controllers/customer/orderPlacedController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/Order/SingleOrder.dart';
import 'package:e_commerce_foods/models/customer/getExploreDataModel.dart';
import 'package:e_commerce_foods/models/product/SingleProduct.dart';
import 'package:e_commerce_foods/models/product/products.dart';
import 'package:e_commerce_foods/models/productModel.dart';
import 'package:e_commerce_foods/service/Review/Reviews.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:mime/mime.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:pay/pay.dart' as pay;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'businessProfileFollowPage.dart';
import 'customerLoginPage.dart';

const _paymentItems = [
  pay.PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: pay.PaymentItemStatus.final_price,
  )
];

class CustomerDetailPage extends StatefulWidget {
  @override
  _BusinessDetailPageState createState() => _BusinessDetailPageState();
}

class _BusinessDetailPageState extends State<CustomerDetailPage> {
  Map<String, dynamic>? paymentIntentData;
  // List<ProductDatum> productsData = ProductDatum() as List<ProductDatum> ;
  // ProductDatum namew = ProductDatum();

  int points = 0;
  final CustomerAddLikeController customerAddLikeController =
      Get.put(CustomerAddLikeController());
  final OrderPlacedController orderPlacedController =
      Get.put(OrderPlacedController());
  List<ProductM>? productD = Get.arguments[0];
  int? likes = Get.arguments[1];
  String? rating = Get.arguments[2];
  bool? isLiked = Get.arguments[3];
  ProductDatum? productDetailsDatum = Get.arguments[4];
  bool checkTip = false;
  String? orderTotal;
  double? tipValue = 0.0, totalTemp = 0.0;
  int orderIndex = -1;
  int pointsIndex = -1;
  TextEditingController tipController = TextEditingController();
  TextEditingController controller = TextEditingController();
  TextEditingController reviewController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController deliveryInfoController = TextEditingController();
  //TextEditingController controller = TextEditingController();
  List itemPhotoUrls = [];
  List checkMedia = [];
  int checkPhotoIndex = 0;
  Items? _product;
  double _rating = 1;
  bool isPaid = false;
  bool isBusy = false;
  SingleProduct product = new SingleProduct();
  bool isChecked = false;
  double? TiveleFee;
  double? OrderGst;
  late double ProductAmount;
  double? GrandTotalAmount, OrderTotalAmount;
  bool isLoading = false;
  double? totalBeforeTax;
  String? GrandtotalAmountText;
  String? OrdertotalAmountText = null;
  String? tiveleFeeText;
  String? orderGstText;
  SingleOrder order = new SingleOrder();
  String burger =
      'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg';
  Location location = new Location();
  //Token _paymentToken;
  //PaymentMethod _paymentMethod;
  String? _error;
  final String? _paymentIntentClientSecret = null;
  //PaymentIntentResult _paymentIntent;
  //Source _source;
  ScrollController _controller = ScrollController();
  LocationData? pos = null;
  String? myId;
  String? myName;
  bool showReviews = false;
  String productAddress = "";
  /*final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
  );*/
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  List productAttributesIds = [];
  @override
  void initState() {
    super.initState();
    setState(() {
      isBusy = true;
    });
    initData();
  }

  void initData() async {
/*
    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_51Igno7CVzIpv7T9Kc656wg8BDpPtSFhPtMYScVu4tDJPck5bvIQurnY7hWUvr0RrmivCiEFyNFiBww5kSOK6BiuI00taaojvaH",
        merchantId: "Test",
        androidPayMode: 'test'));
*/
    SharedPreferences prefs = await SharedPreferences.getInstance();
    myId = prefs.getString("user_id");
    myName = prefs.getString("user_name");
    try {
      pos = await location.getLocation();
    } catch (e) {
      showErrorToast2("Error Getting Location");
    }
    order.latitude = pos!.latitude.toString();
    order.longitude = pos!.longitude.toString();
    List<geo.Placemark> placemarks = await geo.placemarkFromCoordinates(
        double.parse(productD![0].productLatitude!),
        double.parse(productD![0].productLongitude!));
    //final coordinates = new Coordinates(double.parse(productD[0].productLatitude), double.parse(productD[0].productLongitude));
    productAddress = globals.addressFromLatLng(placemarks);
    order.userId = productD![0].userId;
    order.productId = productD![0].productId;
    setState(() {
      isBusy = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (OrdertotalAmountText == null) {
      setState(() {
        product.newPrice = productD![0].newPrice;
        product.oldPrice = productD![0].oldPrice;
        order.quantity = 1;
        order.gst = productD![0].gstFee;
        order.tiveleFee = productD![0].tiveleFee;
        order.shippingCost = productD![0].shippingFee;
        ProductAmount = productD![0].newPrice;
        TiveleFee = order.tiveleFee! / 100 * product.newPrice!;
        tiveleFeeText = TiveleFee!.toStringAsFixed(1);
        OrderGst = order.gst! / 100 * product.newPrice!;
        orderGstText = OrderGst!.toStringAsFixed(1);

        GrandTotalAmount =
            order.shippingCost! + product.newPrice! + TiveleFee! + OrderGst!;
        GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);

        OrderTotalAmount =
            order.shippingCost! + product.newPrice! + TiveleFee! + OrderGst!;
        OrdertotalAmountText = OrderTotalAmount!.toStringAsFixed(1);
        totalTemp = GrandTotalAmount;

        product.description = productD![0].description;
        if (productD![0].productImages!.contains(",")) {
          itemPhotoUrls = productD![0].productImages!.split(",");
          for (int i = 0; i < itemPhotoUrls.length; i++) {
            String mimeStr = lookupMimeType(itemPhotoUrls[i])!;
            var fileType = mimeStr.split('/');
            checkMedia.add(fileType[0]);
          }
        } else {
          itemPhotoUrls.add(productD![0].productImages);
          String mimeStr = lookupMimeType(itemPhotoUrls[0])!;
          var fileType = mimeStr.split('/');
          checkMedia.add(fileType[0]);
        }
      });
    }

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
          inAsyncCall: isBusy,
          progressIndicator: globals.circularIndicator(),
          child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InkWell(
                        onTap: () {
                          print("indexxxxxxxxxxxxxxxxxxxxxxxx");

                          if (globals.checkLogin) {
                            showLoginErrorDialog();
                          } else {
                            Get.to(BusinessProfileFollowPage(),
                                arguments: [productDetailsDatum!.businessId]);
                          }
                        },
                        child: Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          child: Text(
                            productDetailsDatum!.businessName!,
                            style: Global.style(
                              size: 18,
                              bold: true,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          productD![0].productName!,
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
                                      height:
                                          MediaQuery.of(context).size.width /
                                                  1.3 -
                                              25,
                                      width: MediaQuery.of(context).size.width,
                                      child: picsListView())
                                  : Image.asset(
                                      "assets/text.png",
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
                                text: "\$ ${productD![0].newPrice}",
                                style: Global.style(
                                  size: 16,
                                  bold: true,
                                ),
                                children: [
                                  TextSpan(
                                    text: "\$ ${productD![0].oldPrice}",
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                      itemPhotoUrls.length,
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
                                                    : checkPhotoIndex == 2 &&
                                                            index == 2
                                                        ? Colors.white
                                                        : Colors.grey,
                                            shape: BoxShape.circle,
                                          )))),
                            )
                          : Container(),
                      SizedBox(height: 8),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05),
                        child: Text(
                          product.description!, ///////HERE IS ACTUAL PAGE
                          style: Global.style(),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                !isLiked!
                                    ? IconButton(
                                        icon: Icon(Icons.favorite_border,
                                            color: Colors.grey),
                                        padding: EdgeInsets.all(1.0),
                                        onPressed: () {
                                          setState(() {
                                            isLiked = !isLiked!;
                                            likes! + 1;
                                            _pressed(productD![0].productId);
                                          });
                                        },
                                      )
                                    : IconButton(
                                        icon: Icon(Icons.favorite,
                                            color: Colors.red),
                                        padding: EdgeInsets.all(1.0),
                                        onPressed: () {
                                          setState(() {
                                            isLiked = !isLiked!;
                                            likes! - 1;
                                            _pressed(productD![0].productId);
                                          });
                                        },
                                      ),
                                SizedBox(width: 8),
                                Text(
                                  "Liked by " + likes.toString() + " people",
                                  style: Global.style(),
                                ),
                              ],
                            ),
                            Container(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  RatingBar.builder(
                                    glowColor: Colors.orange,
                                    unratedColor: Colors.grey,
                                    initialRating: rating == null
                                        ? 5
                                        : double.parse(rating!),
                                    minRating: 1,
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
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Text(
                          "Your Delivery",
                          style: Global.style(
                            size: 13,
                            bold: true,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05),
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                "ASAP",
                                style: Global.style(
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal:
                                MediaQuery.of(context).size.width * 0.05),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_history,
                              color: Colors.white,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                productAddress,
                                textAlign: TextAlign.justify,
                                style: Global.style(
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                        child: Text(
                          "Where should your courier leave your order?",
                          style: Global.style(
                            size: 13,
                            bold: true,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        child: Text(
                          "We are reducing person-to-person contact with contactless delivery. Your courier will leave your order at a location of your choice.",
                          style: Global.style(
                            size: 12,
                          ),
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        child: MyTextField(
                          hint: "Delivery Indtructions",
                          lines: 1,
                          readOnly: false,
                          controller: deliveryInfoController,
                        ),
                      ),
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 3),
                        child: Text(
                          "e.g., leave at door, leave in lobby, leave on porch",
                          style: Global.style(
                            size: 11,
                            bold: true,
                          ),
                        ),
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                    ],
                  ),
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
                        horizontal: MediaQuery.of(context).size.width * 0.05),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ListView.builder(
                        //   physics: NeverScrollableScrollPhysics(),
                        //   shrinkWrap: true,
                        //   itemCount: product.productAttributes.length,
                        //   itemBuilder: (context, index) {
                        //     // return Text("Hello");
                        //     return buildAttributeValuesWidget(
                        //         context, product.productAttributes[index]);
                        //   },
                        // ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Use your points.',
                              style: Global.style(size: 12, bold: true),
                            ),
                            Text(
                              "${points} points",
                              style: Global.style(size: 12, bold: true),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            pointsButton(0),
                            pointsButton(1),
                            pointsButton(2),
                            pointsButton(3),
                          ],
                        ),
                        SizedBox(height: 24),
                        Divider(
                          color: Colors.white,
                        ),
                        Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: Column(
                            children: [
                              Text(
                                'Tip your courier.',
                                style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                              Text(
                                "We never take a cut. 100% of your tip goes to your courier.",
                                textAlign: TextAlign.center,
                                style: Global.style(
                                  size: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            tipButton(0),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            tipButton(1),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            tipButton(2),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            tipButton(3),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.03,
                            ),
                            Container(
                              alignment: Alignment.center,
                              padding: EdgeInsets.only(left: 10, right: 0),
                              //margin: EdgeInsets.only(left: 50, right: 50),
                              width: MediaQuery.of(context).size.width * 0.3,
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
                        Divider(
                          color: Colors.white,
                        ),
                        productDetailsDatum!.productAttributes != []
                            ? addExtraList()
                            : Container(),
                        Divider(
                          color: Colors.white,
                        ),
                        SizedBox(height: 12),
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
                                icon: Icon(Icons.remove, color: Colors.white),
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
                                    ProductAmount -= product.newPrice!;
                                    TiveleFee =
                                        order.tiveleFee! / 100 * ProductAmount;
                                    OrderGst = order.gst! / 100 * ProductAmount;
                                    OrderTotalAmount = order.shippingCost! +
                                        ProductAmount +
                                        TiveleFee! +
                                        OrderGst!;
                                    OrdertotalAmountText =
                                        OrderTotalAmount!.toStringAsFixed(1);
                                    if (tipController.text.isEmpty) {
                                      GrandTotalAmount = order.shippingCost! +
                                          ProductAmount +
                                          TiveleFee! +
                                          OrderGst!;
                                    } else {
                                      GrandTotalAmount = order.shippingCost! +
                                          ProductAmount +
                                          TiveleFee! +
                                          OrderGst! +
                                          double.parse(tipController.text);
                                    }
                                    if (orderIndex == 0) {
                                      tipValue = (5 / 100) * OrderTotalAmount!;
                                      orderTotal =
                                          (OrderTotalAmount! + tipValue!)
                                              .toStringAsFixed(1);
                                      GrandTotalAmount = order.shippingCost! +
                                          ProductAmount +
                                          TiveleFee! +
                                          OrderGst! +
                                          tipValue!;
                                    } else if (orderIndex == 1) {
                                      tipValue = (10 / 100) * OrderTotalAmount!;
                                      orderTotal =
                                          (OrderTotalAmount! + tipValue!)
                                              .toStringAsFixed(1);
                                      GrandTotalAmount = order.shippingCost! +
                                          ProductAmount +
                                          TiveleFee! +
                                          OrderGst! +
                                          tipValue!;
                                    } else if (orderIndex == 2) {
                                      tipValue = (15 / 100) * OrderTotalAmount!;
                                      orderTotal =
                                          (OrderTotalAmount! + tipValue!)
                                              .toStringAsFixed(1);
                                      GrandTotalAmount = order.shippingCost! +
                                          ProductAmount +
                                          TiveleFee! +
                                          OrderGst! +
                                          tipValue!;
                                    } else if (orderIndex == 3) {
                                      tipValue = (20 / 100) * OrderTotalAmount!;
                                      orderTotal =
                                          (OrderTotalAmount! + tipValue!)
                                              .toStringAsFixed(1);
                                      GrandTotalAmount = order.shippingCost! +
                                          ProductAmount +
                                          TiveleFee! +
                                          OrderGst! +
                                          tipValue!;
                                    }
                                    GrandtotalAmountText =
                                        GrandTotalAmount!.toStringAsFixed(1);
                                    orderGstText = OrderGst!.toStringAsFixed(1);
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
                                icon: Icon(Icons.add, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    order.quantity! + 1;
                                    print(order.quantity);
                                    ProductAmount += product.newPrice!;
                                    TiveleFee =
                                        order.tiveleFee! / 100 * ProductAmount;
                                    OrderGst = order.gst! / 100 * ProductAmount;
                                    OrderTotalAmount = order.shippingCost! +
                                        ProductAmount +
                                        TiveleFee! +
                                        OrderGst!;
                                    OrdertotalAmountText =
                                        OrderTotalAmount!.toStringAsFixed(1);
                                    if (tipController.text.isEmpty) {
                                      GrandTotalAmount = order.shippingCost! +
                                          ProductAmount +
                                          TiveleFee! +
                                          OrderGst!;
                                    } else {
                                      GrandTotalAmount = order.shippingCost! +
                                          ProductAmount +
                                          TiveleFee! +
                                          OrderGst! +
                                          double.parse(tipController.text);
                                    }
                                    if (orderIndex == 0) {
                                      tipValue = (5 / 100) * OrderTotalAmount!;
                                      orderTotal =
                                          (OrderTotalAmount! + tipValue!)
                                              .toStringAsFixed(1);
                                      GrandTotalAmount = order.shippingCost! +
                                          ProductAmount +
                                          TiveleFee! +
                                          OrderGst! +
                                          tipValue!;
                                    } else if (orderIndex == 1) {
                                      tipValue = (10 / 100) * OrderTotalAmount!;
                                      orderTotal =
                                          (OrderTotalAmount! + tipValue!)
                                              .toStringAsFixed(1);
                                      GrandTotalAmount = order.shippingCost! +
                                          ProductAmount +
                                          TiveleFee! +
                                          OrderGst! +
                                          tipValue!;
                                    } else if (orderIndex == 2) {
                                      tipValue = (15 / 100) * OrderTotalAmount!;
                                      orderTotal =
                                          (OrderTotalAmount! + tipValue!)
                                              .toStringAsFixed(1);
                                      GrandTotalAmount = order.shippingCost! +
                                          ProductAmount +
                                          TiveleFee! +
                                          OrderGst! +
                                          tipValue!;
                                    } else if (orderIndex == 3) {
                                      tipValue = (20 / 100) * OrderTotalAmount!;
                                      orderTotal =
                                          (OrderTotalAmount! + tipValue!)
                                              .toStringAsFixed(1);
                                      GrandTotalAmount = order.shippingCost! +
                                          ProductAmount +
                                          TiveleFee! +
                                          OrderGst! +
                                          tipValue!;
                                    }
                                    GrandtotalAmountText =
                                        GrandTotalAmount!.toStringAsFixed(1);
                                    orderGstText = OrderGst!.toStringAsFixed(1);
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Shipping & Handling Delivery',
                              style: Global.style(
                                size: 12,
                              ),
                            ),
                            Text(
                              "\$ ${order.shippingCost}",
                              style: Global.style(
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Before Tax',
                              style: Global.style(
                                size: 12,
                              ),
                            ),
                            Text(
                              //'\$5.99',
                              // ProductAmount!=null?
                              // "\$ ${ProductAmount}":
                              "\$ ${ProductAmount}",
                              // (totalBeforeTax).toString(),
                              style: Global.style(
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tivele Fee',
                              style: Global.style(
                                size: 12,
                              ),
                            ),
                            Text(
                              TiveleFee == null ? "\$ " : "\$ $tiveleFeeText",
                              style: Global.style(
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Estimated GST/HST',
                              style: Global.style(
                                size: 12,
                              ),
                            ),
                            Text(
                              OrderGst == null ? "\$ " : "\$ $orderGstText",
                              style: Global.style(
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ORDER TOTAL',
                              style: Global.style(
                                size: 12,
                              ),
                            ),
                            Text(
                              "\$ $OrdertotalAmountText",
                              //'\$23.99',
                              style: Global.style(
                                size: 12,
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tip',
                              style: Global.style(
                                size: 12,
                              ),
                            ),
                            Text(
                              "\$ " + tipValue!.toStringAsFixed(1),
                              //'\$23.99',
                              style: Global.style(
                                size: 12,
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Grand TOTAL',
                              style: Global.style(
                                size: 14,
                              ),
                            ),
                            Text(
                              "\$ $GrandtotalAmountText",
                              //'\$23.99',
                              style: Global.style(
                                size: 14,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: Colors.white,
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal:
                                  MediaQuery.of(context).size.width * 0.05),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    showReviews = !showReviews;
                                  });
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      !showReviews
                                          ? 'Show Reviews'
                                          : 'Hide Reviews',
                                      style: Global.style(size: 16, bold: true),
                                    ),
                                    Icon(
                                      !showReviews
                                          ? Icons.arrow_drop_up
                                          : Icons.arrow_drop_down_sharp,
                                      color: Colors.white,
                                      size: 25,
                                    )
                                  ],
                                ),
                              ),
                              // InkWell(
                              //   onTap: (){
                              //     leaveReviewDialog();
                              //   },
                              //   child: Text(
                              //     "Leave a Review",
                              //     style: Global.style(
                              //       size: 16,
                              //     ),
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: showReviews,
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
                                            Global.defaultUserPic,
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
                                                      "Ali",
                                                      style: Global.style(
                                                        size: 14,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Container(
                                                      child: Row(
                                                        children: [
                                                          RatingBar.builder(
                                                            initialRating: 2,
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
                                                  "Good Product",
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
                                itemCount: 3,
                              ),
                            ],
                          ),
                        ),
                        Divider(
                          indent: MediaQuery.of(context).size.width * 0.05,
                          endIndent: MediaQuery.of(context).size.width * 0.05,
                          color: Colors.white,
                          thickness: 3,
                        ),
                        SizedBox(height: 24), //kashif
                        // !checkTip && Platform.isAndroid
                        //     ? Align(
                        //         alignment: Alignment.center,
                        //         child: pay.GooglePayButton(
                        //           height: 50,
                        //           width: double.infinity,
                        //           paymentConfigurationAsset:
                        //               'google_pay_payment_profile.json',
                        //           paymentItems: [
                        //             pay.PaymentItem(
                        //               label: 'Total',
                        //               amount: double.parse(GrandtotalAmountText!)
                        //                   .ceilToDouble()
                        //                   .toInt()
                        //                   .toString(),
                        //               status: pay.PaymentItemStatus.final_price,
                        //             )
                        //           ],
                        //           margin: const EdgeInsets.only(top: 15),
                        //           onPaymentResult: onGooglePayResult,
                        //           // style: GooglePayButtonStyle.white,
                        //           loadingIndicator: const Center(
                        //             child: CircularProgressIndicator(),
                        //           ),
                        //           onPressed: () async {
                        //             // 1. Add your stripe publishable key to assets/google_pay_payment_profile.json
                        //             // await debugChangedStripePublishableKey();
                        //             Map<String, Object?> userData = {
                        //               'business_id': productD![0].userId,
                        //               'product_id': productD![0].productId,
                        //               'product_gst':
                        //                   OrderGst!.toStringAsFixed(2),
                        //               'product_tivele_fee':
                        //                   TiveleFee!.toStringAsFixed(2),
                        //               'product_shipping_cost':
                        //                   order.shippingCost.toString(),
                        //               'product_total_amount':
                        //                   GrandtotalAmountText,
                        //               'product_quantity':
                        //                   order.quantity.toString(),
                        //               'user_latitude': pos!.latitude.toString(),
                        //               'user_longitude':
                        //                   pos!.longitude.toString(),
                        //               'tip': tipValue.toString(),
                        //               'product_attributes':
                        //                   jsonEncode(productAttributesIds)
                        //             };

                        //             orderPlacedController
                        //                 .fetchOrderPlaced(userData);
                        //           },
                        //           onError: (e) {
                        //             ScaffoldMessenger.of(context).showSnackBar(
                        //               const SnackBar(
                        //                 content: Text(
                        //                     'There was an error while trying to perform the payment'),
                        //               ),
                        //             );
                        //           },
                        //         ),
                        //       )
                        //     : !checkTip &&
                        //             Platform.isIOS &&
                        //             Stripe.instance.isApplePaySupported.value
                        //         ? pay.ApplePayButton(
                        //             paymentConfigurationAsset:
                        //                 'apple_pay_payment_profile.json',
                        //             paymentItems: [
                        //               pay.PaymentItem(
                        //                 label: 'Total',
                        //                 amount:
                        //                     double.parse(GrandtotalAmountText!)
                        //                         .ceilToDouble()
                        //                         .toInt()
                        //                         .toString(),
                        //                 status:
                        //                     pay.PaymentItemStatus.final_price,
                        //               )
                        //             ],
                        //             margin: const EdgeInsets.only(top: 15),
                        //             onPaymentResult: onApplePayResult,
                        //             style: pay.ApplePayButtonStyle.white,
                        //             type: pay.ApplePayButtonType.buy,
                        //             loadingIndicator: const Center(
                        //               child: CircularProgressIndicator(),
                        //             ),
                        //             childOnError: Text(
                        //                 'Apple Pay is not available in this device'),
                        //             onError: (e) {
                        //               ScaffoldMessenger.of(context)
                        //                   .showSnackBar(
                        //                 const SnackBar(
                        //                   content: Text(
                        //                     'There was an error while trying to perform the payment',
                        //                     style:
                        //                         TextStyle(color: Colors.white),
                        //                   ),
                        //                 ),
                        //               );
                        //             },
                        //           )
                        //         : !checkTip &&
                        //                 Platform.isIOS &&
                        //                 !Stripe
                        //                     .instance.isApplePaySupported.value
                        //             ? Padding(
                        //                 padding: EdgeInsets.symmetric(
                        //                     horizontal: 16),
                        //                 child: Text(
                        //                   'Apple Pay is not available in this device',
                        //                   style: TextStyle(color: Colors.white),
                        //                 ),
                        //               )
                        //             : Align(
                        //                 alignment: Alignment.center,
                        //                 child: ConfirmationSlider(
                        //                   onConfirmation: () {
                        //                     if (!checkTip) {
                        //                       CreateProductOrder();
                        //                     } else {
                        //                       showErrorToast2(
                        //                           "Invalid Tip value!");
                        //                     }
                        //                     /*Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (_) => ThankYou(),
                        //   ),
                        // );*/
                        //                   },
                        //                   backgroundColor: Colors.white,
                        //                   foregroundColor: Colors.black,
                        //                   textStyle: Global.style(
                        //                     color: Colors.black,
                        //                     size: 16,
                        //                   ),
                        //                   text: 'Swipe to Pay',
                        //                   height: 50,
                        //                 ),
                        //               ),
                        SizedBox(height: 24),
                      ],
                    ),
                  ),
                ],
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
      itemCount: itemPhotoUrls.length,
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

  Widget tipButton(int index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.12,
      height: 40,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
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
                ProductAmount = order.quantity! * product.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount;
                OrderGst = order.gst! / 100 * ProductAmount;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount +
                    TiveleFee! +
                    OrderGst! +
                    tipValue!;
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              });
            } else {
              setState(() {
                tipValue = 0;
                orderIndex = -1;
                ProductAmount = order.quantity! * product.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount;
                OrderGst = order.gst! / 100 * ProductAmount;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount +
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
                ProductAmount = order.quantity! * product.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount;
                OrderGst = order.gst! / 100 * ProductAmount;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount +
                    TiveleFee! +
                    OrderGst! +
                    tipValue!;
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              });
            } else {
              setState(() {
                tipValue = 0;
                orderIndex = -1;
                ProductAmount = order.quantity! * product.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount;
                OrderGst = order.gst! / 100 * ProductAmount;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount +
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
                ProductAmount = order.quantity! * product.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount;
                OrderGst = order.gst! / 100 * ProductAmount;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount +
                    TiveleFee! +
                    OrderGst! +
                    tipValue!;
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              });
            } else {
              setState(() {
                tipValue = 0;
                orderIndex = -1;
                ProductAmount = order.quantity! * product.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount;
                OrderGst = order.gst! / 100 * ProductAmount;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount +
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
                ProductAmount = order.quantity! * product.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount;
                OrderGst = order.gst! / 100 * ProductAmount;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount +
                    TiveleFee! +
                    OrderGst! +
                    tipValue!;
                GrandtotalAmountText = GrandTotalAmount!.toStringAsFixed(1);
              });
            } else {
              setState(() {
                tipValue = 0;
                orderIndex = -1;
                ProductAmount = order.quantity! * product.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount;
                OrderGst = order.gst! / 100 * ProductAmount;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount +
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

  Widget addExtraList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: productDetailsDatum!.productAttributes!.length,
      itemBuilder: (context, index) =>
          extraListGet(index, productDetailsDatum!.productAttributes![index]),
    );
  }

  List<AttributeValue> selectedProductAttributes = [];
  Widget extraListGet(int index, ProductAttribute productAttribute) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${productAttribute.attributeName}',
          style: Global.style(size: 16, bold: true),
        ),
        ListView.builder(
          padding: EdgeInsets.only(top: 10),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: productAttribute.attributeValues!.length,
          itemBuilder: (context, index) => Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${productAttribute.attributeValues![index].productAttributeOption}',
                    style: Global.style(
                      size: 14,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (selectedProductAttributes.any((attribute) =>
                            attribute.productAttributeId ==
                            productAttribute
                                .attributeValues![index].productAttributeId)) {
                          if (selectedProductAttributes.any((attribute) =>
                              attribute.id ==
                              productAttribute.attributeValues![index].id)) {
                            selectedProductAttributes.removeWhere((attribute) =>
                                attribute.id ==
                                productAttribute.attributeValues![index].id);
                          } else {
                            int indexValue = selectedProductAttributes
                                .indexWhere((attribute) =>
                                    attribute.productAttributeId ==
                                    productAttribute.attributeValues![index]
                                        .productAttributeId);
                            selectedProductAttributes.removeAt(indexValue);
                            selectedProductAttributes
                                .add(productAttribute.attributeValues![index]);
                          }
                        } else {
                          selectedProductAttributes
                              .add(productAttribute.attributeValues![index]);
                        }
                      });
                      if (selectedProductAttributes.isNotEmpty) {
                        productAttributesIds.clear();
                        for (var val in selectedProductAttributes) {
                          productAttributesIds.add(val.id);
                        }
                      } else {
                        productAttributesIds.clear();
                      }
                      productAttributesIds.sort();
                      print(jsonEncode(productAttributesIds));
                    },
                    child: Container(
                      height: 20,
                      width: 20,
                      padding: EdgeInsets.all(3),
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white)),
                      child: selectedProductAttributes.any((attribute) =>
                              attribute.id ==
                              productAttribute.attributeValues![index].id)
                          ? Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            )
                          : Container(),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget pointsButton(int index) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.22,
      height: 60,
      child: MaterialButton(
        padding: EdgeInsets.all(0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
            side: BorderSide(color: Colors.white, width: 1)),
        textColor: pointsIndex == 0 && index == 0
            ? Colors.black
            : pointsIndex == 1 && index == 1
                ? Colors.black
                : pointsIndex == 2 && index == 2
                    ? Colors.black
                    : pointsIndex == 3 && index == 3
                        ? Colors.black
                        : Colors.white,
        splashColor: pointsIndex == 0 && index == 0
            ? Colors.black
            : pointsIndex == 1 && index == 1
                ? Colors.black
                : pointsIndex == 2 && index == 2
                    ? Colors.black
                    : pointsIndex == 3 && index == 3
                        ? Colors.black
                        : Colors.white,
        color: pointsIndex == 0 && index == 0
            ? Colors.white
            : pointsIndex == 1 && index == 1
                ? Colors.white
                : pointsIndex == 2 && index == 2
                    ? Colors.white
                    : pointsIndex == 3 && index == 3
                        ? Colors.white
                        : Colors.black,
        onPressed: () {
          if (index == 0) {
            if (points >= 2500) {
              if (pointsIndex != 0) {
                setState(() {
                  pointsIndex = 0;
                });
              } else {
                setState(() {
                  pointsIndex = -1;
                });
              }
            } else {
              globals.showErrorToast("You don't have specific points!");
            }
          } else if (index == 1) {
            if (points >= 5000) {
              if (pointsIndex != 1) {
                setState(() {
                  pointsIndex = 1;
                });
              } else {
                setState(() {
                  pointsIndex = -1;
                });
              }
            } else {
              globals.showErrorToast("You don't have specific points!");
            }
          } else if (index == 2) {
            if (points >= 10000) {
              if (pointsIndex != 2) {
                setState(() {
                  pointsIndex = 2;
                });
              } else {
                setState(() {
                  pointsIndex = -1;
                });
              }
            } else {
              globals.showErrorToast("You don't have specific points!");
            }
          } else if (index == 3) {
            if (points >= 15000) {
              if (pointsIndex != 3) {
                setState(() {
                  pointsIndex = 3;
                });
              } else {
                setState(() {
                  pointsIndex = -1;
                });
              }
            } else {
              globals.showErrorToast("You don't have specific points!");
            }
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              index == 0
                  ? "\$ 2.50"
                  : index == 1
                      ? "\$ 5"
                      : index == 2
                          ? "\$ 10"
                          : "\$ 15",
              style: TextStyle(
                  color: pointsIndex == 0 && index == 0
                      ? Colors.black
                      : pointsIndex == 1 && index == 1
                          ? Colors.black
                          : pointsIndex == 2 && index == 2
                              ? Colors.black
                              : pointsIndex == 3 && index == 3
                                  ? Colors.black
                                  : Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 3,
            ),
            Text(
              index == 0
                  ? "2500 points"
                  : index == 1
                      ? "5000 points"
                      : index == 2
                          ? "1000 points"
                          : "15000 points",
              style: TextStyle(
                  color: pointsIndex == 0 && index == 0
                      ? Colors.black
                      : pointsIndex == 1 && index == 1
                          ? Colors.black
                          : pointsIndex == 2 && index == 2
                              ? Colors.black
                              : pointsIndex == 3 && index == 3
                                  ? Colors.black
                                  : Colors.white,
                  fontSize: 8),
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
              ProductAmount = order.quantity! * product.newPrice!;
              TiveleFee = order.tiveleFee! / 100 * ProductAmount;
              OrderGst = order.gst! / 100 * ProductAmount;
              GrandTotalAmount =
                  order.shippingCost! + ProductAmount + TiveleFee! + OrderGst!;
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
                ProductAmount = order.quantity! * product.newPrice!;
                TiveleFee = order.tiveleFee! / 100 * ProductAmount;
                OrderGst = order.gst! / 100 * ProductAmount;
                GrandTotalAmount = order.shippingCost! +
                    ProductAmount +
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
              ProductAmount = order.quantity! * product.newPrice!;
              TiveleFee = order.tiveleFee! / 100 * ProductAmount;
              OrderGst = order.gst! / 100 * ProductAmount;
              GrandTotalAmount =
                  order.shippingCost! + ProductAmount + TiveleFee! + OrderGst!;
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
    showAnimatedDialog(
      animationType: DialogTransitionType.sizeFade,
      curve: Curves.easeInCirc,
      duration: Duration(seconds: 1),
      builder: (BuildContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (_, __) {
              return Container(
                height: 390,
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
                          Text(
                            myName!,
                            textAlign: TextAlign.center,
                            style: Global.style(
                              size: 20,
                              bold: true,
                              caps: true,
                            ),
                          ),
                          SizedBox(height: 20),
                          RatingBar.builder(
                            initialRating: 1,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            unratedColor: Colors.grey,
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
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: Global.style(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
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
                                //CreateReview();
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

  _pressed(String? productId) async {
    Map userData = {
      'product_id': productId,
    };
    await customerAddLikeController.fetchAddLike(userData);
    if (customerAddLikeController.addLikeINfo.value.status == 200) {
      print(customerAddLikeController.addLikeINfo.value.data);
    } else {}
  }

  CreateProductOrder() async {
    // for (var item in order.orderProductAttributes) {
    //   if (item.productAttributeValueId==null) {
    //     var attr = product.productAttributes
    //         .where((element) => element.id == item.productAttributeId)
    //         .first;
    //     Fluttertoast.showToast(
    //         msg: "Please select option from " + attr.name,
    //         toastLength: Toast.LENGTH_SHORT,
    //         gravity: ToastGravity.BOTTOM,
    //         backgroundColor: Colors.red,
    //         textColor: Colors.white
    //     );
    //     return;
    //   }
    // }
    try {
      setState(() {
        isBusy = true;
      });
      //await NativePayment();
      if (isPaid) {
        //isPaid
        pos = await location.getLocation();
        Map<String, Object?> userData = {
          'business_id': productD![0].userId,
          'product_id': productD![0].productId,
          'product_gst': OrderGst!.toStringAsFixed(2),
          'product_tivele_fee': TiveleFee!.toStringAsFixed(2),
          'product_shipping_cost': order.shippingCost.toString(),
          'product_total_amount': GrandtotalAmountText,
          'product_quantity': order.quantity.toString(),
          'user_latitude': pos!.latitude.toString(),
          'user_longitude': pos!.longitude.toString(),
          'tip': tipValue.toString(),
          'product_attributes': jsonEncode(productAttributesIds)
        };
        await orderPlacedController.fetchOrderPlaced(userData);
      }
      setState(() {
        isBusy = false;
      });
    } catch (ex) {
      print(ex.toString() + " errrrro");
      // if (_error.isEmpty) {
      //   setState(() {
      //     isBusy = false;
      //   });
      // }
      setState(() {
        isPaid = isLoading = false;
        isBusy = false;
      });
    }
    setState(() {
      isLoading = false;
      isBusy = false;
    });
  }

/*
  void NativePayment() async {
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
            label: "ProductId: " + order.productId,
            amount: GrandtotalAmountText,
          )
        ],
      ),
    ).then((token) {
      setState(() {
        _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Payment Completed')));
        _paymentToken = token;
        isPaid = true;
      });
    }).catchError(setError);
  }
*/

  void setError(dynamic error) {
    final snackBar = SnackBar(
      content: Text(
          error is PlatformException ? error.message! : 'An error occurred'),
    );

    // Show the SnackBar using the ScaffoldMessenger
    ScaffoldMessenger.of(context).showSnackBar(snackBar);

    setState(() {
      _error = error.toString();
      isLoading = false;
      isPaid = false;
    });
  }

  Future<void> onGooglePayResult(paymentResult) async {
    // try {
    //   // 1. Add your stripe publishable key to assets/google_pay_payment_profile.json
    //   print("result");
    //   debugPrint(paymentResult.toString());
    //   // 2. fetch Intent Client Secret from backend
    //   final response = await fetchPaymentIntentClientSecret();
    //   //  paymentIntentData=json.decode(response.body);
    //   print("response:" + response.toString());
    //   final clientSecret = response['paymentIntent'];
    //   final token =
    //       paymentResult['paymentMethodData']['tokenizationData']['token'];
    //   final tokenJson = Map.castFrom(json.decode(token));
    //   print(tokenJson);

    //   final params = PaymentMethodParams.cardFromToken(
    //     token: tokenJson['id'], // TODO extract the actual token
    //   );

    //   // 3. Confirm Google pay payment method
    //   await Stripe.instance.confirmPayment(
    //     clientSecret,
    //     params,
    //   );
    //   setState(() {
    //     isPaid = true;
    //     isBusy = false;
    //     CreateProductOrder();
    //   });
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('Your payment succesfully completed')),
    //   );
    // } catch (e) {
    //   print("error");
    //   print(e);
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(
    //         content: Text('Your payment not submitted!\nPlease try sgain.')),
    //   );
    // }
  }

  Future<Map<String, dynamic>?> fetchPaymentIntentClientSecret() async {
    final url = Uri.parse(
        "https://us-central1-tivele-25c51.cloudfunctions.net/stripePayment");
//    final response = await http.post(url);
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        "currency": "cad",
        'description': "Tivile payment",
        'amount': double.parse(GrandtotalAmountText!).ceilToDouble().toInt()
      }),
    );
    return json.decode(response.body);
  }

  Future<void> debugChangedStripePublishableKey() async {
    if (kDebugMode) {
      final profile =
          await rootBundle.loadString('assets/google_pay_payment_profile.json');
      final isValidKey =
          !profile.contains('pk_live_3ayggMnNp5g9v2tJdRbPA5sO00UlZ9bk9L');
      assert(
        isValidKey,
        'No stripe publishable key added to assets/google_pay_payment_profile.json',
      );
    }
  }

  Future<void> onApplePayResult(paymentResult) async {
    // try {
    //   //debugPrint(paymentResult.toString());
    //   // 1. Get Stripe token from payment result
    //   final token = await Stripe.instance.createToken(paymentResult);
    //   // 2. fetch Intent Client Secret from backend
    //   final response = await fetchPaymentIntentClientSecret();
    //   final clientSecret = response['paymentIntent'];

    //   final params = PaymentMethodParams.cardFromToken(token: token.id);

    //   // 3. Confirm Google pay payment method
    //   await Stripe.instance.confirmPayment(clientSecret, params);

    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(
    //         content: Text('Apple Pay payment successfully completed')),
    //   );
    // } catch (e) {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('Error: $e')),
    //   );
    // }
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

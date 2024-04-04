import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/Order/SingleOrder.dart';
import 'package:e_commerce_foods/models/Rules/Rule.dart';
import 'package:e_commerce_foods/models/product/SingleProduct.dart';
import 'package:e_commerce_foods/service/Rules/Rules.dart';
import 'package:e_commerce_foods/service/order/orders_service.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/thank_you.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class OrderConfirmation extends StatefulWidget {
  final SingleProduct prod;
  OrderConfirmation({Key? key, required this.prod}) : super(key: key);
  @override
  _OrderConfirmationState createState() => _OrderConfirmationState(prod);
}

class _OrderConfirmationState extends State<OrderConfirmation> {
  SingleProduct product;
  bool isChecked = false;
  _OrderConfirmationState(this.product);

  TextEditingController controller = TextEditingController();

  bool isLoading = true;
  double? totalBeforeTax;
  SingleOrder order = new SingleOrder();
  //Token _paymentToken;
  //PaymentMethod _paymentMethod;
  String? _error;

  //this client secret is typically created by a backend system
  //check https://stripe.com/docs/payments/payment-intents#passing-to-client
  final String? _paymentIntentClientSecret = null;

  //PaymentIntentResult _paymentIntent;
  //Source _source;

  ScrollController _controller = ScrollController();

/*
  final CreditCard testCard = CreditCard(
    number: '4000002760003184',
    expMonth: 12,
    expYear: 21,
  );
*/
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  void showErrorToast() {
    Fluttertoast.showToast(
        msg: 'Something went wrong, please try again later',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() async {
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
      totalBeforeTax =
          product.newPrice! + order.shippingCost! + order.tiveleFee!;
      order.totalAmount = product.newPrice! +
          order.gst! +
          order.shippingCost! +
          order.tiveleFee!;
      order.userId = myId;
      order.productId = product.id;
      order.latitude = pos.latitude.toString();
      order.longitude = pos.longitude.toString();
      order.orderProductAttributes = [];
      for (var item in product.productAttributes!) {
        if (item.attributeType == 0) {
          OrderProductAttributes attr = new OrderProductAttributes();
          attr.productAttributeId = item.id;
          order.orderProductAttributes!.add(attr);
        }
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = context.watch<ProductsProvider>().singleProduct;
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
          body: !isLoading
              ? Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: product!.productAttributes!.length,
                          itemBuilder: (context, index) {
                            // return Text("Hello");
                            return buildAttributeValuesWidget(
                                context, product.productAttributes![index]);
                          },
                        ),
                        Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    totalBeforeTax =
                                        (product.newPrice! * order.quantity!) +
                                            order.tiveleFee! +
                                            order.shippingCost!;
                                    order.totalAmount =
                                        (product.newPrice! * order.quantity!) +
                                            order.tiveleFee! +
                                            order.shippingCost! +
                                            order.gst!;
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
                                    totalBeforeTax =
                                        (product.newPrice! * order.quantity!) +
                                            order.tiveleFee! +
                                            order.shippingCost!;
                                    order.totalAmount =
                                        (product.newPrice! * order.quantity!) +
                                            order.tiveleFee! +
                                            order.shippingCost! +
                                            order.gst!;
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Before Tax',
                              style: Global.style(
                                size: 16,
                              ),
                            ),
                            Text(
                              //'\$5.99',
                              (totalBeforeTax).toString(),
                              style: Global.style(
                                size: 16,
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
                                size: 16,
                              ),
                            ),
                            Text(
                              "\$ ${order.tiveleFee}",
                              style: Global.style(
                                size: 16,
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
                                size: 16,
                              ),
                            ),
                            Text(
                              "\$ ${order.gst}",
                              style: Global.style(
                                size: 16,
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
                                size: 16,
                              ),
                            ),
                            Text(
                              "\$ ${order.totalAmount}",
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
                              //NativePayment();
                              // PaymentWithToken();
                              // StripeGateway();
                              // CreateProductOrder();
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
                )
              : Center(
                  child: CircularProgressIndicator(
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )),
    );
  }

  Widget buildAttributeValuesWidget(
      BuildContext context, ProductAttributes attribute) {
    late int i;
    if (attribute.attributeType == 0) {
      var attr = order.orderProductAttributes!
          .where((at) => at.productAttributeId == attribute.id)
          .first;
      i = order.orderProductAttributes!.indexOf(attr);
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          attribute.name!,
          style: Global.style(
            size: 18,
          ),
        ),
        SizedBox(height: 8),
        ListView.builder(
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
                  child: attribute.attributeType == 0
                      ? Radio(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: Colors.white,
                          toggleable: true,
                          groupValue: order.orderProductAttributes![i]
                              .productAttributeValueId,
                          value: attribute.productAttributeValues![index].id,
                          onChanged: (dynamic newValue) {
                            setState(() {
                              order.orderProductAttributes![i]
                                      .productAttributeValueId =
                                  attribute.productAttributeValues![index].id;
                              // topping = newValue;
                            });
                          },
                        )
                      : Checkbox(
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                          activeColor: Colors.white,
                          value: attribute
                              .productAttributeValues![index].isChecked,
                          onChanged: (newValue) {
                            setState(() {
                              var atr = new OrderProductAttributes(
                                  productAttributeId: attribute.id,
                                  productAttributeValueId: attribute
                                      .productAttributeValues![index].id);
                              if (newValue!) {
                                order.orderProductAttributes!.add(atr);
                                attribute.productAttributeValues![index]
                                    .isChecked = newValue;
                              } else {
                                order.orderProductAttributes!.remove(atr);
                                attribute.productAttributeValues![index]
                                    .isChecked = newValue;
                              }
                              // topping = newValue;
                            });
                          },
                        ),
                ),
              ],
            );
          },
        ),
        SizedBox(height: 32),
      ],
    );
  }

/*
  void TokenWithCardForm(){
    StripePayment.createSourceWithParams(SourceParams(
      type: 'ideal',
      amount: 2102,
      currency: 'USD',
      returnURL: 'example://stripe-redirect',
    )).then((source) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${source.sourceId}')));
      setState(() {
        _source = source;
      });
    }).catchError(setError);

    // StripePayment.createTokenWithCard(
    //   testCard,
    // ).then((token) {
    //   _scaffoldKey.currentState.showSnackBar(
    //       SnackBar(content: Text('Received ${token.tokenId}')));
    //   setState(() {
    //     _paymentToken = token;
    //   });
    //   PaymentWithToken();
    // }).catchError(setError);
  }
  void PaymentWithToken(){
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest()).then((paymentMethod) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${paymentMethod.id}')));
      setState(() {
        _paymentMethod = paymentMethod;
      });
      StripePayment.confirmPaymentIntent(
        PaymentIntent(
          clientSecret: "sk_test_51Igno7CVzIpv7T9KlpB2QnXKEGQfw0fAkm6018fNaIQk9HwnXwrkCfPBhGcn0BB5gX0UyNdo0DCYjmnmc21kKxuo00YBfvsw0v",
          paymentMethodId: _paymentMethod.id,
        ),
      ).then((paymentIntent) {
        _scaffoldKey.currentState
            .showSnackBar(SnackBar(content: Text('Received ${paymentIntent.paymentIntentId}')));
        setState(() {
          _paymentIntent = paymentIntent;
        });
      }).catchError(setError);
    }).catchError(setError);

    // StripePayment. createPaymentMethod(
    //   PaymentMethodRequest(
    //     card: CreditCard(
    //       token: _paymentToken.tokenId,
    //     ),
    //   ),
    // ).then((paymentMethod) {
    //   _scaffoldKey.currentState.showSnackBar(SnackBar(
    //       content: Text('Received ${paymentMethod.id}')));
    //   setState(() {
    //     _paymentMethod = paymentMethod;
    //   });
    // }).catchError(setError);
  }
  void StripeGateway() async {

    StripePayment.completeNativePayRequest().then((_) {
      _scaffoldKey.currentState.showSnackBar(
          SnackBar(content: Text('Completed successfully')));
    }).catchError(setError);
  }
  void NativePayment() async{
    await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: order.totalAmount.toString(),
        currencyCode: "USD",
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'US',
        currencyCode: 'USD',
        items: [
          ApplePayItem(
            label: "ProductId: "+order.productId,
            amount: order.totalAmount.toString(),
          )

        ],
      ),
    ).then((token) async{
      setState(() {
        _scaffoldKey.currentState.showSnackBar(
            SnackBar(content: Text('Payment Completed')));
        _paymentToken = token;
      });
      await CreateProductOrder();
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
    });
  }

  Future<void> CreateProductOrder() async {
    for (var item in order.orderProductAttributes!) {
      if (item.productAttributeValueId == null) {
        var attr = product.productAttributes!
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
        isLoading = true;
      });
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
      setState(() {
        isLoading = false;
      });
    } catch (ex) {
      showErrorToast();
      setState(() {
        isLoading = false;
      });
    }
  }
}

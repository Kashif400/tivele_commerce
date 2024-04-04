import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:stripe_platform_interface/stripe_platform_interface.dart';

class ApplePayScreen extends StatefulWidget {
  @override
  _ApplePayScreenState createState() => _ApplePayScreenState();
}

class _ApplePayScreenState extends State<ApplePayScreen> {
  @override
  void initState() {
    //kashif
    // Stripe.instance.isApplePaySupported.addListener(update);
    super.initState();
  }

  @override
  void dispose() {
    //kashif
    // Stripe.instance.isApplePaySupported.removeListener(update);
    super.dispose();
  }

  void update() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          //kashif
          // if (Stripe.instance.isApplePaySupported.value)
          //   Padding(
          //     padding: EdgeInsets.all(16),
          //     child: ApplePayButton(
          //       onPressed: _handlePayPress,
          //     ),
          //   )
          // else
          //   Padding(
          //     padding: EdgeInsets.symmetric(horizontal: 16),
          //     child: Text('Apple Pay is not available in this device'),
          //   ),
        ],
      ),
    );
  }

  Future<void> _handlePayPress() async {
    try {
      print("start");
      // 1. Present Apple Pay sheet
      // await Stripe.instance.presentApplePay(
      //    ApplePayPresentParams(
      //     cartItems: [
      //       ApplePayCartSummaryItem(
      //         label: 'Product Test',
      //         amount: '300',
      //       ),
      //     ],
      //     country: 'US',
      //     currency: 'usd',
      //   ),
      // ).onError((error, stackTrace) {
      //   print("error");
      //   print(error.toString());
      // }).then((value) {
      //   print("value");
      // });

      print("here");
      // 2. fetch Intent Client Secret from backend
      final response = await (fetchPaymentIntentClientSecret()
          as FutureOr<Map<String, dynamic>>);
      final clientSecret = response['paymentIntent'];

      // 2. Confirm apple pay payment
      //kashif
      // await Stripe.instance.confirmApplePayPayment(clientSecret);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Apple Pay payment succesfully completed')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
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
        'name': "Hamza",
        'email': "hamza@gmail.com",
        "currency": "cad",
        'description': "Tivile payment",
        'amount': 300
      }),
    );
    return json.decode(response.body);
  }
}

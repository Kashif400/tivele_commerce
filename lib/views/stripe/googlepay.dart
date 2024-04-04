import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:stripe_platform_interface/stripe_platform_interface.dart';
import 'package:pay/pay.dart' as pay;

const _paymentItems = [
  pay.PaymentItem(
    label: 'Total',
    amount: '99.99',
    status: pay.PaymentItemStatus.final_price,
  )
];

class GooglePayScreen extends StatefulWidget {
  @override
  _GooglePayScreenState createState() => _GooglePayScreenState();
}

class _GooglePayScreenState extends State<GooglePayScreen> {
  Map<String, dynamic>? paymentIntentData;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
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
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //kashifs
          // Padding(
          //   padding: const EdgeInsets.all(16),
          //   child: pay.GooglePayButton(
          //     paymentConfigurationAsset: 'google_pay_payment_profile.json',
          //     paymentItems: _paymentItems,
          //     margin: const EdgeInsets.only(top: 15),
          //     onPaymentResult: onGooglePayResult,
          //     loadingIndicator: const Center(
          //       child: CircularProgressIndicator(),
          //     ),
          //     onPressed: () async {
          //       // 1. Add your stripe publishable key to assets/google_pay_payment_profile.json
          //       await debugChangedStripePublishableKey();
          //     },
          //     onError: (e) {
          //       ScaffoldMessenger.of(context).showSnackBar(
          //         const SnackBar(
          //           content: Text(
          //               'There was an error while trying to perform the payment'),
          //         ),
          //       );
          //     },
          //   ),
          // )
        ],
      ),
    );
  }

  Future<void> onGooglePayResult(paymentResult) async {
    try {
      // 1. Add your stripe publishable key to assets/google_pay_payment_profile.json
      print("result");
      debugPrint(paymentResult.toString());
      // 2. fetch Intent Client Secret from backend
      final response = await (fetchPaymentIntentClientSecret()
          as FutureOr<Map<String, dynamic>>);
      //  paymentIntentData=json.decode(response.body);
      final clientSecret = response['paymentIntent'];
      final token =
          paymentResult['paymentMethodData']['tokenizationData']['token'];
      final tokenJson = Map.castFrom(json.decode(token));
      print(tokenJson);

      final params = PaymentMethodParams.cardFromToken(
        paymentMethodData: tokenJson['id'], // TODO extract the actual token
      );

      // 3. Confirm Google pay payment method
      // kashif
      // await Stripe.instance.confirmPayment(
      //   clientSecret,
      //   params,
      // );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Google Pay payment succesfully completed')),
      );
    } catch (e) {
      print("error");
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
        'amount': 200
      }),
    );
    return json.decode(response.body);
  }

  Future<void> debugChangedStripePublishableKey() async {
    if (kDebugMode) {
      final profile =
          await rootBundle.loadString('assets/google_pay_payment_profile.json');
      final isValidKey =
          !profile.contains('pk_test_M0CqHOXEA2FchWCO3qU6gDY800xcZNh6pL');
      assert(
        isValidKey,
        'No stripe publishable key added to assets/google_pay_payment_profile.json',
      );
    }
  }
}

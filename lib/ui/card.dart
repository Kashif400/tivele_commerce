import 'package:flutter/material.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';

class PaymentCard extends StatefulWidget {
  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
        body: Container(
          padding: EdgeInsets.symmetric(
            vertical: 12,
            horizontal: 16,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      height: 120,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(16),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'TIVELE',
                            style: Global.style(
                              size: 22,
                              bold: true,
                              caps: true,
                            ),
                          ),
                          Text(
                            '**** **** **** 9401',
                            style: Global.style(
                              size: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: Container(
                        height: 16,
                        width: 16,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 12),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'Primary Card **** **** **** 9401',
                    style: Global.style(
                      size: 16,
                    ),
                  ),
                ),
                SizedBox(height: 16),
                MyTextField(
                    hint: 'First Name',
                    controller: controller,
                    readOnly: false),
                SizedBox(height: 12),
                MyTextField(
                    hint: 'Last Name', controller: controller, readOnly: false),
                SizedBox(height: 12),
                MyTextField(
                    hint: 'Card Number',
                    controller: controller,
                    readOnly: false),
                SizedBox(height: 24),
                InkWell(
                  onTap: openCalendarPicker,
                  child: Text(
                    'Expiry Date',
                    style: Global.style(
                      size: 16,
                      color: Colors.white70,
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),
                SizedBox(height: 12),
                MyTextField(
                    hint: 'CVV', controller: controller, readOnly: false),
                SizedBox(height: 24),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Other Cards',
                        style: Global.style(
                          size: 16,
                          color: Colors.white70,
                        ),
                      ),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),
                SizedBox(height: 12),
                InkWell(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Add New Card',
                        style: Global.style(
                          size: 16,
                          color: Colors.white70,
                        ),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openCalendarPicker() {}
}

import 'dart:async';

import 'package:e_commerce_foods/Provider/card.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

import 'add_card.dart';

class PaymentCard extends StatefulWidget {
  @override
  _PaymentCardState createState() => _PaymentCardState();
}

class _PaymentCardState extends State<PaymentCard> {
  bool isBusy = false;
  int? _groupValue;
  String _getDateText(DateTime createdAt) {
    var txt = '-';
    var formatter = DateFormat('dd MMM yyyy');
    if (createdAt != null) {
      txt = formatter.format(createdAt);
    }
    return txt;
  }
  //String card;

  initState() {
    super.initState();
    setState(() {
      isBusy = true;
    });
    // context.read<CardsProvider>().getCards("2d6ee5ad-83ef-43a2-c424-08d8ded8834f");
    context.read<CardsProvider>().getCard();
    //context.read<BusinessUsersProvider>().getBussinessUser();
  }

  @override
  Widget build(BuildContext context) {
    final card = context.watch<CardsProvider>().bankcard;
    CheckListCount(card.length);

    TextEditingController firstNameController = TextEditingController();
    TextEditingController lastNameController = TextEditingController();
    TextEditingController cardNameController = TextEditingController();
    TextEditingController expireDateController = TextEditingController();
    TextEditingController cvvController = TextEditingController();
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
      body: ModalProgressHUD(
        child: Container(
            padding: EdgeInsets.symmetric(
              vertical: 12,
              horizontal: 16,
            ),
            child: card.length > 0
                ? Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16,
                                      vertical: 16,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: 80,
                                          width: 190,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                            ),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(16),
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                card[index].bankName == null
                                                    ? "TIVELE"
                                                    : card[index].bankName!,
                                                style: Global.style(
                                                  size: 18,
                                                  bold: true,
                                                ),
                                              ),
                                              Text(
                                                card == null
                                                    ? "123456"
                                                    : "********" +
                                                        card[index]
                                                            .cardNumber!
                                                            .substring(12, 16),
                                                style: Global.style(
                                                  size: 14,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Theme(
                                            data: ThemeData.dark(),
                                            child: Radio(
                                                activeColor: Colors.white,
                                                hoverColor: Colors.white,
                                                groupValue: _groupValue,
                                                value: index,
                                                onChanged: (dynamic value) =>
                                                    setState(() {
                                                      _groupValue = index;
                                                    })))
                                      ],
                                    ),
                                  );
                                },
                                // separatorBuilder: (context,index){
                                //   return Container(
                                //     height: 1,
                                //     width: double.infinity,
                                //     color: Colors.white,
                                //   );
                                // },
                                itemCount: card.length,
                              ),

                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     Container(
                              //       height: 120,
                              //       width: 200,
                              //       decoration: BoxDecoration(
                              //         border: Border.all(
                              //           color: Colors.white,
                              //         ),
                              //         borderRadius: BorderRadius.all(
                              //           Radius.circular(16),
                              //         ),
                              //       ),
                              //       child: Column(
                              //         mainAxisAlignment: MainAxisAlignment.center,
                              //         children: [
                              //           Text(
                              //             'TIVELE',
                              //             style: Global.style(
                              //               size: 22,
                              //               bold: true,
                              //               caps: true,
                              //             ),
                              //           ),
                              //           Text(
                              //             '**** **** **** 9401',
                              //             style: Global.style(
                              //               size: 14,
                              //             ),
                              //           ),
                              //         ],
                              //       ),
                              //     ),
                              //     Container(
                              //       padding: EdgeInsets.all(8),
                              //       decoration: BoxDecoration(
                              //         border: Border.all(
                              //           color: Colors.white,
                              //         ),
                              //         shape: BoxShape.circle,
                              //       ),
                              //       child: Container(
                              //         height: 16,
                              //         width: 16,
                              //         decoration: BoxDecoration(
                              //           color: Colors.white,
                              //           shape: BoxShape.circle,
                              //         ),
                              //       ),
                              //     )
                              //   ],
                              // ),
                              // SizedBox(height: 12),
                              // Align(
                              //   alignment: Alignment.center,
                              //   child: Text(
                              //     'Primary Card **** **** **** 9401',
                              //     style: Global.style(
                              //       size: 16,
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(height: 16),
                              // MyTextField(
                              //   hint: 'First Name',
                              //   controller: firstNameController,
                              //     readOnly: false
                              // ),
                              // SizedBox(height: 12),
                              // MyTextField(
                              //   hint: 'Last Name',
                              //   controller: lastNameController,
                              //     readOnly: false
                              // ),
                              // SizedBox(height: 12),
                              // MyTextField(
                              //   hint: 'Card Number',
                              //   controller: cardNameController,
                              //     readOnly: false
                              // ),
                              // SizedBox(height: 24),
                              // MyTextField(
                              //   hint: 'Expiry Date',
                              //   controller: expireDateController,
                              //     readOnly: false
                              // ),
                              // //SizedBox(height: 12),
                              //
                              // Container(
                              //   width: double.infinity,
                              //   height: 1,
                              //   color: Colors.white,
                              // ),
                              // SizedBox(height: 12),
                              // MyTextField(
                              //   hint: 'CVV',
                              //   controller: cvvController,
                              //     readOnly: false
                              // ),
                              // SizedBox(height: 24),
                              // InkWell(
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text(
                              //         'Other Cards',
                              //         style: Global.style(
                              //           size: 16,
                              //           color: Colors.white70,
                              //         ),
                              //       ),
                              //       Icon(
                              //         Icons.keyboard_arrow_down,
                              //         color: Colors.white,
                              //         size: 28,
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // SizedBox(height: 12),
                              // Container(
                              //   width: double.infinity,
                              //   height: 1,
                              //   color: Colors.white,
                              // ),
                              // SizedBox(height: 12),
                              // InkWell(
                              //   child: Row(
                              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //     children: [
                              //       Text(
                              //         'Add New Card',
                              //         style: Global.style(
                              //           size: 16,
                              //           color: Colors.white70,
                              //         ),
                              //       ),
                              //       IconButton(
                              //         iconSize: 28,
                              //         icon: Icon(Icons.add,color: Colors.white,) ,
                              //         onPressed: (){
                              //           Navigator.of(context).push(
                              //             MaterialPageRoute(
                              //               builder: (_) => NewPaymentCard(),
                              //             ),
                              //           );
                              //         },
                              //       ),
                              //     ],
                              //   ),
                              // ),
                              // SizedBox(height: 12),
                              // Container(
                              //   width: double.infinity,
                              //   height: 1,
                              //   color: Colors.white,
                              // ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          child: InkWell(
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
                                IconButton(
                                  iconSize: 28,
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => NewPaymentCard(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          height: 12,
                        ),
                        flex: 1,
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Expanded(
                        child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              "",
                              style: TextStyle(color: Colors.transparent),
                            )),
                        flex: 6,
                      ),
                      Expanded(
                        child: SizedBox(
                          child: InkWell(
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
                                IconButton(
                                  iconSize: 28,
                                  icon: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (_) => NewPaymentCard(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          height: 12,
                        ),
                        flex: 1,
                      )
                    ],
                  )),
        inAsyncCall: isBusy,
        // demo of some additional parameters
        // opacity: 0.5,
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
    ));
  }

  _onChangeValue(String value) {}
  void CheckListCount(count) async {
    if (count > 0) {
      if (isBusy) {
        setState(() {
          isBusy = true;
        });
      }

      await Future.delayed(Duration(seconds: 2));
      if (mounted) {
        setState(() {
          isBusy = false;
        });
      }
    } else {
      await Future.delayed(Duration(seconds: 2));
      if (mounted) {
        setState(() {
          isBusy = false;
        });
      }
    }
  }

  void openCalendarPicker() {}
}

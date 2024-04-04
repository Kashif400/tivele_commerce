import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';
import 'package:e_commerce_foods/Provider/card.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/service/BankCard/card.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';

class NewPaymentCard extends StatefulWidget {
  @override
  _NewPaymentCardState createState() => _NewPaymentCardState();
}

class _NewPaymentCardState extends State<NewPaymentCard> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expireDateController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  bool isBusy = false;
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
    context.read<BusinessUsersProvider>().getCurrentUser();
    //context.read<CardsProvider>().getCards("2d6ee5ad-83ef-43a2-c424-08d8ded8834f");

    //context.read<BusinessUsersProvider>().getBussinessUser();
  }

  @override
  Widget build(BuildContext context) {
    final card = context.watch<CardsProvider>().bankcards;
    final bUser = context.watch<BusinessUsersProvider>().users;
    var dateFormater = MaskTextInputFormatter(mask: "##/####");
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
                      controller: firstNameController,
                      readOnly: false),
                  SizedBox(height: 12),
                  MyTextField(
                      hint: 'Last Name',
                      controller: lastNameController,
                      readOnly: false),
                  SizedBox(height: 12),
                  MyTextField(
                      hint: 'Bank Name',
                      controller: bankNameController,
                      readOnly: false),
                  SizedBox(height: 12),
                  TextFormField(
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: "Card Number",
                      hintStyle: const TextStyle(color: Colors.grey),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      errorMaxLines: 1,
                    ),
                    controller: cardNumberController,
                    readOnly: false,
                  ),
                  SizedBox(height: 24),
                  TextFormField(
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    autovalidateMode: AutovalidateMode.always,
                    decoration: InputDecoration(
                      hintText: "Expiry Date",
                      hintStyle: const TextStyle(color: Colors.grey),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      errorBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.red)),
                      border: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.white)),
                      errorMaxLines: 1,
                    ),
                    inputFormatters: [dateFormater],
                    controller: expireDateController,
                    keyboardType: TextInputType.datetime,
                    readOnly: false,
                  ),
                  SizedBox(height: 12),

                  /*Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),*/
                  SizedBox(height: 12),
                  MyTextField(
                      type: TextInputType.number,
                      hint: 'CVV',
                      controller: cvvController,
                      readOnly: false),
                  SizedBox(height: 24),
                  /*InkWell(
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
                ),*/
                  SizedBox(height: 12),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ConfirmationSlider(
                        onConfirmation: () {
                          CreateBankCard();
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        textStyle: Global.style(
                          color: Colors.black,
                          size: 16,
                        ),
                        text: 'Swipe to Submit',
                        height: 50,
                      ),
                    ),
                  )
                  /* Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),
                SizedBox(height: 12),*/
                  /*InkWell(
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
                        iconSize: 10,
                        icon: Icon(Icons.add,color: Colors.white,) ,
                        onPressed: (){
                          MaterialPageRoute(
                              builder: (_) => PaymentCard()
                          );
                        },
                      ),
                    ],
                  ),
                ),*/
                  /* SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  height: 1,
                  color: Colors.white,
                ),*/
                ],
              ),
            ),
          ),
          inAsyncCall: isBusy,
          // opacity: 0.5,
          progressIndicator: CircularProgressIndicator(
            backgroundColor: Colors.white,
            // valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
          ),
        ),
      ),
    );
  }

  CreateBankCard() async {
    if (!await validate()) return;
    try {
      setState(() {
        isBusy = true;
      });
      DateTime date;
      var bUser = await SessionService.retrieveUser();

      //final bsUser = context.watch<BusinessUsersProvider>().users;
      var card = {
        'cardNumber': cardNumberController.text,
        'bankName': bankNameController.text,
        'firstName': firstNameController.text,
        'lastName': lastNameController.text,
        'expiryDate': expireDateController.text,
        'cvv': cvvController.text,
        "userId": bUser
      };
      var res = await CardService.create(card);
      if (res) {
        showSuccessToast("Card is created Sucessfully");
        context.read<CardsProvider>().getCard();
        Navigator.pop(context);
      } else {
        setState(() {
          isBusy = false;
        });
      }
    } catch (err) {
      final requestbody = json.decode(err.toString());
      final data = requestbody['error'];
      showErrorToast(data["message"]);
      setState(() {
        isBusy = false;
      });
      print(err);
    }
  }

  Future<bool> validate() async {
    if (firstNameController.text.isEmpty) {
      showErrorToast("Please enter First Name");
      return false;
    }
    if (lastNameController.text.isEmpty) {
      showErrorToast("Please enter Last Name");
      return false;
    }
    if (bankNameController.text.isEmpty) {
      showErrorToast("Please enter Bank Name");
      return false;
    }
    if (cardNumberController.text.isEmpty) {
      showErrorToast("Please enter Card Number");
      return false;
    }
    if (cardNumberController.text.length < 16) {
      showErrorToast("Please enter Valid Card Number");
      return false;
    }

    if (expireDateController.text.isEmpty) {
      showErrorToast("Please enter Expiry Date");
      return false;
    }
    if (expireDateController.text.length < 7) {
      showErrorToast("Please enter valid Expiry Date");
      return false;
    }
    if (cvvController.text.isEmpty) {
      showErrorToast("Please enter CVV");
      return false;
    }
    if (cvvController.text.length < 3 || cvvController.text.length > 3) {
      showErrorToast("Please enter valid cvv");
      return false;
    }
    return true;
  }

  void showErrorToast(Message) {
    Fluttertoast.showToast(
        msg: Message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  void showSuccessToast(Message) {
    Fluttertoast.showToast(
        msg: Message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIos: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white);
  }

  void openCalendarPicker() {}
}

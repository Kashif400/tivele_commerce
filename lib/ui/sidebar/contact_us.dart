import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/service/ContactUs/contact.dart';
import 'package:e_commerce_foods/ui/home/home_user.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  TextEditingController nameController = TextEditingController();
  TextEditingController issueController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  bool isBusy = false;

  void showToast(Message) {
    Fluttertoast.showToast(
        msg: Message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIos: 1,
        backgroundColor: Colors.greenAccent,
        textColor: Colors.white);
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.black,
            title: Text(
              'CONTACT US',
              style: Global.style(
                bold: true,
                caps: true,
                size: 20,
              ),
            ),
          ),
          backgroundColor: Colors.black,
          body: ModalProgressHUD(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 16,
              ),
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    MyTextField(
                        hint: 'Name',
                        controller: nameController,
                        readOnly: false),
                    SizedBox(height: 12),
                    MyTextField(
                        hint: 'Email Address',
                        controller: emailController,
                        readOnly: false),
                    SizedBox(height: 12),
                    MyTextField(
                        hint: 'Phone Number',
                        controller: phoneController,
                        readOnly: false),
                    SizedBox(height: 12),
                    MyTextField(
                        hint: 'Issue',
                        controller: issueController,
                        lines: 4,
                        readOnly: false),
                    SizedBox(height: 16),
                    Container(
                      height: 45,
                      width: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 10,
                          )
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(
                          Radius.circular(8),
                        ),
                        child: MaterialButton(
                          onPressed: () {
                            ContactUsRequest();
                          },
                          child: Text(
                            'Send',
                            textAlign: TextAlign.center,
                            style: Global.style(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            inAsyncCall: isBusy,
            // demo of some additional parameters
            //  opacity: 0.5,
            progressIndicator: CircularProgressIndicator(
              backgroundColor: Colors.white,
              //  valueColor:  new AlwaysStoppedAnimation<Color>(
              //    Colors.black),
            ),
          )),
    );
  }

  ContactUsRequest() async {
    try {
      if (!await validate()) return;
      var con = {
        "name": nameController.text,
        "address": emailController.text,
        "issue": issueController.text,
        "phone": phoneController.text
      };
      setState(() {
        isBusy = true;
      });
      var res = await ContactUsService.create(con);
      if (res) {
        showToast("Message has been Send Successfully");
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (_) => HomeUser(),
          ),
          (_) => false,
        );
      } else {
        showErrorToast("Error occur during your request");
        setState(() {
          isBusy = false;
        });
      }
    } catch (err) {
      // final requestbody = json.decode(err.body);
      // final data = requestbody['error'];
      // showErrorToast(data["message"]);
      showErrorToast(err.toString());
      setState(() {
        isBusy = false;
      });
    }
  }

  Future<bool> validate() async {
    if (nameController.text.isEmpty) {
      showErrorToast("Please enter a Name");
      return false;
    }
    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(emailController.text)) {
      showErrorToast("Please enter a valid Email");
      return false;
    }
    if (phoneController.text.isEmpty) {
      showErrorToast("Please enter Phone Number");
      return false;
    }
    if (issueController.text.isEmpty || issueController.text == "") {
      showErrorToast("Please enter Issue");
      return false;
    }

    return true;
  }
}

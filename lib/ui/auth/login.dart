import 'package:flutter/material.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/ui/home.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool remember = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            'TIVELE',
            style: Global.style(
              bold: true,
              size: 22,
            ),
          ),
        ),
        body: Container(
          padding: EdgeInsets.all(32),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MyTextField(
                hint: 'Business Name',
                controller: nameController,
              ),
              SizedBox(height: 16),
              MyTextField(
                hint: 'Account ID',
                controller: nameController,
              ),
              SizedBox(height: 16),
              MyTextField(
                hint: 'Password',
                controller: nameController,
                obscureText: true,
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    height: 24,
                    width: 24,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          remember = !remember;
                        });
                      },
                      icon: Icon(
                        remember
                            ? Icons.check_box_outline_blank
                            : Icons.check_box,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  SizedBox(width: 4),
                  Expanded(
                    child: Text('Stay Logged In', style: Global.style()),
                  ),
                ],
              ),
              SizedBox(height: 32),
              Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  color: Colors.white,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(30),
                  ),
                  child: MaterialButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => Home(),
                        ),
                      );
                    },
                    child: Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: Global.style(
                        color: Colors.black,
                        bold: true,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

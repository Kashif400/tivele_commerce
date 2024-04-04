import 'package:flutter/material.dart';
import 'package:e_commerce_foods/global/global.dart';

class Points extends StatefulWidget {
  @override
  _PointsState createState() => _PointsState();
}

class _PointsState extends State<Points> {
  TextEditingController controller = TextEditingController();
  bool remember = false;

  @override
  Widget build(BuildContext context) {
    String image =
        'https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg';
    double size = (MediaQuery.of(context).size.width - 32) / 5;
    double height = MediaQuery.of(context).size.height - 24;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      border: Border.all(
                        color: Colors.white,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(
                        Radius.circular(50),
                      ),
                      child: Image.network(
                        image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Column(
                    children: [
                      Text(
                        'Username',
                        style: Global.style(
                          bold: true,
                          size: 18,
                        ),
                      ),
                      Text(
                        '1567 points',
                        style: Global.style(
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32),
              Container(
                height: 45,
                width: double.infinity,
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
                    onPressed: () {},
                    child: Text(
                      'Redeem Points',
                      textAlign: TextAlign.center,
                      style: Global.style(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text(
                'You are here',
                style: Global.style(
                  size: 16,
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      border: Border.all(
                        color: Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Silver',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                  ),
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      border: Border.all(
                        color: Colors.white,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Gold',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                  ),
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.cyan,
                      border: Border.all(
                        color: Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Platinum',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                  ),
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      border: Border.all(
                        color: Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Black Card',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                  ),
                  Container(
                    width: size,
                    height: size,
                    decoration: BoxDecoration(
                      color: Colors.cyan[300],
                      border: Border.all(
                        color: Colors.transparent,
                        width: 3,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Tivele Card',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                  )
                ],
              ),
              Spacer(),
              Spacer(),
              Text(
                'Next Level in\n433 points',
                textAlign: TextAlign.center,
                style: Global.style(
                  size: 16,
                ),
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}

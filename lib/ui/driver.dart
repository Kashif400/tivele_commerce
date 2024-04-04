import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';
import 'package:flutter/material.dart';

class Driver extends StatefulWidget {
  @override
  _DriverState createState() => _DriverState();
}

class _DriverState extends State<Driver> {
  TextEditingController controller = TextEditingController();

  String car =
      'https://static01.nyt.com/images/2007/06/15/automobiles/600-scion-01.jpg';

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
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
              children: [
                MyTextField(
                    hint: 'First Name',
                    controller: controller,
                    readOnly: false),
                SizedBox(height: 12),
                MyTextField(
                    hint: 'Last Name', controller: controller, readOnly: false),
                SizedBox(height: 12),
                MyTextField(
                    hint: 'Email Address',
                    controller: controller,
                    readOnly: false),
                SizedBox(height: 12),
                MyTextField(
                    hint: 'Address', controller: controller, readOnly: false),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: MyTextField(
                          hint: 'City',
                          controller: controller,
                          readOnly: false),
                    ),
                    Expanded(
                      child: MyTextField(
                          hint: 'Province',
                          controller: controller,
                          readOnly: false),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                MyTextField(
                    hint: 'Contact Number',
                    controller: controller,
                    readOnly: false),
                SizedBox(height: 36),
                Text(
                  'Upload Picture of Drivers License',
                  style: Global.style(
                    size: 16,
                  ),
                ),
                SizedBox(height: 12),
                Container(
                  height: width / 1.9,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 5,
                    ),
                  ),
                  child: Icon(
                    Icons.add_a_photo_outlined,
                    color: Colors.white,
                    size: 60,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

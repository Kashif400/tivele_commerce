import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_foods/Provider/driver.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/ui/alerts.dart';
import 'package:e_commerce_foods/ui/auth/register.dart';

class HomeDriver extends StatefulWidget {
  @override
  // final String driverAccountId;
  // const HomeDriver(this.driverAccountId);
  _HomeDriverState createState() => _HomeDriverState();
}

class _HomeDriverState extends State<HomeDriver> {
  TextEditingController controller = TextEditingController();
  bool remember = false;
  String? AccountId;
  late bool isBusy;
  @override
  void initState() {
    super.initState();
    setState(() {
      isBusy = true;
    });
    context.read<DriversProvider>().getCurrentDrivers();
  }

  String _getDateText(DateTime? createdAt) {
    var txt = '-';
    var formatter = DateFormat('dd MMM yyyy');
    if (createdAt != null) {
      txt = formatter.format(createdAt);
    }
    return txt;
  }

  String? _getTimeText(DateTime createdAt) {
    var txt = '-';
    var local;
    var local_modified;
    String? time;
    var formatter = DateFormat('hh:mm:ss');
    if (createdAt != null) {
      txt = formatter.format(createdAt);
      local = formatter.parseUTC(txt).toLocal();
      local_modified = DateFormat('hh:mm a').format(local);
      time = local_modified.toString();
    }
    return time;
  }

  @override
  Widget build(BuildContext context) {
    String image =
        'https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg';
    final divUser = context.watch<DriversProvider>().drivers;
    if (divUser != null) {
      setState(() {
        isBusy = false;
      });
    }
    //final divUser=_GetCurrentDriver();
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          body: ModalProgressHUD(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: divUser != null
                  ? Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  divUser == null ||
                                          divUser.profileImage == null
                                      ? "https://t4.ftcdn.net/jpg/02/23/50/73/360_F_223507349_F5RFU3kL6eMt5LijOaMbWLeHUTv165CB.jpg"
                                      : divUser.profileImage!,
                                  //image,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            // SizedBox(width: 12),
                            Text(
                              divUser.driverName == null
                                  ? "Driver"
                                  : divUser.driverName!,
                              style: Global.style(
                                bold: true,
                                size: 20,
                              ),
                            ),
                            SizedBox(
                              width: 20.0,
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.logout,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                    builder: (_) => Register(),
                                  ),
                                  (_) => false,
                                );
                              },
                            ),
                          ],
                        ),
                        SizedBox(height: 32),
                        Text(
                          'Completed Orders',
                          style: Global.style(
                            bold: true,
                            size: 22,
                          ),
                        ),
                        SizedBox(height: 32),
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: false,
                            itemCount: divUser.orders!.length,
                            itemBuilder: (_, index) {
                              return Container(
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            divUser.orders![index]
                                                        .productName ==
                                                    null
                                                ? "product name"
                                                : divUser.orders![index]
                                                    .productName!,
                                            style: Global.style(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _getDateText(divUser
                                                .orders![index].deliveryTime),
                                            style: Global.style(),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: Container(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 10),
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.white,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            _getTimeText(divUser
                                                .orders![index].deliveryTime!
                                                .toLocal())!,
                                            style: Global.style(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => Alerts(),
                                  ),
                                );
                              },
                              icon: Icon(
                                Icons.notifications,
                                color: Colors.amber,
                                size: 36,
                              ),
                            ),
                            IconButton(
                              onPressed: () {},
                              icon: Icon(
                                Icons.volume_off,
                                color: Colors.white,
                                size: 36,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : CloseLoader(),
            ),
            inAsyncCall: isBusy,
            // demo of some additional parameters
            //opacity: 0.5,
            progressIndicator: Container(
              color: Colors.black,
              constraints: BoxConstraints.expand(),
              child: Center(
                child: Container(
                  //color: Colors.black,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              ),
            ),
          )),
    );
  }

  CloseLoader() {
    Future.delayed(const Duration(milliseconds: 2000), () {
      setState(() {
        isBusy = false;
      });
    });
  }
}

import 'dart:async';
import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import '../../models/product/products.dart';
import '../business_profile.dart';

class Deals extends StatefulWidget {
  @override
  _DealsState createState() => _DealsState();
}

class _DealsState extends State<Deals> {
  TextEditingController controller = TextEditingController();
  bool isBusy = false;
  String burger =
      'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg';
  String? HeaderImage;
  //var distance=new List();
  List<Items> distance = [];
  List<Items> DistanceProducts = [];
  // var DistanceProducts=new List();

  @override
  initState() {
    super.initState();
    setState(() {
      isBusy = true;
    });
    context.read<ProductsProvider>().getProductbyLocation();
    context.read<BusinessUsersProvider>().getBussinessUser();
  }

  @override
  Widget build(BuildContext context) {
    //final busines = context.watch<BusinessUsersProvider>().user;
    distance = context.watch<ProductsProvider>().productbyDistance;
    CheckListCount(distance.length);
    double width = MediaQuery.of(context).size.width;
    if (distance.length > 0) {
      setState(() {
        HeaderImage = distance[0].productImage!.url;
        isBusy = false;
      });
    }
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
//        appBar: AppBar(
//          elevation: 0,
//          backgroundColor: Colors.black,
//          title: Text(
//            'Tivele Deals',
//            style: Global.style(
//              size: 22,
//              bold: true,
//            ),
//          ),
//          centerTitle: true,
//        ),
        body: distance.length == 0
            ? Center(
                child: CircularProgressIndicator(
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.black)))
            : ModalProgressHUD(
                inAsyncCall: isBusy,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: SingleChildScrollView(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 1,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 1,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 1.3,
                        ),
                        itemBuilder: (context, index) {
                          return Stack(
                            children: [
                              Container(
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(0),
                                  ),
                                  child: Image.network(
                                    HeaderImage != null ? HeaderImage! : burger,
                                    fit: BoxFit.cover,
                                    height: width / 1.3 - 25,
                                    width: width,
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 8,
                                right: 16,
                                child: Text.rich(
                                  TextSpan(
                                    text: "",
                                    style: Global.style(
                                      size: 16,
                                      bold: true,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: "",
                                        style: Global.style(
                                          size: 13,
                                          bold: true,
                                          cut: true,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      SizedBox(height: 6),
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: GetList(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 6,
                          childAspectRatio: 1.3,
                        ),
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              getBusinessUserProfile(
                                  DistanceProducts[index].businessAccount!.id!,
                                  context);
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => BusinessProfile(
                                      DistanceProducts[index]
                                          .businessAccount!
                                          .id),
                                ),
                              );
                              /*Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => OrderConfirmation(),
                          ),
                        );*/
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(0),
                                ),
                                child: Image.network(
                                  distance[index].productImage!.url != null
                                      ? distance[index].productImage!.url!
                                      : "https://images.unsplash.com/photo-1512621776951-a57141f2eefd?ixlib=rb-1.2.1&ixid=MXwxMjA3fDB8MHxleHBsb3JlLWZlZWR8NXx8fGVufDB8fHw%3D&w=1000&q=80",
                                  //burger,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  )),
                ),
                color: Colors.black,

                // demo of some additional parameters
                //opacity: 0.5,
                progressIndicator: Container(
                  color: Colors.black,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.black),
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  getBusinessUserProfile(String id, BuildContext ctx) async {
    ctx.read<BusinessUsersProvider>().getBussinessUsers(id);
  }

  int GetList() {
    print("get list called here for bilkul home page ico btn (t)");
    if (distance.length > 0) {
      DistanceProducts.clear();
      setState(() {
        HeaderImage = distance[0].productImage!.url;
      });
      for (var item in distance) {
        DistanceProducts.add(item);
      }
      DistanceProducts.removeAt(0);
      return DistanceProducts.length;
    } else {
      return 0;
    }
  }

  CheckListCount(int count) async {
    if (count > 0) {
      await Future.delayed(Duration(seconds: 0));
      if (mounted) {
        setState(() {
          isBusy = false;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          isBusy = true;
        });
      }
      await Future.delayed(Duration(seconds: 5));

      if (mounted) {
        setState(() {
          isBusy = false;
        });
      }
    }
  }
}

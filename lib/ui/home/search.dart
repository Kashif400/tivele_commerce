import 'dart:async';

import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/productCategory.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/product/product_category.dart';
import 'package:e_commerce_foods/models/product/products.dart';
import 'package:e_commerce_foods/ui/item_details.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController controller = TextEditingController();
  TextEditingController filterController = TextEditingController();
  List filteredNames = [];
  bool isShowList = false;
  bool isFilteredList = false;
  bool isBusy = true;
  late List<ProductCategory> requests;
  List<Items> categortProduct = [];
  List<Items> distance = [];
  List<Items> FilteredProducts = [];
  List<Items> DistanceProducts = [];
  _SearchState() {
    filterController.addListener(() {
      _buildFilteredList();
    });
  }
  String burger =
      'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg';
  String? HeaderImage;
  @override
  initState() {
    super.initState();
    context.read<ProductsCategoryProvider>().getProductCategory();
    context.read<ProductsProvider>().getProductbyLocation();
    context.read<ProductsProvider>().getProductLikeByUser();
    context.read<BusinessUsersProvider>().getBussinessUser();
  }

  @override
  Widget build(BuildContext context) {
    requests = context.watch<ProductsCategoryProvider>().category;
    if (filterController.text.isNotEmpty) {
      categortProduct.clear();
      categortProduct = context.watch<ProductsProvider>().productbyCategory;
    }
    distance = context.watch<ProductsProvider>().productbyDistance;
    if (distance.length > 0) {
      setState(() {
        if (HeaderImage == null) {
          HeaderImage = distance[0].productImage!.url;
        }
        if (filterController.text == "") {
          HeaderImage = distance[0].productImage!.url;
        }
        isBusy = false;
      });
    }
    final busines = context.watch<BusinessUsersProvider>().user;
    double width = MediaQuery.of(context).size.width;
    var filterWidth = width - 100;
    var filterListViewWidth = width - 30;
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.black,
//          title: GestureDetector(
//            onTap: () {
//              Navigator.of(context).push(
//                MaterialPageRoute(
//                  builder: (_) => Categories(),
//                ),
//              );
//            },
//            child: MyTextField(
//              controller: controller,
//              hint: 'Click here to search',
//            ),
//          ),
              title: GestureDetector(
                onTap: () {
                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (_) => Categories(),
                  //   ),
                  // );
                },
                child: Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(12),
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      SizedBox(width: 4),
                      Column(
                        children: [
                          Container(
                            width: filterWidth,
                            height: 35.0,
                            child: TextFormField(
                              cursorColor: Colors.black,
                              controller: filterController,
                              decoration: new InputDecoration(
                                  border: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  disabledBorder: InputBorder.none,
                                  contentPadding: EdgeInsets.only(
                                      left: 15, bottom: 9, top: 8, right: 15),
                                  hintText: "Search"),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              centerTitle: true,
            ),
            body: ModalProgressHUD(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: distance.length > 0
                        ? Column(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      GridView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: 1,
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
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
                                                    borderRadius:
                                                        BorderRadius.all(
                                                      Radius.circular(0),
                                                    ),
                                                    child: InkWell(
                                                      child: filterController
                                                              .text.isNotEmpty
                                                          ? categortProduct
                                                                      .length >
                                                                  0
                                                              ? Image.network(
                                                                  categortProduct[index]
                                                                              .productImage ==
                                                                          null
                                                                      ? burger
                                                                      : categortProduct[
                                                                              index]
                                                                          .productImage!
                                                                          .url!,
                                                                  // HeaderImage!=null?HeaderImage:burger,
                                                                  fit: BoxFit
                                                                      .cover,
                                                                  height: width /
                                                                          1.3 -
                                                                      25,
                                                                  width: width,
                                                                )
                                                              : Text("")
                                                          : Image.network(
                                                              distance[index]
                                                                          .productImage ==
                                                                      null
                                                                  ? burger
                                                                  : distance[
                                                                          index]
                                                                      .productImage!
                                                                      .url!,
                                                              // HeaderImage!=null?HeaderImage:burger,
                                                              fit: BoxFit.cover,
                                                              height:
                                                                  width / 1.3 -
                                                                      25,
                                                              width: width,
                                                            ),
                                                      onTap: () {
                                                        getBusinessUserProfile(
                                                            distance[index]
                                                                .businessAccount!
                                                                .id!,
                                                            context);
                                                        Navigator.of(context)
                                                            .push(
                                                          MaterialPageRoute(
                                                            builder: (_) => categortProduct
                                                                        .length >
                                                                    0
                                                                ? ItemDetails(
                                                                    id: categortProduct[
                                                                            index]
                                                                        .id)
                                                                : ItemDetails(
                                                                    id: distance[
                                                                            index]
                                                                        .id),
                                                          ),
                                                        );
                                                        filterController.text =
                                                            "";
                                                        // categortProduct.clear();
                                                        FocusScope.of(context)
                                                            .unfocus();
                                                      },
                                                    )),
                                              ),
                                              Positioned(
                                                bottom: 8,
                                                right: 16,
                                                child: Text.rich(
                                                  TextSpan(
                                                    text: " ",
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
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 6,
                                          mainAxisSpacing: 6,
                                          childAspectRatio: 1.3,
                                        ),
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              getBusinessUserProfile(
                                                  DistanceProducts[index]
                                                      .businessAccount!
                                                      .id!,
                                                  context);
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (_) => FilteredProducts
                                                              .length >
                                                          0
                                                      ? ItemDetails(
                                                          id: FilteredProducts[
                                                                  index]
                                                              .id)
                                                      : ItemDetails(
                                                          id: DistanceProducts[
                                                                  index]
                                                              .id),
                                                ),
                                              );
                                              filterController.text = "";
                                              // categortProduct.clear();
                                              FocusScope.of(context).unfocus();
                                            },
                                            child: Container(
                                              child: ClipRRect(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(0),
                                                ),
                                                child: filterController
                                                        .text.isNotEmpty
                                                    ? FilteredProducts.length >
                                                            0
                                                        ? Image.network(FilteredProducts[
                                                                        index]
                                                                    .productImage !=
                                                                null
                                                            ? FilteredProducts[
                                                                    index]
                                                                .productImage!
                                                                .url!
                                                            : burger)
                                                        : Align(
                                                            alignment: Alignment
                                                                .center,
                                                            child: Text(
                                                              "",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .black),
                                                            ),
                                                          )
                                                    : Image.network(
                                                        DistanceProducts[index]
                                                                    .productImage ==
                                                                null
                                                            ? Global.burger
                                                            : DistanceProducts[
                                                                    index]
                                                                .productImage!
                                                                .url!,
                                                        fit: BoxFit.cover,
                                                      ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )
                        : _closeLoader(),
                  ),
                  Visibility(
                    visible: isShowList,
                    child: SingleChildScrollView(
                      child: Container(
                        alignment: Alignment.center,
                        height: 150,
                        width: filterListViewWidth,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.fromLTRB(25, 0, 0, 0),
                          itemCount: filteredNames.length,
                          itemBuilder: (BuildContext context, index) {
                            return new ListTile(
                                tileColor: Colors.white,
                                title: Text(filteredNames[index]),
                                onTap: () {
                                  productByCategory(filteredNames[index]);
                                });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              color: Colors.black,
              inAsyncCall: isBusy,
              // demo of some additional parameters
              // opacity: 0.5,
              progressIndicator: Container(
                color: Colors.black,
                child: Container(
                  color: Colors.black,
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  ),
                ),
              ),
            )));
  }

  _buildFilteredList() {
    if (filterController.text.isNotEmpty) {
      if (requests.length > 0) {
        List<String?> namesList = [];
        List<String?> tempList = [];
        for (var item in requests) {
          namesList.add(item.name);
        }
        for (int i = 0; i < namesList.length; i++) {
          if (namesList[i]!
              .toLowerCase()
              .contains(filterController.text.toLowerCase())) {
            tempList.add(namesList[i]);
          }
        }
        setState(() {
          filteredNames = tempList;
          isShowList = true;
          // isFilteredList=true;
        });
      }
    } else {
      setState(() {
        filteredNames.clear();
        isShowList = false;
        // isFilteredList=false;
      });
    }
  }

  dynamic GetList() {
    if (categortProduct.length > 0) {
      FilteredProducts.clear();
      for (var item in categortProduct) {
        FilteredProducts.add(item);
      }
      FilteredProducts.removeAt(0);
      return FilteredProducts.length;
    } else if (distance.length > 0) {
      if (filterController.text == "") {
        DistanceProducts.clear();
        for (var item in distance) {
          DistanceProducts.add(item);
        }
        DistanceProducts.removeAt(0);
        return DistanceProducts.length;
      } else {
        return 0;
      }
    }
  }

  _closeLoader() {
    Timer(Duration(seconds: 0), () {
      setState(() {
        isBusy = false;
      });
    });
  }

  productByCategory(String? name) async {
    setState(() {
      isBusy = true;
    });

    for (var item in requests) {
      if (name == item.name) {
        filterController.text = item.name!;
        context.read<ProductsProvider>().getProductbyCategoryId(item.id);
        FocusScope.of(context).unfocus();
        isShowList = false;
        setState(() {
          HeaderImage = item.productCategoryImage!.url;
        });
        // setState(() {
        //   isFilteredList=true;
        // });
      }
    }
    setState(() {
      isBusy = false;
    });
  }

  getBusinessUserProfile(String id, BuildContext ctx) async {
    ctx.read<BusinessUsersProvider>().getBussinessUsers(id);
  }
}

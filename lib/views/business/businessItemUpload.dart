import 'dart:convert';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:e_commerce_foods/controllers/business/addProductController.dart';
import 'package:e_commerce_foods/controllers/business/getCategoriesController.dart';
import 'package:e_commerce_foods/controllers/uploadPicController.dart';
import 'package:e_commerce_foods/controllers/uploadVidController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/business/productAttributeModel.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mime/mime.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

class BusinessItemUpload extends StatefulWidget {
  @override
  _UploadItemState createState() => _UploadItemState();
}

class _UploadItemState extends State<BusinessItemUpload> {
  final GetCategoriesController getCategoriesController =
      Get.put(GetCategoriesController());
  final UploadPicController uploadPicController =
      Get.put(UploadPicController());
  final UploadVidController uploadVidController =
      Get.put(UploadVidController());
  final AddProductController addProductController =
      Get.put(AddProductController());
  void showErrorToast(Message) {
    Fluttertoast.showToast(
        msg: Message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  String newPriceError = "";
  String oldPriceError = "";
  List<File> selectedMedias = [];
  List checkMedia = [];
  int checkPhotoIndex = 0;
  TextEditingController controller = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController newPriceController = TextEditingController();
  TextEditingController oldpriceController = TextEditingController();
  TextEditingController gstController = TextEditingController();
  TextEditingController DescripationController = TextEditingController();
  final picker = ImagePicker();
  PageController pageController = PageController();
  bool _newProfileImage = false;
  File? _profileImage;
  String? _selectedCategory = null;
  bool isbusy = false;
  List<ProductAttributes> productAttributes = [];
  List<AttributeValues> attributeValues = [];
  TextEditingController attributeNameController = TextEditingController();
  TextEditingController attributeValueController = TextEditingController();
  /*var categories = [
    'Food',
    'Travel',
    'Flights',
    'Hotels',
    'Electronics',
    'Games',
    'Home',
    'Beauty',
    'Entertainment',
    'Furniture',
    'Facials',
    'Ticket Events',
    'Cruises',
  ];*/
  //var category = 'Food';

  void showProductErrorToast() {
    Fluttertoast.showToast(
        msg: 'Erroe While Upload Product',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        //timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  @override
  void initState() {
    print("we are in screen");
    super.initState();
  }

  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return ModalProgressHUD(
      inAsyncCall: isUploading,
      progressIndicator: globals.circularIndicator(),
      child: SafeArea(
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
          body: isbusy == true
              ? Container(
                  color: Colors.black,
                  child: Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                    valueColor: new AlwaysStoppedAnimation<Color>(Colors.black),
                  )),
                )
              : Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: width / 1.9,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white,
                              width: 5,
                            ),
                          ),

                          // camera   or  video  icon ////////////////////////////////////////////////////////////////////////////////////////////////////
                          // child: Stack(children: [
                          //   ClipRRect(
                          //       borderRadius: BorderRadius.all(
                          //         Radius.circular(0),
                          //       ),
                          //       child: _newProfileImage
                          //           ? picsListView()
                          //           : Container(
                          //               decoration: BoxDecoration(
                          //                 border: Border.all(
                          //                   color: Colors.white,
                          //                   width: 5,
                          //                 ),
                          //               ),
                          //             )),
                          //   Positioned(
                          //     bottom: 13,
                          //     right: 55,
                          //     child: Opacity(
                          //       opacity: 0.8,
                          //       child: SizedBox(
                          //         width: 30,
                          //         height: 20,

                          //         child: InkWell(
                          //           child:
                          //               Image.asset('assets/cameralord.png'),
                          //           onTap: _getImage,
                          //         ),

                          //         // child: Material(
                          //         //   elevation: 4,
                          //         //   color: Colors.grey,
                          //         //   borderRadius: BorderRadius.circular(40),
                          //         //   child: InkWell(
                          //         //     borderRadius: BorderRadius.circular(40),
                          //         //     child: Padding(
                          //         //       padding: const EdgeInsets.all(4.0),
                          //         //       child: Icon(
                          //         //         Icons.add_a_photo_outlined,
                          //         //         color: Colors.white,
                          //         //       ),
                          //         //     ),
                          //         //     onTap: _getImage,
                          //         //   ),
                          //         // ),
                          //       ),
                          //     ),
                          //   ),
                          //   Positioned(
                          //     bottom: 10,
                          //     right: 15,
                          //     child: Opacity(
                          //       opacity: 0.8,
                          //       child: SizedBox(
                          //         width: 25,
                          //         height: 25,
                          //         child: InkWell(
                          //           child:
                          //               Image.asset('assets/videolord.png'),
                          //           onTap: _getVideo,
                          //         ),

                          //         // child: Material(
                          //         //   elevation: 4,
                          //         //   color: Colors.grey,
                          //         //   borderRadius: BorderRadius.circular(40),
                          //         //   child: InkWell(
                          //         //     borderRadius: BorderRadius.circular(40),
                          //         //     child: Padding(
                          //         //       padding: const EdgeInsets.all(4.0),
                          //         //       // child: Icon(
                          //         //       //   Icons.video_call_outlined,
                          //         //       //   color: Colors.white,
                          //         //       // ),
                          //         //     ),
                          //         //     onTap: _getVideo,
                          //         //   ),
                          //         // ),
                          //       ),
                          //     ),
                          //   )
                          // ])

                          /* child: IconButton(
                            alignment: Alignment.bottomRight,
                            iconSize: 60,
                            icon: Icon(Icons.add_a_photo_outlined),
                            color: Colors.white,
                            onPressed: () {
                              _getImage();
                            },
                          ),*/
                        ),
                        selectedMedias.isNotEmpty && selectedMedias != null
                            ? Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedMedias.clear();
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(top: 10),
                                      child: Text(
                                        'Clear Medias',
                                        style: GoogleFonts.poppins(
                                            fontSize: 14, color: Colors.red),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.only(top: 10, left: 60),
                                    child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: List.generate(
                                            selectedMedias.length,
                                            (index) => Container(
                                                margin: EdgeInsets.all(2),
                                                width: 10,
                                                height: 10,
                                                decoration: BoxDecoration(
                                                  color: checkPhotoIndex == 0 &&
                                                          index == 0
                                                      ? Colors.white
                                                      : checkPhotoIndex == 1 &&
                                                              index == 1
                                                          ? Colors.white
                                                          : checkPhotoIndex ==
                                                                      2 &&
                                                                  index == 2
                                                              ? Colors.white
                                                              : Colors.grey,
                                                  shape: BoxShape.circle,
                                                )))),
                                  ),
                                ],
                              )
                            : Container(),
                        SizedBox(height: 12),
                        Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Upload',
                                style: Global.style(
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: 15),
                              InkWell(
                                child: Column(
                                  children: [
                                    Text(
                                      ' Picture',
                                      style: Global.style(
                                        size: 16,
                                        bold: true,
                                      ),
                                    ),
                                    Container(
                                      width: 50,
                                      height: 1,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                onTap: _getImage,
                              ),
                              SizedBox(width: 15),
                              Text(
                                'or',
                                style: Global.style(
                                  size: 16,
                                ),
                              ),
                              SizedBox(width: 15),
                              InkWell(
                                child: Column(
                                  children: [
                                    Text(
                                      ' Video',
                                      style: Global.style(
                                        size: 16,
                                        bold: true,
                                      ),
                                    ),
                                    Container(
                                      width: 45,
                                      height: 1,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                                onTap: _getVideo,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Name',
                          style: Global.style(
                            bold: true,
                            size: 16,
                          ),
                        ),
                        MyTextField(
                          hint: 'Name',
                          controller: nameController,
                          lines: 1,
                          readOnly: false,
                        ),
                        SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Category',
                              style: Global.style(
                                bold: true,
                                size: 16,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 24),
                        Obx(() {
                          if (getCategoriesController.isLoading.value) {
                            return Center(child: globals.circularIndicator());
                          } else if (getCategoriesController.isListNull.value) {
                            return Center(
                              child: Text(
                                'No Categories Found!',
                                style: Global.style(
                                  bold: false,
                                  size: 20,
                                ),
                              ),
                            );
                          } else {
                            final categories = getCategoriesController
                                .categoryINfo.value.data!;
                            return Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      width: 2, color: Colors.white)),
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 4)),
                                  contentPadding: EdgeInsets.all(10),
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    hint: new Text(
                                      "Select Category",
                                      style: GoogleFonts.poppins(
                                          color: Colors.white70),
                                    ),
                                    underline: Container(
                                      color: Colors.red,
                                    ),
                                    dropdownColor: Colors.black,
                                    iconEnabledColor: Colors.white,
                                    isDense: true,
                                    items: categories.map((item) {
                                      return new DropdownMenuItem<String>(
                                        value: item.id.toString(),
                                        child: new Text(item.name!,
                                            style: Global.style()),
                                      );
                                    }).toList(),
                                    onChanged: (String? newValueSelected) {
                                      setState(() {
                                        this._selectedCategory =
                                            newValueSelected;
                                        print(_selectedCategory);
                                      });
                                    },
                                    value: _selectedCategory,
                                  ),
                                ),
                              ),
                            );
                          }
                        }),
                        SizedBox(height: 24),
                        Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  //  style: BorderStyle.solid,
                                  width: 2,
                                  color: Colors.white)),
                          child: InputDecorator(
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5.0),
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 4)),
                              contentPadding: EdgeInsets.all(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Product Attributes',
                                  style: Global.style(
                                    bold: true,
                                    size: 16,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    attributeValues.clear();
                                    openAttributeDialog();
                                    // String listSTring = jsonEncode(productAttributes);
                                    // print(listSTring);
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),

                        productAttributes.isNotEmpty
                            ? addExtraList()
                            : Container(),
                        SizedBox(height: 24),
                        Text(
                          'Description',
                          style: Global.style(
                            bold: true,
                            size: 16,
                          ),
                        ),
                        MyTextField(
                          hint: 'Description',
                          controller: DescripationController,
                          lines: 3,
                          readOnly: false,
                        ),
                        SizedBox(height: 24),
                        Text(
                          'Price',
                          style: Global.style(
                            bold: true,
                            size: 16,
                          ),
                        ),
                        priceTextField(0, "New Price", newPriceController),
                        // MyTextField(
                        //   hint: 'New Price',
                        //   controller: newPriceController,
                        //   readOnly: false,
                        //   lines: 1,
                        //   type: TextInputType.number,
                        // ),
                        SizedBox(height: 12),
                        priceTextField(1, "Old Price", oldpriceController),
                        // MyTextField(
                        //   hint: 'Old Price',
                        //   controller: oldpriceController,
                        //   readOnly: false,
                        //   lines: 1,
                        //   type: TextInputType.number,
                        // ),
                        SizedBox(height: 12),
                        //
                        // GST textfield ////////////////////////////////////////////////////////////////////
                        // Text(
                        //   'GST',
                        //   style: Global.style(
                        //     bold: true,
                        //     size: 16,
                        //   ),
                        // ),
                        // MyTextField(
                        //   hint: 'General Sale Tax',
                        //   controller: gstController,
                        //   lines: 1,
                        //   readOnly: true,
                        //   type: TextInputType.number,
                        // ),
                        SizedBox(height: 24),
                        Center(
                          child: ConfirmationSlider(
                            onConfirmation: () {
                              print(jsonEncode(productAttributes));
                              CreateProduct();
                              // if (isbusy == true)
                              //   Center(
                              //       child: CircularProgressIndicator(
                              //           backgroundColor: Colors.white,
                              //           valueColor:
                              //               new AlwaysStoppedAnimation<Color>(
                              //                   Colors.black)));
                            },
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            textStyle: Global.style(
                              color: Colors.black,
                              size: 16,
                            ),
                            text: 'Swipe to confirm',
                            height: 50,
                          ),
                        ),
                        // Container(
                        //   height: 45,
                        //   width: double.infinity,
                        //   decoration: BoxDecoration(
                        //     borderRadius: BorderRadius.all(
                        //       Radius.circular(8),
                        //     ),
                        //     color: Colors.white,
                        //     boxShadow: [
                        //       BoxShadow(
                        //         color: Colors.black.withOpacity(0.1),
                        //         blurRadius: 10,
                        //       )
                        //     ],
                        //   ),
                        //   child: ClipRRect(
                        //     borderRadius: BorderRadius.all(
                        //       Radius.circular(8),
                        //     ),
                        //     child:
                        //     MaterialButton(
                        //       onPressed: () {
                        //         CreateProduct();
                        //       },
                        //       child: Text(
                        //         'Confirm',
                        //         textAlign: TextAlign.center,
                        //         style: Global.style(
                        //           color: Colors.black,
                        //           size: 18,
                        //           bold: true,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  Widget addExtraList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 10),
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: productAttributes.length,
      itemBuilder: (context, index) =>
          extraListGet(index, productAttributes[index]),
    );
  }

  Widget extraListGet(int index, ProductAttributes productAttribute) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '${productAttribute.attributeName}',
              style: Global.style(size: 14, bold: true),
            ),
            Spacer(),
            InkWell(
                onTap: () {
                  setState(() {
                    openAddAttributeValueDialog(productAttribute);
                  });
                },
                child: Icon(
                  Icons.add,
                  size: 20,
                  color: Colors.white,
                )),
            SizedBox(
              width: 10,
            ),
            InkWell(
                onTap: () {
                  attributeNameController.text = productAttribute.attributeName;
                  openAttributeUpdateDialog("Update Attribute Name", index, 0);
                },
                child: Icon(
                  Icons.edit_location_outlined,
                  size: 20,
                  color: Colors.white,
                )),
            SizedBox(
              width: 10,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  //productAttributes.removeWhere((attribute) =>  attribute.attributeValues[index]==productAttribute.attributeValues[index]);
                  productAttributes.removeWhere((attribute) =>
                      attribute.attributeName ==
                      productAttribute.attributeName);
                });
              },
              child: Icon(
                Icons.delete_forever,
                color: Colors.white,
              ),
            )
          ],
        ),
        ListView.builder(
          padding: EdgeInsets.only(top: 5),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: productAttribute.attributeValues.length,
          itemBuilder: (context, indexA) => Column(
            children: [
              Row(
                children: [
                  Text(
                    '${productAttribute.attributeValues[indexA]}',
                    style: Global.style(
                      size: 12,
                    ),
                  ),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        attributeNameController.text =
                            productAttribute.attributeValues[indexA];
                        openAttributeUpdateDialog(
                            "Update Attribute Value", index, indexA);
                      },
                      child: Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.white,
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  InkWell(
                      onTap: () {
                        setState(() {
                          //productAttributes[index].attributeValues[indexA] = "ALIuaj";
                          productAttributes[index].attributeValues.removeWhere(
                              (attribute) =>
                                  attribute ==
                                  productAttribute.attributeValues[indexA]);
                          if (productAttributes[index]
                              .attributeValues
                              .isEmpty) {
                            productAttributes.removeWhere((attribute) =>
                                attribute.attributeName ==
                                productAttribute.attributeName);
                          }
                        });
                      },
                      child: Icon(
                        Icons.remove_circle_outline,
                        size: 18,
                        color: Colors.white,
                      )),
                ],
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ],
    );
  }

  void openAddAttributeValueDialog(ProductAttributes productAttribute) {
    showDialog(
      builder: (BuildContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 2)),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Text(
                        "Add Attribute Value for ${productAttribute.attributeName}",
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(children: [
                        MyTextField(
                          hint: 'Attribute Value',
                          controller: attributeNameController,
                          readOnly: false,
                          maxLength: 30,
                        ),
                        SizedBox(height: 12),
                      ]),
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: Global.style(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          height: 35,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                if (attributeNameController.text
                                    .trim()
                                    .isEmpty) {
                                  showErrorToast(
                                      "Please enter Attribute Name!");
                                } else {
                                  if (!productAttribute.attributeValues
                                      .contains(attributeNameController.text
                                          .trim())) {
                                    setState(() {
                                      productAttribute.attributeValues.add(
                                          attributeNameController.text.trim());
                                      attributeNameController.text = "";
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    showErrorToast("Attribute already Exists!");
                                  }
                                }
                              },
                              child: Text(
                                'Add',
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
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        );
      },
      context: context,
    );
  }

  void openAttributeUpdateDialog(String heading, int index, int indexA) {
    showDialog(
      builder: (BuildContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: 250,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 2)),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Text(
                        heading,
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                    SizedBox(height: 12),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(children: [
                        MyTextField(
                          hint: 'Attribute Name',
                          controller: attributeNameController,
                          readOnly: false,
                          maxLength: 30,
                        ),
                        SizedBox(height: 12),
                      ]),
                    ),
                    SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text(
                                'Cancel',
                                textAlign: TextAlign.center,
                                style: Global.style(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          height: 35,
                          width: 90,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20),
                            ),
                            color: Colors.white,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(
                              Radius.circular(8),
                            ),
                            child: MaterialButton(
                              onPressed: () {
                                if (attributeNameController.text
                                    .trim()
                                    .isEmpty) {
                                  showErrorToast(
                                      "Please enter Attribute Name!");
                                } else {
                                  setState(() {
                                    if (heading == "Update Attribute Name") {
                                      if (productAttributes.any((attribute) =>
                                          attribute.attributeName ==
                                          attributeNameController.text
                                              .trim())) {
                                        showErrorToast(
                                            "Attribute Name Already Exists!");
                                      } else {
                                        productAttributes[index].attributeName =
                                            attributeNameController.text.trim();
                                        attributeNameController.text = "";
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      if (productAttributes[index]
                                          .attributeValues
                                          .any((attribute) =>
                                              attribute ==
                                              attributeNameController.text
                                                  .trim())) {
                                        showErrorToast(
                                            "Attribute Value Already Exists!");
                                      } else {
                                        productAttributes[index]
                                                .attributeValues[indexA] =
                                            attributeNameController.text.trim();
                                        attributeNameController.text = "";
                                        Navigator.pop(context);
                                      }
                                    }
                                  });
                                }
                              },
                              child: Text(
                                'Update',
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
                    SizedBox(height: 10),
                  ],
                ),
              );
            },
          ),
        );
      },
      context: context,
    );
  }

  void openAttributeDialog() {
    showDialog(
      builder: (BuildContext) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Container(
                height: 400,
                decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(color: Colors.white, width: 2)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white.withOpacity(0.05),
                              blurRadius: 20,
                              offset: Offset(0, 5),
                            )
                          ],
                        ),
                        child: Text(
                          'Add Attribute',
                          textAlign: TextAlign.center,
                          style: Global.style(),
                        ),
                      ),
                      SizedBox(height: 12),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Column(children: [
                          MyTextField(
                            hint: 'Attribute Name',
                            controller: attributeNameController,
                            readOnly: false,
                            maxLength: 25,
                          ),
                          SizedBox(height: 12),
                          TextFormField(
                            controller: attributeValueController,
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 14),
                            maxLength: 30,
                            decoration: InputDecoration(
                              hintText: "Add Attribute Value",
                              hintStyle: GoogleFonts.poppins(
                                  color: Colors.grey, fontSize: 14),
                              // fillColor: Colors.white,
                              // filled: true,
                              enabledBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.white, width: 1),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 2)),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  if (attributeValues.any((attribute) =>
                                      attribute.attributeValue ==
                                      attributeValueController.text.trim())) {
                                    showErrorToast(
                                        "Attribute Value Already Exists!");
                                  } else {
                                    setState(() {
                                      if (attributeValueController.text
                                          .trim()
                                          .isNotEmpty) {
                                        attributeValues.add(AttributeValues(
                                            attributeValueController.text
                                                .trim()));
                                        attributeValueController.text = "";
                                      } else {
                                        showErrorToast(
                                            "Please add attribute value!");
                                        attributeValueController.text = "";
                                      }
                                    });
                                  }
                                },
                                icon: Icon(Icons.add),
                                color: Colors.white,
                                iconSize: 25,
                                alignment: Alignment.topRight,
                              ),
                            ),
                          ),
                          SizedBox(height: 12),

                          // SizedBox(height: 12),
                          // MyTextField(
                          //   hint: 'Retype New Password',
                          //   controller: retypePasswordController,
                          //   readOnly: false,
                          // ),
                        ]),
                      ),
                      SizedBox(height: 32),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 35,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text(
                                  'Cancel',
                                  textAlign: TextAlign.center,
                                  style: Global.style(
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 16),
                          Container(
                            height: 35,
                            width: 90,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(
                                Radius.circular(20),
                              ),
                              color: Colors.white,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8),
                              ),
                              child: MaterialButton(
                                onPressed: () {
                                  if (attributeNameController.text
                                      .trim()
                                      .isEmpty) {
                                    showErrorToast(
                                        "Please enter Attribute Name!");
                                  } else if (attributeValues.isEmpty) {
                                    showErrorToast(
                                        "Please enter atleast one Attribute Value!");
                                  } else {
                                    if (productAttributes.any((attribute) =>
                                        attribute.attributeName ==
                                        attributeNameController.text.trim())) {
                                      showErrorToast(
                                          "Attribute Name Already Exists!");
                                    } else {
                                      setState(() {
                                        String tempAtt = "";
                                        for (var val in attributeValues) {
                                          tempAtt = tempAtt +
                                              val.attributeValue +
                                              "##";
                                        }
                                        tempAtt = tempAtt.substring(
                                            0, tempAtt.length - 2);
                                        //print(tempAtt);
                                        productAttributes.add(ProductAttributes(
                                            attributeNameController.text.trim(),
                                            tempAtt.split("##")));
                                        attributeNameController.text = "";
                                        //attributeValues.clear();
                                      });
                                      Navigator.pop(context);
                                    }
                                  }
                                },
                                child: Text(
                                  'Save',
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
                      SizedBox(height: 10),
                      Text(
                        'Your Attributes',
                        textAlign: TextAlign.center,
                        style: Global.style(
                          bold: true,
                        ),
                      ),
                      attributeValues.isNotEmpty
                          ? ListView.builder(
                              itemCount: attributeValues.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Text(
                                  attributeValues[index].attributeValue,
                                  textAlign: TextAlign.center,
                                  style: Global.style(size: 10, caps: true),
                                );
                              })
                          : Container(),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
      context: context,
    );
  }

  Widget priceTextField(
      int Index, String HintText, TextEditingController Controller) {
    return TextField(
      style: Global.style(
        size: 16,
      ),
      maxLines: 1,
      controller: Controller,
      obscureText: false,
      cursorColor: Colors.white,
      readOnly: false,
      keyboardType: TextInputType.number,
      onChanged: (newPrice) {
        setState(() {
          if (Index == 0) {
            if (newPriceController.text.isNotEmpty) {
              try {
                gstController.text =
                    ((13 / 100) * double.parse(newPriceController.text))
                        .toStringAsFixed(2);
                newPriceError = "";
              } catch (e) {
                newPriceError = e.toString();
                showErrorToast("Invalid New Price!");
              }
            } else {
              setState(() {
                gstController.text = "";
              });
            }
          } else {
            if (oldpriceController.text.isNotEmpty) {
              try {
                double.parse(oldpriceController.text);
                oldPriceError = "";
              } catch (e) {
                oldPriceError = e.toString();
                showErrorToast("Invalid Old Price!");
              }
            } else {
              setState(() {
                oldpriceController.text = "";
              });
            }
          }
        });
      },
      decoration: InputDecoration(
        hintStyle: Global.style(size: 16, color: Colors.white70),
        hintText: HintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 2),
          borderRadius: const BorderRadius.all(
            const Radius.circular(5.0),
          ),
        ),
        focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 4)),
      ),
    );
  }

  Widget picsListView() {
    return PageView.builder(
      itemCount: selectedMedias.length,
      onPageChanged: (i) {
        setState(() {
          checkPhotoIndex = i;
        });
      },
      controller: pageController,
      itemBuilder: (context, index) =>
          pic_listget(selectedMedias[index], index),
    );
  }

  Widget pic_listget(File selectedMedia, int index) {
    return checkMedia[index] == "image"
        ? Container(
            padding: EdgeInsets.all(5),
            child: Image.file(
              selectedMedia,
              fit: BoxFit.fitWidth,
            ),
          )
        : checkMedia[index] == "video"
            ? AspectRatio(
                aspectRatio: 16.0 / 9.0,
                child: BetterPlayer(
                  controller: BetterPlayerController(
                    BetterPlayerConfiguration(
                      aspectRatio: 16 / 9,
                      autoPlay: true,
                      looping: true,
                      controlsConfiguration: BetterPlayerControlsConfiguration(
                        controlBarColor: Colors.black.withOpacity(0.7),
                      ),
                    ),
                    betterPlayerDataSource: BetterPlayerDataSource(
                      BetterPlayerDataSourceType.file,
                      selectedMedia.path,
                      placeholder: Image.asset(
                        'assets/text.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              )
            : Container();
  }

  void _getImage() async {
    if (selectedMedias.length != 3) {
      List<Media>? res = await ImagesPicker.pick(
        count: selectedMedias.isEmpty ? 3 : 3 - selectedMedias.length,
        pickType: PickType.image,
        language: Language.System,
        quality: 0.4,
        maxSize: 500,
        cropOpt: CropOption(
          aspectRatio: CropAspectRatio.wh4x3,
        ),
      );
      if (res != null) {
        setState(() {
          for (var media in res) {
            selectedMedias.add(File(media.path));
          }
          checkMedia.clear();
          for (var mediaPath in selectedMedias) {
            String mimeStr = lookupMimeType(mediaPath.path)!;
            var fileType = mimeStr.split('/');
            checkMedia.add(fileType[0]);
          }
          if (selectedMedias.isNotEmpty && selectedMedias != null) {
            _newProfileImage = true;
          }
        });
        print("valueee");
      }
    } else {
      showErrorToast(
          "You have selected all the 3 medias.\nTry clear medias to insert again.");
    }
    // final pickedFile = await picker.getImage(
    //     source: ImageSource.gallery, maxHeight: 800, maxWidth: 800);
    // if (pickedFile != null) {
    //   setState(() {
    //     _newProfileImage = true;
    //     _profileImage = File(pickedFile.path);
    //   });
    // }
  }

  void _getVideo() async {
    //selectedMedias.clear();
    setState(() {});
    if (selectedMedias.length != 3) {
      List<Media>? res = await ImagesPicker.pick(
        count: selectedMedias.isEmpty ? 3 : 3 - selectedMedias.length,
        pickType: PickType.video,
        language: Language.System,
        quality: 0.4,
        maxSize: 5000,
        // maxSize: 500,
        cropOpt: CropOption(
          aspectRatio: CropAspectRatio.wh16x9,
        ),
      );
      if (res != null) {
        setState(() {
          for (var media in res) {
            selectedMedias.add(File(media.path));
          }
        });
        print("videooo");
        checkMedia.clear();
        for (var mediaPath in selectedMedias) {
          String mimeStr = lookupMimeType(mediaPath.path)!;
          var fileType = mimeStr.split('/');
          checkMedia.add(fileType[0]);
        }
        if (selectedMedias.isNotEmpty && selectedMedias != null) {
          _newProfileImage = true;
        }
        for (int i = 0; i < checkMedia.length; i++) {
          print(checkMedia[i].toString() + "checkMediaLenght");
        }
      }
    } else if (selectedMedias.length == 3) {
      showErrorToast("You have only selected 3 medias");
    }
    // else {
    //   showErrorToast("Please select atleast one photo first.");
    // }
  }

  Future<bool> validate() async {
    if (nameController.text.isEmpty) {
      showErrorToast("Please enter the name of product");
      return false;
    }
    if (selectedMedias.isEmpty) {
      showErrorToast("Please enter image");
      return false;
    }
    if (DescripationController.text.isEmpty) {
      showErrorToast("please enter subscription");
      return false;
    }
    if (DescripationController.text.contains("@") ||
        DescripationController.text.contains("#") ||
        DescripationController.text.contains("%") ||
        DescripationController.text.contains("\$") ||
        DescripationController.text.contains("&")) {
      showErrorToast(
          "Remove Any specail chracter from Description\n(@ # % \$ &) etc. ");
      return false;
    }
    if (oldpriceController.text.isEmpty) {
      showErrorToast("please enter old price");
      return false;
    }
    if (newPriceError != "") {
      showErrorToast("Invalid New Price!");
      return false;
    }
    if (oldPriceError != "") {
      showErrorToast("Invalid old Price!");
      return false;
    }
    if (newPriceController.text.isEmpty) {
      showErrorToast("please enter new price");
      return false;
    }
    if (gstController.text.isEmpty) {
      showErrorToast("please enter new gst");
      return false;
    }
    if (_selectedCategory == null) {
      showErrorToast("please select category");
      return false;
    }
    return true;
  }

  CreateProduct() async {
    if (!await validate()) {
      return;
    } else {
      try {
        Map<String, String> picture;
        String medias = "";
        final List<Map<String, Object>> myPistureList = [];
        setState(() {
          isUploading = true;
        });
        //var file = await context.read<ProductsProvider>().productUpload(_profileImage);
        //var file = await context.read<ProductsProvider>().productUpload2(_profileImages);
        List<Map<String, Object>> fileData = [];
        for (var file in selectedMedias) {
          String mimeStr = lookupMimeType(file.path)!;
          var fileType = mimeStr.split('/');
          if (fileType[0] == "image") {
            uploadPicController.fetchPic(
                file, file.path.split("/").last.toString(), 4, "Product Image");
            if (uploadPicController.picINfo.value.status == 200) {
              medias = medias + uploadPicController.picINfo.value.data! + ",";
            } else {
              globals.showErrorToast("Upload Images Error!");
            }

            ////by me
          } else if (fileType[0] == "video") {
            uploadVidController.fetchVid(
                file, file.path.split("/").last.toString(), 4, "Product Video");
            if (uploadVidController.vidINfo.value.status == 200) {
              medias = medias + uploadVidController.vidINfo.value.data! + ",";
            } else {
              print("here in else");
              globals.showErrorToast("Upload Video Error!");
            }
          }
        }
        medias = medias.substring(0, medias.length - 1);
        print("photos123");
        print(medias);
        setState(() {
          isUploading = false;
        });
        Map userData = {
          'name': nameController.text,
          'old_price': oldpriceController.text,
          'new_price': newPriceController.text,
          'gst': gstController.text,
          'description': DescripationController.text,
          'product_id': _selectedCategory,
          'product_images': medias,
          'product_attributes': jsonEncode(productAttributes)
        };
        await addProductController.fetchProduct(userData);
      } catch (err) {
        setState(() {
          isbusy = false;
          isUploading = false;
        });
        globals.showErrorSnackBar(
            "Item is not uploaded: Error(" + err.toString() + ")");
        print(err);
      }
    }
  }
}

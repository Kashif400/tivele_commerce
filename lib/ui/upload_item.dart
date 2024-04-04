import 'dart:async';
import 'dart:io';

import 'package:better_player/better_player.dart';
import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/productCategory.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/service/product/product_service.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_1.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:images_picker/images_picker.dart';
import 'package:mime/mime.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:slide_to_confirm/slide_to_confirm.dart';

import 'home/my_profile.dart';

class UploadItem extends StatefulWidget {
  @override
  final String? businessAccountId;
  const UploadItem(this.businessAccountId);
  _UploadItemState createState() => _UploadItemState();
}

class _UploadItemState extends State<UploadItem> {
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
  String? _selectedCategory;
  bool isbusy = false;

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
    print(widget.businessAccountId);
    super.initState();
    context.read<ProductsCategoryProvider>().getProductCategory();
  }

  bool isUploading = false;
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    final categorys = context.watch<ProductsCategoryProvider>().category;
    return ModalProgressHUD(
      inAsyncCall: isUploading,
      progressIndicator: CircularProgressIndicator(
          backgroundColor: Colors.black.withOpacity(0.8),
          valueColor:
              new AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(1))),
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
                            /*decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white,
                          width: 5,
                        ),
                      ),*/
                            child: Stack(children: [
                              ClipRRect(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(0),
                                  ),
                                  child: _newProfileImage
                                      ? picsListView()
                                      : Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 5,
                                            ),
                                          ),
                                        )),
                              Positioned(
                                bottom: 0,
                                right: 50,
                                child: Opacity(
                                  opacity: 0.8,
                                  child: SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: Material(
                                      elevation: 4,
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(40),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.add_a_photo_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: _getImage,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Opacity(
                                  opacity: 0.8,
                                  child: SizedBox(
                                    width: 42,
                                    height: 42,
                                    child: Material(
                                      elevation: 4,
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(40),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(40),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Icon(
                                            Icons.video_call_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                        onTap: _getVideo,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ])

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
                        Align(
                          alignment: Alignment.center,
                          child: Text(
                            'Upload Picture or Video',
                            style: Global.style(
                              size: 16,
                            ),
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
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border:
                                  Border.all(width: 2, color: Colors.white)),
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
                                items: categorys.map((item) {
                                  return new DropdownMenuItem<String>(
                                    value: item.id.toString(),
                                    child: new Text(item.name!,
                                        style: Global.style()),
                                  );
                                }).toList(),
                                onChanged: (String? newValueSelected) {
                                  setState(() {
                                    this._selectedCategory = newValueSelected;
                                  });
                                },
                                value: _selectedCategory,
                              ),
                            ),
                          ),
                        ),
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
                        Text(
                          'GST',
                          style: Global.style(
                            bold: true,
                            size: 16,
                          ),
                        ),
                        MyTextField(
                          hint: 'General Sale Tax',
                          controller: gstController,
                          lines: 1,
                          readOnly: true,
                          type: TextInputType.number,
                        ),
                        SizedBox(height: 24),
                        Center(
                          child: ConfirmationSlider(
                            onConfirmation: () {
                              CreateProduct();
                              if (isbusy == true)
                                Center(
                                    child: CircularProgressIndicator(
                                        backgroundColor: Colors.white,
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Colors.black)));
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
        ? Image.file(
            selectedMedia,
            fit: BoxFit.fitWidth,
            height: MediaQuery.of(context).size.width / 1.3 - 25,
            width: 50,
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

  // Widget pic_listget(File selectedMedia, int index) {
  //   return checkMedia[index] == "image"
  //       ? Container(
  //           padding: EdgeInsets.all(5),
  //           child: Image.file(
  //             selectedMedia,
  //             fit: BoxFit.fitWidth,
  //           ),
  //         )
  //       : checkMedia[index] == "video"
  //           ? AspectRatio(
  //               aspectRatio: 16.0 / 9.0,
  //               child: BetterVideoPlayer(
  //                 controller: BetterVideoPlayerController(),
  //                 // Controller manages the video playback
  //                 configuration: BetterVideoPlayerConfiguration(
  //                   placeholder: Image.asset(
  //                     'assets/text.png',
  //                     fit: BoxFit.contain,
  //                   ),
  //                 ), // Configuration for video player appearance and behavior
  //                 dataSource: BetterVideoPlayerDataSource(
  //                     BetterVideoPlayerDataSourceType.file, selectedMedia.path),
  //                 isFullScreen: false,
  //               ),
  //             )
  //           : Container();
  // }

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
    if (selectedMedias.isNotEmpty && selectedMedias.length != 3) {
      List<Media>? res = await ImagesPicker.pick(
        count: 3 - selectedMedias.length,
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
        for (int i = 0; i < checkMedia.length; i++) {
          print(checkMedia[i]);
        }
      }
    } else if (selectedMedias.length == 3) {
      showErrorToast("You have only selected 3 medias");
    } else {
      showErrorToast("Please select atleast one photo first.");
    }
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
    if (!await validate()) return;
    try {
      Map<String, String> picture;
      String description = "";
      final List<Map<String, Object>> myPistureList = [];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getInt("userId").toString();
      setState(() {
        isUploading = true;
      });
      //var file = await context.read<ProductsProvider>().productUpload(_profileImage);
      //var file = await context.read<ProductsProvider>().productUpload2(_profileImages);
      List<Map<String, Object>?> fileData = [];
      for (var file in selectedMedias) {
        fileData.add(await (context.read<ProductsProvider>().productUpload(file)
            as FutureOr<Map<String, Object>?>));
      }
      print(fileData);
      for (int i = 0; i < fileData.length; i++) {
        description = description + (fileData[i]!["url"] as String) + "@#@#@";
      }
      description = description + DescripationController.text;
      List des = description.split("@#@#@");
      print('Split description: ' + des[des.length - 1].toString());
      setState(() {
        isUploading = false;
      });
      var product = {
        'name': nameController.text,
        'oldPrice': oldpriceController.text,
        'newPrice': newPriceController.text,
        'gst': gstController.text,
        'description': description,
        'productCategoryId': _selectedCategory,
        'productImageId': fileData[0]!["id"],
        'businessAccountId': widget.businessAccountId,
        'productViewedCount': 0,
        'productRequestedCount': 0
      };
      print(product);
      var res = await ProductService.create(product);
      // for(int i = 0 ; i < _profileImages.length; i++){
      //   myPistureList.add({
      //     "userId": int.parse(userId),
      //     "productId": res["id"].toString(),
      //     "fileId": file[i]["id"].toString()
      //   });
      // }
      // print(myPistureList);
      // print(json.encode(myPistureList));
      // var pic = await ProductService.uploadPics(myPistureList);
      print(res);
      print('Uploaded Success');
      if (res) {
        setState(() {
          isUploading = false;
        });
        setState(() {
          isbusy = true;
        });
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => MyProfile(widget.businessAccountId),
          ),
          //  (_) => true,
        );
      } else {
        setState(() {
          isbusy = false;
          isUploading = false;
        });
      }
    } catch (err) {
      // final requestbody = json.decode(err.body);
      // final data = requestbody['error'];
      // showErrorToast(data["message"]);
      showErrorToast(err.toString());
      setState(() {
        isbusy = false;
        isUploading = false;
      });
      print(err);
    }
  }
}

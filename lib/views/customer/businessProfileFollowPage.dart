import 'dart:io';

import 'package:e_commerce_foods/URLS.dart';
import 'package:e_commerce_foods/controllers/customer/businessFollowController.dart';
import 'package:e_commerce_foods/controllers/customer/getBusinessProfileByIdController.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/GlobalProperties/GlobalProperties.dart';
import 'package:e_commerce_foods/models/productModel.dart';
import 'package:e_commerce_foods/service/account/userProfile_service.dart';
import 'package:e_commerce_foods/service/account/user_service.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_2.dart';
import 'package:e_commerce_foods/views/business/businessLoginPage.dart';
import 'package:e_commerce_foods/views/customer/customerDetailPage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:images_picker/images_picker.dart';
import 'package:location/location.dart';
import 'package:mime/mime.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusinessProfileFollowPage extends StatefulWidget {
  @override
  // String businessAccountId;
  // BusinessProfilePage(this.businessAccountId);
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<BusinessProfileFollowPage> {
  String? businessId = Get.arguments[0];
  TextEditingController controller = TextEditingController();
  final GetBusinessProfileByIdController getBusinessProfileByIdController =
      Get.put(GetBusinessProfileByIdController());
  final BusinessFollowController businessFollowController =
      Get.put(BusinessFollowController());
  bool remember = false;
  late File ProfileImage;
  bool isGalleryImage = false;
  bool isBusy = false;
  String? ImageId;
  String? myImage;
  bool isImageUpload = false;
  late bool serviceEnabled;
  PermissionStatus? _permissionGranted;
  Location location = new Location();
  bool checkLocation = true;
  // context.read<ProductsProvider>().getProductByBusiness(widget.businessAccountId);

  @override
  initState() {
    super.initState();
    getData();
  }

  getData() async {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      print(businessId);
      if (businessId != null) {
        getBusinessProfileByIdController
            .fetchGetBusinessProfileByIdData(businessId!);
      }
    });
  }

  _pressed(String? businessId) async {
    Map userData = {
      'business_id': businessId,
    };
    await businessFollowController.fetchAddFollow(userData);
    if (businessFollowController.addFollowINfo.value.status == 200) {
      print(businessFollowController.addFollowINfo.value.data);
      if (businessFollowController.addFollowINfo.value.data ==
          "Business Followed Successfully") {
        setState(() {
          getBusinessProfileByIdController.businessINfo.value.data!.followers =
              (int.parse(getBusinessProfileByIdController
                          .businessINfo.value.data!.followers!) +
                      1)
                  .toString();
        });
      } else {
        setState(() {
          getBusinessProfileByIdController.businessINfo.value.data!.followers =
              (int.parse(getBusinessProfileByIdController
                          .businessINfo.value.data!.followers!) -
                      1)
                  .toString();
        });
      }
    } else {
      getBusinessProfileByIdController.businessINfo.value.data!.isFollowed =
          !getBusinessProfileByIdController
              .businessINfo.value.data!.isFollowed!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          leading: Container(),
          title: Obx(() {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                getBusinessProfileByIdController.isLoading.value
                    ? Text(
                        "Business Name",
                        style: Global.style(
                          size: 18,
                        ),
                      )
                    : Text(
                        getBusinessProfileByIdController
                            .businessINfo.value.data!.name!,
                        style: Global.style(
                          size: 18,
                        ),
                      ),
                SizedBox(width: 4),
                !getBusinessProfileByIdController.isLoading.value
                    ? Icon(
                        getBusinessProfileByIdController
                                    .businessINfo.value.data!.isReputable ==
                                "1"
                            ? Icons.verified
                            : null,
                        color: Colors.blue,
                      )
                    : Icon(
                        null,
                        color: Colors.blue,
                      )
              ],
            );
          }),
          centerTitle: true,
        ),
        body: Obx(() {
          if (getBusinessProfileByIdController.isLoading.value) {
            return Center(child: globals.circularIndicator());
          } else if (getBusinessProfileByIdController.isListNull.value) {
            return Center(
              child: Text(
                'No data found!',
                style: Global.style(
                  bold: true,
                  size: 18,
                ),
              ),
            );
          } else {
            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: ModalProgressHUD(
                inAsyncCall: isImageUpload,
                progressIndicator: CircularProgressIndicator(
                    backgroundColor: Colors.black.withOpacity(0.8),
                    valueColor:
                        new AlwaysStoppedAnimation<Color>(Colors.white)),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    border: Border.all(
                                      color: Colors
                                          .white, //bsUser.businessAccountImage.url,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(50),
                                    ),
                                    child: Image.network(
                                      URLS.BASEURL +
                                          getBusinessProfileByIdController
                                              .businessINfo
                                              .value
                                              .data!
                                              .businessImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Text(
                                  getBusinessProfileByIdController
                                      .businessINfo.value.data!.products!.length
                                      .toString(),
                                  style: Global.style(),
                                ),
                                Text(
                                  'Posts',
                                  style: Global.style(),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Text(
                                  getBusinessProfileByIdController
                                      .businessINfo.value.data!.followers!,
                                  style: Global.style(),
                                ),
                                Text(
                                  'Followers',
                                  style: Global.style(),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Column(
                              children: [
                                Text(
                                  getBusinessProfileByIdController
                                      .businessINfo.value.data!.likes!,
                                  style: Global.style(),
                                ),
                                Text(
                                  'Likes',
                                  style: Global.style(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20, right: 20),
                        child: SizedBox(
                          height: 40,
                          width: MediaQuery.of(context).size.width,
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                getBusinessProfileByIdController
                                        .businessINfo.value.data!.isFollowed =
                                    !getBusinessProfileByIdController
                                        .businessINfo.value.data!.isFollowed!;
                              });
                              _pressed(getBusinessProfileByIdController
                                  .businessINfo
                                  .value
                                  .data!
                                  .products![0]
                                  .businessId);
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    !getBusinessProfileByIdController
                                            .businessINfo
                                            .value
                                            .data!
                                            .isFollowed!
                                        ? Colors.blueAccent
                                        : Colors.black,
                                side: BorderSide(
                                  width: 2.0,
                                  color: !getBusinessProfileByIdController
                                          .businessINfo.value.data!.isFollowed!
                                      ? Colors.blueAccent
                                      : Colors.white,
                                )),
                            child: Text(
                              getBusinessProfileByIdController
                                      .businessINfo.value.data!.isFollowed!
                                  ? 'Followed'
                                  : 'Follow',
                              style: Global.style(
                                bold: true,
                                size: 15,
                              ),
                            ),
                          ),
                        ),
                      ),
//                Row(
//                  mainAxisAlignment: MainAxisAlignment.end,
//                  children: [
//                    Container(
//                      height: 28,
//                      decoration: BoxDecoration(
//                        borderRadius: BorderRadius.all(
//                          Radius.circular(8),
//                        ),
//                        color: Colors.blue,
//                        boxShadow: [
//                          BoxShadow(
//                            color: Colors.black.withOpacity(0.1),
//                            blurRadius: 10,
//                          )
//                        ],
//                      ),
//                      child: ClipRRect(
//                        borderRadius: BorderRadius.all(
//                          Radius.circular(8),
//                        ),
//                        child: MaterialButton(
//                          onPressed: () {},
//                          child: Text('Follow',
//                              textAlign: TextAlign.center,
//                              style: Global.style()),
//                        ),
//                      ),
//                    ),
//                  ],
//                ),
                      SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Text(
                          //   'My Profile',
                          //   style: Global.style(
                          //     bold: true,
                          //     size: 18,
                          //   ),
                          // ),
                          // InkWell(
                          //   onTap: () {
                          //     Navigator.of(context).push(
                          //       MaterialPageRoute(
                          //         builder: (_) => EditProfiles(url:bsUser.businessAccountImage.url,id:widget.businessAccountId),
                          //       ),
                          //     );
                          //   },
                          //   child: Text(
                          //     'Edit',
                          //     style: Global.style(
                          //       bold: true,
                          //       size: 18,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                      SizedBox(height: 12),
                      Text(
                        getBusinessProfileByIdController
                            .businessINfo.value.data!.description!,
                        style: Global.style(),
                      ),
                      SizedBox(height: 16),
                      // ListView.builder(
                      //     physics: NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //    itemBuilder: (context, index) {
                      //
                      //   return index == 0
                      //           ?
                      //               GestureDetector(
                      //                   onTap: () {
                      //                     Navigator.of(context).push(
                      //                       MaterialPageRoute(
                      //                         builder: (_) => UploadItem(widget.businessAccountId),
                      //                       ),
                      //                     );
                      //                   },
                      //                   child: Container(
                      //                     height: double.infinity,
                      //                     width: double.infinity,
                      //                     decoration: BoxDecoration(
                      //                       border: Border.all(
                      //                         color: Colors.white,
                      //                         width: 3,
                      //                       ),
                      //                     ),
                      //                     child: Center(
                      //                         child: Icon(
                      //                       Icons.add,
                      //                       color: Colors.white,
                      //                       size: 60,
                      //                     )),
                      //                   ),
                      //                 ):
                      //   GridView.builder(
                      //     physics: NeverScrollableScrollPhysics(),
                      //     shrinkWrap: true,
                      //     itemCount:requests.length,
                      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //       crossAxisCount: 3,
                      //       crossAxisSpacing: 4,
                      //       mainAxisSpacing: 4,
                      //       childAspectRatio: 1,
                      //     ),
                      //     itemBuilder: (context, index) {
                      //     return  GestureDetector(
                      //               onTap: () {
                      //                 Navigator.of(context).push(
                      //                   MaterialPageRoute(
                      //                     builder: (_) => ItemDetails(id:requests[index].id),
                      //                   ),
                      //                 );
                      //               },
                      //               child: Container(
                      //                 child: ClipRRect(
                      //                   borderRadius: BorderRadius.all(
                      //                     Radius.circular(0),
                      //                   ),
                      //                   child: Image.network(
                      //                     requests[index].productImage == null
                      //                         ?'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg'
                      //                         :requests[index].productImage.url,
                      //                     //'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg',
                      //                     fit: BoxFit.cover,
                      //                   ),
                      //                 ),
                      //               ),
                      //             );
                      //     },
                      //   );
                      //
                      // })
                      GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: getBusinessProfileByIdController
                            .businessINfo.value.data!.products!.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 4,
                          mainAxisSpacing: 4,
                          childAspectRatio: 1,
                        ),
                        itemBuilder: (context, index) {
                          var productId = getBusinessProfileByIdController
                              .businessINfo.value.data!.products![index].id;
                          var imageList = getBusinessProfileByIdController
                              .businessINfo
                              .value
                              .data!
                              .products![index]
                              .productImages!
                              .split(",");
                          String productImage;
                          String mimeStr = lookupMimeType(imageList[0])!;
                          var fileType = mimeStr.split('/');

                          return GestureDetector(
                            onTap: () async {
                              print("TAPPED BADAR");
                              List<ProductM> productD = [];
                              productD.add(ProductM(
                                  getBusinessProfileByIdController.businessINfo
                                      .value.data!.products![index].id,
                                  getBusinessProfileByIdController.businessINfo
                                      .value.data!.products![index].businessId,
                                  getBusinessProfileByIdController
                                      .businessINfo
                                      .value
                                      .data!
                                      .products![index]
                                      .categoryName,
                                  getBusinessProfileByIdController.businessINfo
                                      .value.data!.products![index].name,
                                  getBusinessProfileByIdController.businessINfo
                                      .value.data!.products![index].description,
                                  getBusinessProfileByIdController
                                      .businessINfo
                                      .value
                                      .data!
                                      .products![index]
                                      .productImages,
                                  getBusinessProfileByIdController.businessINfo
                                      .value.data!.products![index].status,
                                  double.parse(getBusinessProfileByIdController
                                      .businessINfo
                                      .value
                                      .data!
                                      .products![index]
                                      .newPrice!),
                                  double.parse(
                                      getBusinessProfileByIdController.businessINfo.value.data!.products![index].oldPrice!),
                                  double.parse(getBusinessProfileByIdController.businessINfo.value.data!.tiveleFee!),
                                  double.parse(getBusinessProfileByIdController.businessINfo.value.data!.gstAmount!),
                                  double.parse(getBusinessProfileByIdController.businessINfo.value.data!.shippingCost!),
                                  getBusinessProfileByIdController.businessINfo.value.data!.products![index].latitude,
                                  getBusinessProfileByIdController.businessINfo.value.data!.products![index].longitude));
                              await checkLocationPermissionForRefresh();
                              if (checkLocation) {
                                Get.to(CustomerDetailPage(), arguments: [
                                  productD,
                                  int.parse(getBusinessProfileByIdController
                                      .businessINfo
                                      .value
                                      .data!
                                      .products![index]
                                      .likes!),
                                  getBusinessProfileByIdController.businessINfo
                                      .value.data!.products![index].rating,
                                  true
                                ]);
                              }
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(0),
                                ),
                                child: fileType[0] == "image"
                                    ? Image.network(
                                        URLS.BASEURL + imageList[0],
                                        fit: BoxFit.cover,
                                      )
                                    : Image.asset(
                                        "assets/text.png",
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
            );
          }
        }),
      ),
    );
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

  _getImage() async {
    List<Media>? res = await ImagesPicker.pick(
      count: 1,
      pickType: PickType.image,
      language: Language.System,
      quality: 0.4,
      maxSize: 500,
      cropOpt: CropOption(
        aspectRatio: CropAspectRatio.custom,
      ),
    );
    if (res != null) {
      setState(() {
        isImageUpload = true;
        ProfileImage = File(res[0].path);
      });
      _UploadProfilePicture(ProfileImage);
    } else {
      showErrorToast("Error occured while upload file");
      setState(() {
        isImageUpload = false;
        isBusy = false;
      });
    }
  }

  _UploadProfilePicture(File imageFile) async {
    setState(() {
      isBusy = true;
    });
    var response = await UserProfileService.saveProfilePicture(imageFile);
    if (response != null) {
      setState(() {
        GlobalProperties.defaultProfileImageUrl = response["url"];
      });
      ImageId = response["id"];
      _UpdateProfile(ImageId);
    } else {
      setState(() {
        showErrorToast("Error occured while upload file");
        isImageUpload = false;
        isBusy = false;
      });
    }
  }

  _UpdateProfile(String? ImageId) async {
    var imageid = {"userProfileId": ImageId};
    var response = await UserService.updateProfile(imageid);
    if (response) {
      _GetProfile();
    } else {
      setState(() {
        showErrorToast("Error occured while upload file");
        isImageUpload = false;
        isBusy = false;
      });
    }
  }

  _GetProfile() async {
    var response = await UserService.getProfile();
    if (response != null) {
      var profileData = response["userProfile"];
      var url = profileData["url"];
      setState(() {
        GlobalProperties.defaultProfileImageUrl = url;
        SessionService.setProfileImageUrl(url);
        isBusy = false;
        isGalleryImage = true;
        isImageUpload = false;
      });
    } else {
      setState(() {
        showErrorToast("Error occured while upload file");
        isImageUpload = false;
        isBusy = false;
      });
    }
  }

  void openChangePasswordDialog() {
    TextEditingController currentPasswordController = TextEditingController();
    TextEditingController newPasswordController = TextEditingController();
    TextEditingController retypePasswordController = TextEditingController();

    showDialog(
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (_, __) {
              return Container(
                height: 350,
                color: Colors.black,
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
                        'Change Password',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                    SizedBox(height: 24),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Column(children: [
                        MyTextField(
                          hint: 'Current Password',
                          controller: currentPasswordController,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'New Password',
                          controller: newPasswordController,
                        ),
                        SizedBox(height: 12),
                        MyTextField(
                          hint: 'Retype New Password',
                          controller: retypePasswordController,
                        ),
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
                              onPressed: () {},
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
                              onPressed: () {},
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
                    )
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

  void openLogoutDialog() {
    showDialog(
      builder: (BuildContext context) {
        return Dialog(
          insetPadding: EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: StatefulBuilder(
            builder: (_, __) {
              return Container(
                color: Colors.black,
                height: 200,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.white.withOpacity(0.2),
                            blurRadius: 20,
                            offset: Offset(0, 5),
                          )
                        ],
                      ),
                      child: Text(
                        'Logout',
                        textAlign: TextAlign.center,
                        style: Global.style(),
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      'Are you sure you want\nto logout?',
                      textAlign: TextAlign.center,
                      style: Global.style(),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 35,
                          width: 70,
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
                              onPressed: () async {
                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                prefs.clear();
                                Navigator.of(context).pop();
                                Get.offAll(BusinessLoginPage());
                              },
                              child: Text(
                                'Yes',
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
                          width: 70,
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
                              onPressed: () {},
                              child: Text(
                                'No',
                                textAlign: TextAlign.center,
                                style: Global.style(
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    )
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

  checkLocationPermissionForRefresh() async {
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        Get.snackbar("Notification",
            "Please Enable your GPS/Location first to get nearby goods/order",
            icon: Icon(
              Icons.error_outline,
              color: Colors.white,
            ),
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.red,
            colorText: Colors.white, snackbarStatus: (status) {
          print(status);
          if (status == SnackbarStatus.CLOSED) {
            //Get.offAll(CustomerHomePage());
          }
        });
        setState(() {
          checkLocation = false;
        });
      } else {
        _permissionGranted = await location.hasPermission();
        if (_permissionGranted == PermissionStatus.denied) {
          _permissionGranted = await location.requestPermission();
          if (_permissionGranted != PermissionStatus.granted) {
            Get.snackbar("Notification",
                "Please Enable your GPS/Location first to get nearby goods/order",
                icon: Icon(
                  Icons.error_outline,
                  color: Colors.white,
                ),
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.red,
                colorText: Colors.white, snackbarStatus: (status) {
              print(status);
              if (status == SnackbarStatus.CLOSED) {}
            });
            setState(() {
              checkLocation = false;
            });
          } else {
            setState(() {
              checkLocation = true;
            });
          }
        } else {
          setState(() {
            checkLocation = true;
          });
        }
      }
    } else {
      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != PermissionStatus.granted) {
          Get.snackbar("Notification",
              "Please Enable your GPS/Location first to get nearby goods/order",
              icon: Icon(
                Icons.error_outline,
                color: Colors.white,
              ),
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.red,
              colorText: Colors.white, snackbarStatus: (status) {
            print(status);
            if (status == SnackbarStatus.CLOSED) {
              //Get.offAll(CustomerHomePage());
            }
            setState(() {
              checkLocation = false;
            });
          });
        } else {
          setState(() {
            checkLocation = true;
          });
        }
      } else {
        setState(() {
          checkLocation = true;
        });
      }
    }
  }
}

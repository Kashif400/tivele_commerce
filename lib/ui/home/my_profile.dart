import 'dart:io';

import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/GlobalProperties/GlobalProperties.dart';
import 'package:e_commerce_foods/service/account/userProfile_service.dart';
import 'package:e_commerce_foods/service/account/user_service.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/auth/login_user.dart';
import 'package:e_commerce_foods/ui/item_details.dart';
import 'package:e_commerce_foods/ui/sidebar/card.dart';
import 'package:e_commerce_foods/ui/sidebar/contact_us.dart';
import 'package:e_commerce_foods/ui/sidebar/my_orders.dart';
import 'package:e_commerce_foods/ui/textfield_widgets/textfield_2.dart';
import 'package:e_commerce_foods/ui/upload_item.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:images_picker/images_picker.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  @override
  String? businessAccountId;
  MyProfile(this.businessAccountId);
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController controller = TextEditingController();
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  bool remember = false;
  late File ProfileImage;
  bool isGalleryImage = false;
  bool isBusy = false;
  String? ImageId;
  String? myImage;
  bool isImageUpload = false;
  // context.read<ProductsProvider>().getProductByBusiness(widget.businessAccountId);

  @override
  initState() {
    super.initState();
    getData();
  }

  getData() async {
    setState(() {
      isBusy = true;
    });
    await context
        .read<ProductsProvider>()
        .getProductByBusiness(widget.businessAccountId);
    await context
        .read<BusinessUsersProvider>()
        .getBussinessUsers(widget.businessAccountId!);
    setState(() {
      isBusy = false;
    });
  }

  @override
  Future<void> didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    // await context.read<ProductsProvider>().getProductByBusiness(widget.businessAccountId);
  }

  var products = [];
  // int GetList()
  // {
  //   if(products.length>0)
  //   {
  //     get.clear();
  //     for(var item in distance)
  //     {
  //       DistanceProducts.add(item);
  //     }
  //     DistanceProducts..removeAt(0);
  //     return DistanceProducts.length;
  //   }

  //}

  // ignore: top_level_instance_method
  //final requests = watch<ProductsProvider>().getProduct();
  @override
  Widget build(BuildContext context) {
    final bsUser = context.watch<BusinessUsersProvider>().users;
    final requests = context.watch<ProductsProvider>().product;
    String image =
        'https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg';
    return isBusy
        ? Center(
            child: CircularProgressIndicator(
                valueColor: new AlwaysStoppedAnimation<Color>(Colors.black)))
        : SafeArea(
            child: Scaffold(
              key: scaffoldKey,
              backgroundColor: Colors.black,
              appBar: AppBar(
                elevation: 0,
                backgroundColor: Colors.black,
                leading: Container(),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      bsUser!.name == null ? "Tivele" : bsUser.name!,
                      style: Global.style(
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.verified,
                      color: Colors.blue,
                    )
                  ],
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 32,
                    ),
                    onPressed: () {
                      scaffoldKey.currentState!.openDrawer();
                    },
                  )
                ],
              ),
              drawer: Drawer(
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: Colors.white,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          'Kondravich',
                          style: Global.style(
                            bold: true,
                            size: 20,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.white,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  MyProfile(widget.businessAccountId),
                            ),
                          );
                        },
                        leading: Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                        title: Text(
                          'My Profile',
                          style: Global.style(),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.white,
                      ),
                      ListTile(
                        onTap: openChangePasswordDialog,
                        leading: Icon(
                          Icons.lock_outline,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Change Password',
                          style: Global.style(),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.white,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PaymentCard(),
                            ),
                          );
                        },
                        leading: Icon(
                          Icons.credit_card_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Saved Cards',
                          style: Global.style(),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.white,
                      ),
                      ListTile(
                        tileColor: Colors.white,
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MyOrders(),
                            ),
                          );
                        },
                        title: Text(
                          'My Orders',
                          style: Global.style(
                            color: Colors.black,
                            size: 16,
                            bold: true,
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.white,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.of(context).pop();
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => Contact(),
                            ),
                          );
                        },
                        leading: Icon(
                          Icons.call_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Contact Us',
                          style: Global.style(),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.white,
                      ),
                      ListTile(
                        onTap: openLogoutDialog,
                        leading: Icon(
                          Icons.exit_to_app_outlined,
                          color: Colors.white,
                        ),
                        title: Text(
                          'Logout',
                          style: Global.style(),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
              body: bsUser.businessAccountImage == null
                  ? Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              new AlwaysStoppedAnimation<Color>(Colors.black)))
                  : Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: ModalProgressHUD(
                        inAsyncCall: isImageUpload,
                        progressIndicator: CircularProgressIndicator(
                            backgroundColor: Colors.black.withOpacity(0.8),
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                Colors.white)),
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
                                        InkWell(
                                          onTap: () {
                                            _getImage();
                                          },
                                          child: Container(
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
                                              child: isGalleryImage
                                                  ? Image.file(
                                                      ProfileImage,
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.network(
                                                      GlobalProperties
                                                          .profileImageUrl!,
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Edit',
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
                                          bsUser.productCount.toString(),
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
                                          bsUser.followCount.toString(),
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
                                          bsUser.likeCount.toString(),
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'My Profile',
                                    style: Global.style(
                                      bold: true,
                                      size: 18,
                                    ),
                                  ),
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
                                bsUser.description!,
                                style: Global.style(),
                              ),
                              SizedBox(height: 12),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          UploadItem(widget.businessAccountId),
                                    ),
                                  );
                                },
                                child: Container(
                                  height: 100,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.white,
                                      width: 3,
                                    ),
                                  ),
                                  child: Center(
                                      child: Icon(
                                    Icons.add,
                                    color: Colors.white,
                                    size: 60,
                                  )),
                                ),
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
                                itemCount: requests.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  return
                                      // index == 0
                                      //   ?
                                      //       GestureDetector(
                                      //           onTap: () {
                                      //             Navigator.of(context).push(
                                      //               MaterialPageRoute(
                                      //                 builder: (_) => UploadItem(widget.businessAccountId),
                                      //               ),
                                      //             );
                                      //           },
                                      //           child: Container(
                                      //             height: double.infinity,
                                      //             width: double.infinity,
                                      //             decoration: BoxDecoration(
                                      //               border: Border.all(
                                      //                 color: Colors.white,
                                      //                 width: 3,
                                      //               ),
                                      //             ),
                                      //             child: Center(
                                      //                 child: Icon(
                                      //               Icons.add,
                                      //               color: Colors.white,
                                      //               size: 60,
                                      //             )),
                                      //           ),
                                      //         )
                                      //   :
                                      GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => ItemDetails(
                                              id: requests[index].id),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(0),
                                        ),
                                        child: Image.network(
                                          requests[index].productImage == null
                                              ? 'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg'
                                              : requests[index]
                                                  .productImage!
                                                  .url!,
                                          //'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg',
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
                    ),
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
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => LoginUser(),
                                  ),
                                );
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
}

import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/models/User/user.dart';
import 'package:e_commerce_foods/service/FollowBusinessAccount/followBusiness.dart';
import 'package:e_commerce_foods/service/token_auth/session_service.dart';
import 'package:e_commerce_foods/ui/sidebar/edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class BusinessProfile extends StatefulWidget {
  @override
  final String? businessAccountId;
  const BusinessProfile(this.businessAccountId);
  _BusinessProfileState createState() => _BusinessProfileState();
}

class _BusinessProfileState extends State<BusinessProfile> {
  TextEditingController controller = TextEditingController();
  String FollowBtnText = "Follow";
  bool remember = false;
  bool IsFollow = false;
  User? businessUser;
  var btnTextColor = Colors.red;
  bool isBusy = true;
  bool? isViewShow;
  String? Id;
  String? Followers;
  @override
  void initState() {
    context
        .read<BusinessUsersProvider>()
        .getBussinessUsers(widget.businessAccountId!);
    context
        .read<ProductsProvider>()
        .getProductByBusiness(widget.businessAccountId);
    GetFollowedBusinessAccount();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String image =
        'https://img.freepik.com/free-photo/portrait-confident-man_102671-5909.jpg';
    businessUser = context.watch<BusinessUsersProvider>().users;
    if (businessUser != null) {
      setState(() {
        isBusy = false;
        isViewShow = true;
        Followers = businessUser!.followCount.toString();
      });
    } else {
      setState(() {
        isBusy = true;
        isViewShow = false;
      });
    }
    final prod = context.watch<ProductsProvider>().product;
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.black,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  businessUser == null ? " " : businessUser!.name!,
                  style: Global.style(
                    size: 18,
                  ),
                ),
                SizedBox(width: 4),
                Visibility(
                  visible:
                      businessUser == null ? false : businessUser!.isReputable!,
                  child: Icon(
                    Icons.verified,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            centerTitle: true,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.more_horiz,
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: isViewShow == false
              ? Visibility(
                  visible: isBusy,
                  child: ModalProgressHUD(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    inAsyncCall: isBusy,
                    // demo of some additional parameters
                    // opacity: 0.5,
                    progressIndicator: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      // valueColor:  new AlwaysStoppedAnimation<Color>(
                      //   Colors.black),
                    ),
                  ),
                )
              : Visibility(
                  visible: isViewShow!,
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
                                        color: Colors.white,
                                      ),
                                    ),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                        child: Image.network(
                                          businessUser!.businessAccountImage !=
                                                  null
                                              ? businessUser!
                                                  .businessAccountImage!.url!
                                              : "https://e7.pngegg.com/pngimages/328/599/png-clipart-male-avatar-user-profile-profile-heroes-necktie-thumbnail.png",
                                          //'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg',
                                          fit: BoxFit.cover,
                                        )),
                                  ),
                                  SizedBox(height: 4),
                                  Visibility(
                                    visible: false,
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => EditProfile(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        'Edit',
                                        style: Global.style(),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Text(
                                    businessUser != null
                                        ? businessUser!.productCount.toString()
                                        : "0",
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
                                    Followers == null ? "" : Followers!,
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
                                    businessUser!.likeCount.toString(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Container(
                              height: 28,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                                color: IsFollow ? Colors.green : Colors.blue,
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
                                  child: Row(
                                    children: [
                                      Visibility(
                                        visible: IsFollow,
                                        child: Icon(
                                          Icons.check,
                                          color: Colors.white,
                                        ),
                                      ),
                                      MaterialButton(
                                        onPressed: () {
                                          FollowBusinessAccount();
                                        },
                                        textColor: btnTextColor,
                                        child: Text(FollowBtnText,
                                            textAlign: TextAlign.center,
                                            style: Global.style()),
                                      ),
                                    ],
                                  )),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Description...',
                              style: Global.style(
                                bold: true,
                                size: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          businessUser!.description!,
                          style: Global.style(),
                        ),
                        SizedBox(height: 16),
                        prod.isEmpty
                            ? Center(child: CircularProgressIndicator())
                            : GridView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: prod.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 4,
                                  mainAxisSpacing: 4,
                                  childAspectRatio: 1,
                                ),
                                itemBuilder: (context, index) {
                                  return Container(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(0),
                                      ),
                                      child: Image.network(
                                        prod[index].productImage == null
                                            ? "https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg"
                                            : prod[index].productImage!.url!,
                                        //'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg',
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  );
                                },
                              ),
                      ],
                    ),
                  ),
                )),
    );
  }

  FollowBusinessAccount() async {
    if (!IsFollow) {
      setState(() {
        isBusy = true;
      });

      var currentUserId = await SessionService.retrieveUser();
      print(currentUserId.toString() + "curr userID");
      var follow = {
        "userId": currentUserId,
        "businessAccountId": widget.businessAccountId,
      };
      try {
        var res = await FollowBusinessService.createFollow(follow);
        if (res != null) {
          setState(() {
            Id = res["id"];
            IsFollow = true;
            FollowBtnText = "UnFollow";
            context
                .read<BusinessUsersProvider>()
                .getBussinessUsers(widget.businessAccountId!);
            businessUser = context.read<BusinessUsersProvider>().users;
            if (businessUser != null) {
              Followers = businessUser!.followCount.toString();
            }
          });
        }
      } catch (err) {
        // final requestbody = json.decode(err.body);
        // final data = requestbody['error'];
        // showErrorToast(data["message"]);
        showErrorToast(err.toString());
        setState(() {
          isBusy = false;
        });
        print(err);
      }
    } else {
      if (this.mounted) {
        setState(() {
          isBusy = true;
        });
      }
      //await Future.delayed(const Duration(milliseconds: 1000));
      try {
        var response = await FollowBusinessService.delete(Id);
        if (response) {
          setState(() {
            IsFollow = false;
            FollowBtnText = "Follow";
            context
                .read<BusinessUsersProvider>()
                .getBussinessUsers(widget.businessAccountId!);
            businessUser = context.read<BusinessUsersProvider>().users;
            if (businessUser != null) {
              Followers = businessUser!.followCount.toString();
            }
          });
        }
      } catch (err) {
        // final requestbody = json.decode(err.body);
        // final data = requestbody['error'];
        // showErrorToast(data["message"]);
        showErrorToast(err.toString());
        setState(() {
          isBusy = false;
        });
        print(err);
      }
    }

    if (this.mounted) {
      setState(() {
        isBusy = false;
      });
    }
  }

  void showErrorToast(msg) {
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        //timeInSecForIos: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white);
  }

  GetFollowedBusinessAccount() async {
    try {
      var currentUserId = await SessionService.retrieveUser();
      setState(() {
        isViewShow = false;
        isBusy = true;
      });
      var response = await FollowBusinessService.getFollowsResult(
          currentUserId.toString(), widget.businessAccountId);
      if (response != null) {
        setState(() {
          Id = response["id"];
          IsFollow = true;
          FollowBtnText = "UnFollow";
          btnTextColor = Colors.blue;
        });
      } else if (response == null) {
        setState(() {
          IsFollow = false;
          FollowBtnText = "Follow";
        });
      }
      if (this.mounted) {
        setState(() {
          isBusy = false;
          isViewShow = true;
        });
      }
    } catch (err) {
      if (this.mounted) {
        setState(() {
          isBusy = false;
          isViewShow = true;
        });
      }
    }
  }
}

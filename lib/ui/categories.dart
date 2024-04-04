import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/productCategory.dart';
import 'package:e_commerce_foods/Provider/user.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/service/Like/like.dart';
import 'package:e_commerce_foods/ui/categories_list.dart';
import 'package:e_commerce_foods/ui/item_details.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  TextEditingController controller = TextEditingController();

  String burgerPic =
      'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg';
  String carPic =
      'https://static01.nyt.com/images/2007/06/15/automobiles/600-scion-01.jpg';

  bool car = false,
      salon = false,
      game = false,
      gocery = false,
      flight = false,
      other = false;

  @override
  initState() {
    super.initState();
    context.read<ProductsProvider>().getProductLikeByUser();
    context.read<ProductsCategoryProvider>().getProductCategory();
    //context.read<ProductsCategoryProvider>().getBussinessUser();
  }

  @override
  Widget build(BuildContext context) {
    final likedProducts = context.watch<ProductsProvider>().productlikebyUser;
    final requests = context.watch<ProductsCategoryProvider>().category;
    final categortProduct = context.watch<ProductsProvider>().productbyCategory;
    final user = context.watch<BusinessUsersProvider>().userProfile;

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
          body: requests.length > 0
              ? Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Categories',
                              style: Global.style(
                                size: 18,
                                bold: true,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => CategoriesList(),
                                  ),
                                );
                              },
                              child: Text(
                                'ALL',
                                style: Global.style(
                                  size: 18,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CategoryItem(
                                    asset:
                                        requests[index].productCategoryImage ==
                                                null
                                            ? Global.burger
                                            : requests[index]
                                                .productCategoryImage!
                                                .url,
                                    title: requests[index].name,
                                    isSelected: requests[index].isSelected,
                                    onPressed: () {
                                      requests[index].isSelected = true;
                                      productByCategory(requests[index].id);
                                      SelectedProduct(index);
                                    },
                                  ),
                                ]);
                          },
                          itemCount: requests.length,
                        ),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     CategoryItem(
                        //       asset: requests[0].productCategoryImage == null
                        //           ? Global.burger
                        //           : requests[0].productCategoryImage.url,
                        //       title: requests[0].name,
                        //       isSelected:  requests[0].isSelected,
                        //       onPressed: () {
                        //        requests[0].isSelected=true;
                        //         productByCategory(requests[0].id);
                        //        SelectedProduct(0);
                        //       },
                        //     ),
                        //     CategoryItem(
                        //       asset: requests[1].productCategoryImage == null
                        //           ? Global.burger
                        //           : requests[1].productCategoryImage.url,
                        //       title: requests[1].name,
                        //       isSelected: requests[1].isSelected,
                        //       onPressed: () {
                        //        requests[1].isSelected=true;
                        //         productByCategory(requests[1].id);
                        //        SelectedProduct(1);
                        //
                        //       },
                        //     ),
                        //     CategoryItem(
                        //       asset: requests[2].productCategoryImage == null
                        //           ? carPic
                        //           : requests[2].productCategoryImage.url,
                        //       title: requests[2].name,
                        //       isSelected: requests[2].isSelected,
                        //       onPressed: () {
                        //
                        //         productByCategory(requests[2].id);
                        //         SelectedProduct(2);
                        //       },
                        //     )
                        //   ],
                        // ),
                        // SizedBox(height: 12),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   children: [
                        //     CategoryItem(
                        //       asset: requests[3].productCategoryImage == null
                        //           ? carPic
                        //           : requests[3].productCategoryImage.url,
                        //       title: requests[3].name,
                        //       isSelected: requests[3].isSelected,
                        //       onPressed: () {
                        //
                        //         productByCategory(requests[3].id);
                        //         SelectedProduct(3);
                        //       },
                        //     ),
                        //     CategoryItem(
                        //       asset: requests[4].productCategoryImage == null
                        //           ? carPic
                        //           : requests[4].productCategoryImage.url,
                        //       title: requests[4].name,
                        //       isSelected: requests[4].isSelected,
                        //       onPressed: () {
                        //
                        //         productByCategory(requests[4].id);
                        //         SelectedProduct(4);
                        //       },
                        //     ),
                        //     CategoryItem(
                        //       asset: Global.otherPic,
                        //       title: 'Other',
                        //       isSelected: requests[5].isSelected,
                        //       onPressed: () {
                        //         SelectedProduct(5);
                        //         Navigator.of(context).push(
                        //           MaterialPageRoute(
                        //             builder: (_) => CategoriesList(),
                        //           ),
                        //         );
                        //       },
                        //     )
                        //   ],
                        // ),
                        // SizedBox(height: 24),
                        // Text(
                        //   'Most Recommended',
                        //   style: Global.style(
                        //     size: 18,
                        //     bold: true,
                        //   ),
                        // ),
                        // SizedBox(height: 12),
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: categortProduct.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                            childAspectRatio: 0.7,
                          ),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (_) => ItemDetails(
                                        id: categortProduct[index].id),
                                  ),
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        likedProducts == null ||
                                                likedProducts.length == 0 ||
                                                !likedProducts.any((element) =>
                                                    element.id ==
                                                    categortProduct[index].id)
                                            ? Icon(Icons.favorite_border,
                                                color: Colors.grey)
                                            : Icon(Icons.favorite,
                                                color: Colors.red)
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(50),
                                        ),
                                        child: Image.network(
                                          categortProduct[index].productImage ==
                                                  null
                                              ? Global.burger
                                              : categortProduct[index]
                                                  .productImage!
                                                  .url!,
                                          fit: BoxFit.cover,
                                          height: 80,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 12),
                                    Text(
                                      categortProduct[index].name!,
                                      style: Global.style(),
                                    ),
                                    Text(
                                      'Salsa',
                                      style: Global.style(
                                        size: 8,
                                      ),
                                    ),
                                    Text(
                                      "\$ ${categortProduct[index].newPrice == null ? 0 : categortProduct[index].newPrice}",
                                      style: Global.style(
                                        bold: true,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Row(
                                      children: [
                                        RatingBar.builder(
                                          initialRating: categortProduct[index]
                                              .ratingAverage!,
                                          minRating: 1,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          ignoreGestures: true,
                                          itemCount: 5,
                                          itemSize: 20,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.yellow[800],
                                            size: 20,
                                          ),
                                          onRatingUpdate: (rating) {
                                            print(rating);
                                          },
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                )
              : Text("Loading")),
    );
  }

  productByCategory(String? id) async {
    context.read<ProductsProvider>().getProductbyCategoryId(id);
  }

  SelectedProduct(index) {
    context.read<ProductsCategoryProvider>().SelectedProduct(index);
  }

  _pressed(liked, req, user) async {
    if (liked) {
      // var userId = await SessionService.retrieveUser();
      // final requests = context.read<ProductsProvider>().products;
      var data = {"userId": user.id, "productId": req.id};
      var like = await LikeService.deleteForMobile(data);
      context.read<ProductsProvider>().getProductLikeByUser();
    } else {
      // var userId = await SessionService.retrieveUser();
      // final requests = context.read<ProductsProvider>().products;
      var data = {"userId": user.id, "productId": req.id};
      var like = await LikeService.create(data);
      context.read<ProductsProvider>().getProductLikeByUser();
    }
  }
}

class CategoryItem extends StatelessWidget {
  final String? asset, title, other;
  final Function? onPressed;
  final bool? isSelected;

  CategoryItem(
      {this.asset, this.title, this.isSelected, this.onPressed, this.other});

  @override
  Widget build(BuildContext context) {
    double size = MediaQuery.of(context).size.width / 4;
    return Column(
      children: [
        GestureDetector(
          onTap: onPressed as void Function()?,
          child: Container(
            height: size,
            width: size,
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              border: Border.all(
                color: isSelected! ? Colors.green : Colors.white,
                width: 2,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child: Image.network(asset!),
          ),
        ),
        SizedBox(height: 4),
        Text(
          title!,
          style: Global.style(
            size: 18,
          ),
        )
      ],
    );
  }
}

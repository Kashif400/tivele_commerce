import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:e_commerce_foods/ui/item_details.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favourites extends StatefulWidget {
  @override
  _FavouritesState createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  TextEditingController controller = TextEditingController();

  String burger =
      'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg';

  @override
  Widget build(BuildContext context) {
    var fav = context.watch<ProductsProvider>().productlikebyUser;
    double width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.black,
          title: Text(
            'Tivele Favourites',
            style: Global.style(
              size: 22,
              bold: true,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
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
                              burger,
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
                              text: '5.99\$ ',
                              style: Global.style(
                                size: 16,
                                bold: true,
                              ),
                              children: [
                                TextSpan(
                                  text: '7.99\$',
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
                  itemCount: 12,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 6,
                    mainAxisSpacing: 6,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ItemDetails(id: fav[index].id),
                          ),
                        );
                      },
                      child: Container(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(
                            Radius.circular(0),
                          ),
                          child: Image.network(
                            burger,
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
    );
  }
}

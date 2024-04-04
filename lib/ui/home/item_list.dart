import 'package:flutter/material.dart';
import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:provider/provider.dart';

import '../../models/product/products.dart';

class ItemList extends StatefulWidget {
  @override
  _ItemListState createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  TextEditingController controller = TextEditingController();
  Items? _product;

  String burger =
      'https://biancazapatka.com/wp-content/uploads/2020/05/veganer-bohnen-burger-500x500.jpg';

  @override
  void initState() {
    context.read<ProductsProvider>().getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Items>(context);
    double width = MediaQuery.of(context).size.width;
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
        body: Container(
          padding: EdgeInsets.symmetric(
            vertical: 12,
          ),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: 8,
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 0,
              );
            },
            itemBuilder: (context, index) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      product.name!,
                      style: Global.style(
                        size: 18,
                        bold: true,
                      ),
                    ),
                  ),
                  Stack(
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
                            text:
                                "\$ ${product.newPrice == null ? 0 : product.newPrice}",
                            style: Global.style(
                              size: 16,
                              bold: true,
                            ),
                            children: [
                              TextSpan(
                                text:
                                    "\$ ${product.oldPrice == null ? 0 : product.oldPrice}",
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
                  ),
                  Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 20,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 20,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 20,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 20,
                              ),
                              Icon(
                                Icons.star,
                                color: Colors.yellow[800],
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.favorite, color: Colors.red),
                            SizedBox(width: 8),
                            Text(
                              'Liked by 2700 people',
                              style: Global.style(),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          product.description!,
                          style: Global.style(),
                        ),
                      ],
                    ),
                  )
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

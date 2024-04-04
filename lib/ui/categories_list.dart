import 'package:flutter/material.dart';
import 'package:e_commerce_foods/Provider/product.dart';
import 'package:e_commerce_foods/Provider/productCategory.dart';
import 'package:e_commerce_foods/global/global.dart';
import 'package:provider/provider.dart';

class CategoriesList extends StatefulWidget {
  @override
  _CategoriesListState createState() => _CategoriesListState();
}

class _CategoriesListState extends State<CategoriesList> {
  var categories = [
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
  ];

  @override
  initState() {
    super.initState();
    context.read<ProductsCategoryProvider>().getProductCategory();
  }

  @override
  Widget build(BuildContext context) {
    final listcategory = context.watch<ProductsCategoryProvider>().category;
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
            horizontal: 16,
            vertical: 12,
          ),
          child: ListView.separated(
            itemBuilder: (_, index) {
              return InkWell(
                child: Text(
                  listcategory[index].name!,
                  style: Global.style(
                    size: 16,
                  ),
                ),
                onTap: () {
                  listcategory[index].isSelected = true;
                  productByCategory(listcategory[index].id);
                  SelectedProduct(index);
                  Navigator.pop(context);
                },
              );
            },
            separatorBuilder: (_, __) {
              return Column(
                children: [
                  SizedBox(height: 14),
                  Container(
                    height: 1,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                  SizedBox(height: 14),
                ],
              );
            },
            itemCount: listcategory.length,
          ),
        ),
      ),
    );
  }

  productByCategory(String? id) async {
    context.read<ProductsProvider>().getProductbyCategoryId(id);
  }

  SelectedProduct(index) {
    context.read<ProductsCategoryProvider>().SelectedProduct(index);
  }
}

import 'package:e_commerce_foods/models/product/product_category.dart';
import 'package:e_commerce_foods/service/product/category_service.dart';
import 'package:flutter/cupertino.dart';

class ProductsCategoryProvider with ChangeNotifier {
  List<ProductCategory> _category = [];
  ProductCategory? _categorys;
  bool _productLoading = false;

  /// Get All getter & setter

  List<ProductCategory> get category => _category;

  set category(List<ProductCategory> data) {
    this._category = data;
    notifyListeners();
  }

  /// Get single getter & setter

  ProductCategory? get categorys => _categorys;

  set categorys(ProductCategory? data) {
    this._categorys = data;
    notifyListeners();
  }

  /// Get All Product function

  getProductCategory() async {
    try {
      var res = await ProductCategoryService.getAll();
      category = [];
      var list = _category;
      for (var item in res["items"]) {
        var prod = ProductCategory.fromJson(item);
        list.add(prod);
      }
      category = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  /// Get Single Product function

  getProductsCategory(String id) async {
    try {
      var prod = await ProductCategoryService.get(id);
      var res = ProductCategory.fromJson(prod);
      categorys = res;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  SelectedProduct(index) {
    for (var i = 0; i < category.length; i++) {
      if (i == index) {
        category[i].isSelected = true;
      } else {
        category[i].isSelected = false;
      }
    }
    // category[index].isSelected=isSelected;
  }
}

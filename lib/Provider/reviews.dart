import 'package:e_commerce_foods/models/Reviews/reviews.dart';
import 'package:e_commerce_foods/service/Review/Reviews.dart';
import 'package:flutter/cupertino.dart';

class ReviewsProvider with ChangeNotifier {
  List<Reviews> _review = [];
  List<Reviews> _reviewbyProduct = [];
  Reviews? _reviews;
  bool _productLoading = false;

  /// Get by Product getter @setter

  List<Reviews> get reviewbyProduct => _reviewbyProduct;

  set reviewbyProduct(List<Reviews> data) {
    this._reviewbyProduct = data;
    notifyListeners();
  }

  /// Get All getter & setter

  List<Reviews> get review => _review;

  set review(List<Reviews> data) {
    this._review = data;
    notifyListeners();
  }

  /// Get single getter & setter

  Reviews? get reviews => _reviews;

  set reviews(Reviews? data) {
    this._reviews = data;
    notifyListeners();
  }

  /// Get All Product function

  getProductReview() async {
    try {
      var res = await ReviewsService.getAll();
      review = [];
      var list = review;

      for (var review in res["items"]) {
        var prod = Reviews.fromJson(review);
        list.add(prod);
      }
      review = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  /// Get Single Product function

  getProductReviews(String? id) async {
    try {
      var res = await ReviewsService.getAllByProduct(id);
      reviewbyProduct = [];
      var list = reviewbyProduct;

      for (var review in res["items"]) {
        var prod = Reviews.fromJson(review);
        list.add(prod);
      }
      reviewbyProduct = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }

  getReviewByProductId(String? id) async {
    try {
      var res = await ReviewsService.getAllByProduct(id);
      reviewbyProduct = [];
      var list = reviewbyProduct;

      for (var review in res["items"]) {
        var prod = Reviews.fromJson(review);
        list.add(prod);
      }
      reviewbyProduct = list;
    } catch (err) {
      print(err);
    }
    notifyListeners();
  }
}

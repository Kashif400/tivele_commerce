import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:e_commerce_foods/models/customer/getExploreDataModel.dart';
import 'package:e_commerce_foods/services/customer/GetFavoriteProductsService.dart';
import 'package:get/get.dart';

class GetFavoriteProductsController extends GetxController {
  GetExploreDataM? myOrdersInfo = GetExploreDataM();
  Rx<CheckApiResponseM> userInfo = CheckApiResponseM().obs;
  var isLoading = true.obs;
  var isListNull = false.obs;
  List<ProductDatum> myFavList = [];
  fetchfavouriteproduct() async {
    isLoading(true).obs;
    isListNull(true).obs;
    var detail = await GetFavoriteProductsService.fetchFavouriteProduct();
    myOrdersInfo = detail;
    if (detail == 600) {
      isLoading(false).obs;
      isListNull(true).obs;
      myOrdersInfo!.status = 600;
      //globals.showErrorSnackBar("No Data Found!");
    } else if (detail != null) {
      try {
        // myOrdersInfo = detail;
        if (myOrdersInfo!.status == 200) {
          isLoading(false).obs;
          isListNull(false).obs;
          myFavList = myOrdersInfo!.data!.map((element) {
            print(element.productImages);
            return element;
          }).toList();
        } else {
          isLoading(false).obs;
          isListNull(true).obs;
        }
      } catch (e) {
        isLoading(false).obs;
        isListNull(true).obs;
      }
    } else {
      isLoading(false).obs;
      isListNull(true).obs;
    }
  }
}

import 'package:get/get.dart';
import 'package:e_commerce_foods/globals.dart' as globals;
import 'package:e_commerce_foods/models/checkApiResponseModel.dart';
import 'package:e_commerce_foods/models/customer/getOrderByUserId.dart';
import 'package:e_commerce_foods/services/customer/getOrderByUserId.dart';

class getOrderByUserId extends GetxController {
  GetOrdersByUserIdService? myordersInfo = GetOrdersByUserIdService();
  Rx<CheckApiResponseM> userInfo = CheckApiResponseM().obs;
  var isLoading = false.obs;
  var isListNull = false.obs;
  //var aik = model.GetOrdersByUserIdService;
  List<Datum> myorderList = [];
  dynamic fetchorderbyuserid() async {
    var detail = await getOrderByUserIdServices.fetchOrderByUserId();
    myordersInfo = detail;
    print(myordersInfo!.status);
    if (detail == 600) {
      isLoading(false).obs;
      isListNull(true).obs;
      myordersInfo!.status = 600;
      globals.showErrorSnackBar("No Data Found!");
    } else if (detail != null) {
      try {
        myordersInfo = detail;
        if (myordersInfo!.status == 200) {
          isLoading(false).obs;
          isListNull(false).obs;
          print("YES IT WORKED! getorderbyidcontroller 200 syccess");
          myorderList = myordersInfo!.data!.map((element) {
            print("list building");
            return element;
          }).toList();

          print(myordersInfo!.message.toString() + "asdasd");
        }
      } catch (e) {}
    }
  }
}

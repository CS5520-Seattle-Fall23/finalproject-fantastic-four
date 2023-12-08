import 'package:sweetpet/api/api_client.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sweetpet/constant/pages.dart';

class MallController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final storageRef = FirebaseStorage.instance.ref();

  Future<dynamic> getMallData(String category, String name) async {
    return await ApiClient().getMallData(category, name);
  }

  void openMallDetailPage(String title) {
    Get.toNamed(Pages.mall, arguments: {"title": title});
  }
}

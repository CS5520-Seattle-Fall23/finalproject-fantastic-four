import 'package:flutter/material.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/constant/pages.dart';
import 'package:sweetpet/model/post.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';

class LikeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  List<Post> data = [];
  final storageRef = FirebaseStorage.instance.ref();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    getIndexData();
  }

  void getIndexData() {
    ApiClient().getIndexData().then((response) {
      data = response;
      update();
    });
  }

  void openIndexDetailPage(int id) {
    Get.toNamed(Pages.liked, arguments: {"id": id});
  }
}

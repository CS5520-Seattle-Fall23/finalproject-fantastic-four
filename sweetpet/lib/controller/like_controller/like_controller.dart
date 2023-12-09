import 'package:flutter/material.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/constant/pages.dart';
import 'package:sweetpet/model/post.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sweetpet/model/thumb.dart';

class LikeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  List<Post> data = [];
  List<Post> list = [];
  late List<THUMB> thumbs = [];
  final storageRef = FirebaseStorage.instance.ref();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 1, vsync: this, initialIndex: 0);
    getIndexData();
  }

  Future<void> getIndexData() async {
    await updateUserThumbPosts();
    ApiClient().getIndexData().then((response) {
      list = response;
      for (var post in list) {
        for (var thumb in thumbs) {
          if (post.uid == thumb.authorId &&
              thumb.tag == 1 &&
              post.id == thumb.postId) {
            data.add(post);
            // break; // 找到匹配项后，退出内部循环
          }
        }
      }
      // 更新状态，将满足条件的帖子列表传递给界面
      update();
    });
  }

  void openIndexDetailPage(String id) {
    Get.toNamed(Pages.liked, arguments: {"id": id});
  }

  Future<void> updateUserThumbPosts() async {
    thumbs = await ApiClient().getUserThumbPosts();
  }
}

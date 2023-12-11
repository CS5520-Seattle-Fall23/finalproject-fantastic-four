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

  /// Fetch and filter index data.
  ///
  /// This function retrieves index data, updates the user's thumb posts, and filters the posts based on specific conditions.
  ///
  /// It fetches the index data and filters it to include only posts that meet the following criteria:
  /// - The post's author is being followed by the user.
  /// - The post has received a positive thumb tag (tag equals 1) from the user.
  ///
  /// Example:
  /// ```dart
  /// // Fetch and filter index data
  /// getIndexData();
  /// ```
  ///
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
          }
        }
      }
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

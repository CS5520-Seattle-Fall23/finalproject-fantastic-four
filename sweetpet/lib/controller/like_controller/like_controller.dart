import 'package:flutter/material.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/constant/pages.dart';
import 'package:sweetpet/model/post.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sweetpet/model/thumb.dart';

/// `LikeController` manages the state and functionality for handling liked posts.
///
/// This controller is responsible for initializing the tab controller,
/// fetching liked posts data, and navigating to the liked posts detail page.
///
/// ## Usage:
/// ```dart
/// LikeController likeController = Get.put(LikeController());
/// ```
class LikeController extends GetxController
    with GetSingleTickerProviderStateMixin {
  /// Tab controller for managing tabs.
  late TabController tabController;

  /// List of all posts data.
  List<Post> data = [];

  /// List of liked posts data.
  List<Post> list = [];

  /// List of thumb data.
  late List<THUMB> thumbs = [];

  /// Firebase Storage reference.
  final storageRef = FirebaseStorage.instance.ref();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 1, vsync: this, initialIndex: 0);
    getIndexData();
  }

  /// Fetch liked posts data and update the state.
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
            // break; // Uncomment if you want to exit the inner loop after finding a match
          }
        }
      }
      // Update the state to pass the list of liked posts that meet the condition to the UI
      update();
    });
  }

  /// Navigate to the liked posts detail page.
  void openIndexDetailPage(String id) {
    Get.toNamed(Pages.liked, arguments: {"id": id});
  }

  /// Fetch the user's thumb posts.
  Future<void> updateUserThumbPosts() async {
    thumbs = await ApiClient().getUserThumbPosts();
  }
}

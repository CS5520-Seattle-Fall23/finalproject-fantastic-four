import 'package:flutter/material.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/constant/pages.dart';
import 'package:sweetpet/model/comment.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sweetpet/page/comment_page/comment_page.dart';

class CommentController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  List<Comment> data = [];
  CommentsPage page = CommentsPage();

  final storageRef = FirebaseStorage.instance.ref();

  @override
  void onInit() {
    super.onInit();
    getIndexData();
  }

  /// Getting comment data from Firebase
  Future<void> getIndexData() async {
    ApiClient().getCommentListData().then((response) {
      data = response;
      update();
    });
  }
}

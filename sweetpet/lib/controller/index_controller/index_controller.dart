import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/constant/pages.dart';
import 'package:sweetpet/constant/uid.dart';
import 'package:sweetpet/model/post.dart';
import 'package:sweetpet/model/thumb.dart';
import 'package:get/get.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class IndexController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  late List<Post> data = [];
  late List<THUMB> thumbs = [];
  final storageRef = FirebaseStorage.instance.ref();

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this, initialIndex: 1);
    getIndexData();
  }

  Future<void> refreshData() async {
    getIndexData();
  }

  Future<void> getIndexData() async {
    await updateUserThumbPosts();
    ApiClient().getIndexData().then((response) {
      data = response;
      update();
    });
  }

  Future<void> updateUserThumbPosts() async {
    thumbs = await ApiClient().getUserThumbPosts();
  }

  void openIndexDetailPage(String id) {
    Get.toNamed(Pages.indexDetail, arguments: {"id": id});
  }

  /// After the user likes the model, a thumb model is generated and passed into firebase
  Future<void> uploadThumbToFirebase(THUMB thumb) async {
    try {
      await FirebaseFirestore.instance.collection('thumb').doc().set({
        'id': thumb.id,
        'authorId': thumb.authorId,
        'postId': thumb.postId,
        'userId': thumb.userId,
        'tag': thumb.tag,
      });
      print('点赞成功！');
    } catch (e) {
      print('点赞出现错误：$e');
    }
  }

  /// Create a new thumb or update an existing thumb and upload it to Firebase.
  ///
  /// This function creates a new thumb model or updates an existing one with a new tag value and uploads it to the 'thumb' collection in Firebase Firestore.
  ///
  /// Parameters:
  /// - `postId`: The ID of the post for which the thumb is being created or updated.
  /// - `authorId`: The ID of the author of the post.
  /// - `tag`: The new tag value to assign to the thumb.
  ///
  /// Example:
  /// ```dart
  /// // Create a new thumb or update an existing thumb for a post
  /// createThumbAndUpload('post123', 'author456', 1);
  /// ```
  ///
  /// If a thumb for the specified post and user already exists, this function updates the tag value. Otherwise, it creates a new thumb model and uploads it to Firebase Firestore.
  ///
  Future<void> createThumbAndUpload(
      String postId, String authorId, int tag) async {
    QuerySnapshot thumbQuery = await FirebaseFirestore.instance
        .collection('thumb')
        .where('userId', isEqualTo: globalUid)
        .where('postId', isEqualTo: postId)
        .get();

    if (thumbQuery.docs.isNotEmpty) {
      thumbQuery.docs.forEach((QueryDocumentSnapshot doc) {
        DocumentReference thumbDocRef =
            FirebaseFirestore.instance.collection('thumb').doc(doc.id);

        Map<String, dynamic> updatedData = {
          'tag': tag,
        };

        thumbDocRef.set(updatedData, SetOptions(merge: true)).then((_) {
          print('Tag updated successfully for document ${doc.id}');
        }).catchError((error) {
          print('Error updating tag for document ${doc.id}: $error');
        });
      });
    } else {
      final String id = const Uuid().v4();
      THUMB newThumb = THUMB(
        id,
        authorId,
        globalUid,
        postId,
        tag,
      );
      uploadThumbToFirebase(newThumb);
    }
  }

  /// After a user likes a post, modify the number of likes for that post by looking up the post in firebase
  void modifyPostFavCount(String postId, int num) async {
    QuerySnapshot thumbQuery1 = await FirebaseFirestore.instance
        .collection('postView')
        .where('id', isEqualTo: postId)
        .get();
    QuerySnapshot thumbQuery2 = await FirebaseFirestore.instance
        .collection('post')
        .where('id', isEqualTo: postId)
        .get();

    if (thumbQuery1.docs.isNotEmpty && thumbQuery2.docs.isNotEmpty) {
      thumbQuery1.docs.forEach((QueryDocumentSnapshot doc) {
        DocumentReference thumbDocRef =
            FirebaseFirestore.instance.collection('postView').doc(doc.id);
        int newFav = max(0, num);
        Map<String, dynamic> updatedData = {
          'fav': newFav,
        };

        thumbDocRef.set(updatedData, SetOptions(merge: true)).then((_) {
          print('Tag updated successfully for document ${doc.id}');
        }).catchError((error) {
          print('Error updating tag for document ${doc.id}: $error');
        });
      });
    }
    thumbQuery2.docs.forEach((QueryDocumentSnapshot doc) {
      DocumentReference thumbDocRef =
          FirebaseFirestore.instance.collection('post').doc(doc.id);
      int newFav = max(0, num);
      Map<String, dynamic> updatedData = {
        'fav': newFav,
      };

      thumbDocRef.set(updatedData, SetOptions(merge: true)).then((_) {
        print('Tag updated successfully for document ${doc.id}');
      }).catchError((error) {
        print('Error updating tag for document ${doc.id}: $error');
      });
    });
  }
}

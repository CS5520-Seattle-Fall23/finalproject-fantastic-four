import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sweetpet/controller/home_controller/home_controller.dart';
import 'package:sweetpet/model/post.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetpet/constant/uid.dart';
import 'package:sweetpet/model/post_detail.dart';
import 'package:sweetpet/page/publish_page/publish_page.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetpet/page/publish_page/publish_page.dart';

class PublishController extends GetxController {
  var selectedImages = <XFile>[].obs;
  late String userId;
  late String avatarUrl;
  late String userName;
  List<String> uploadedImageUrls = [];
  HomeController homeController = Get.find<HomeController>();

  void pickImages() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile>? images = await picker.pickMultiImage();
      if (images != null) {
        selectedImages.value = images;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: ${e.toString()}');
    }
  }

  Future<List<String>> uploadImagesToFirebase(List<XFile> images) async {
    try {
      for (var image in images) {
        Reference ref = FirebaseStorage.instance
            .ref()
            .child('images/${DateTime.now().toString()}');
        TaskSnapshot uploadTask = await ref.putFile(File(image.path));
        String downloadURL = await uploadTask.ref.getDownloadURL();
        uploadedImageUrls.add(downloadURL);
      }
    } catch (e) {
      print('Error uploading images to Firebase: $e');
    }

    return uploadedImageUrls;
  }

  Future<void> uploadPostToFirebase(PostDetail post) async {
    try {
      await FirebaseFirestore.instance.collection('post').doc(post.id).set({
        'id': post.id,
        'uid': post.uid,
        'title': post.title,
        'content': post.content,
        'avatar': post.avatar,
        'nickname': post.nickname,
        'fav': post.fav,
        'comment': post.comment,
        'date': post.date,
        'images': post.images,
      });

      print('帖子上传成功！');
    } catch (e) {
      print('上传帖子时出现错误：$e');
    }
  }

  Future<void> uploadPostViewToFirebase(Post post) async {
    try {
      await FirebaseFirestore.instance.collection('postView').doc(post.id).set({
        'id': post.id,
        'uid': post.uid,
        'cover': post.cover,
        'content': post.content,
        'avatar': post.avatar,
        'nickname': post.nickname,
        'fav': post.fav,
        'like': post.like,
      });
      print('帖子View上传成功！');
    } catch (e) {
      print('上传帖子View时出现错误：$e');
    }
  }

  /// Create a model of the post and upload it to Firebase
  Future<void> createPostAndUpload(String title, String content,
      List<String> imagesUrls, String postId) async {
    PostDetail newPost = PostDetail(
      postId,
      globalUid,
      title,
      content,
      avatarUrl,
      userName,
      0,
      0,
      DateTime.now().toString(),
      imagesUrls,
    );

    uploadPostToFirebase(newPost);
  }

  Future<void> createPostViewAndUpload(
      String content, String imagesUrl, String postId) async {
    Post newPost = Post(
        postId, globalUid, imagesUrl, content, avatarUrl, userName, 20, 10);
    uploadPostViewToFirebase(newPost);
  }

  /// After clicking the share button, upload the image to firebase and write the URL link of the resulting image to firebase along with the title and content entered by the user.
  void sharePost(String title, String content) async {
    try {
      final String postId = const Uuid().v4();
      List<String> imagesUrls = await uploadImagesToFirebase(selectedImages);
      await getUserData(globalUid);
      // 等待 imagesUrls 获取完成后再执行 createPostAndUpload
      await createPostViewAndUpload(content, imagesUrls[0], postId);
      await createPostAndUpload(title, content, imagesUrls, postId);
      Get.snackbar('Success', 'Post saved successfully');
      homeController.onChangePage(0);
    } catch (error) {
      // 处理上传图片失败的情况
      Get.snackbar('Error', 'Failed to upload images: ${error.toString()}');
    }
  }

  /// Get information about a user based on their id
  Future<void> getUserData(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;

        String username = userData['username'];
        String email = userData['email'];
        String imageUrl = userData['image_url'];
        userId = email;
        userName = username;
        avatarUrl = imageUrl;
      } else {
        print("user doesn't exit");
      }
    } catch (e) {
      print('error: $e');
    }
  }
}

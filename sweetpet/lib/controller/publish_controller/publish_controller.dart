import 'dart:io';

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

  void savePost() {
    // Implement the save functionality
    Get.snackbar('Success', 'Post saved successfully');
    getUserData(globalUid);
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
        'like': post.like,
        'comment': post.comment,
        'date': post.date,
        'address': post.address,
        'images': post.images,
      });

      print('帖子上传成功！');
    } catch (e) {
      print('上传帖子时出现错误：$e');
    }
  }

  Future<void> createPostAndUpload(
      String title, String content, List<String> imagesUrls) async {
    // 创建帖子对象
    PostDetail newPost = PostDetail(
      "23",
      globalUid,
      title,
      content,
      avatarUrl,
      userName,
      32,
      43,
      0,
      DateTime.now().toString(),
      'Chicago',
      imagesUrls,
    );

    // 调用上传方法
    uploadPostToFirebase(newPost);
  }

  void sharePost(String title, String content) async {
    try {
      List<String> imagesUrls = await uploadImagesToFirebase(selectedImages);
      await getUserData(globalUid);
      // 等待 imagesUrls 获取完成后再执行 createPostAndUpload
      await createPostAndUpload(title, content, imagesUrls);
    } catch (error) {
      // 处理上传图片失败的情况
      Get.snackbar('Error', 'Failed to upload images: ${error.toString()}');
    }
  }

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

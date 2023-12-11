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

/// `PublishController` manages the state and functionality for publishing posts.
///
/// This controller is responsible for picking images, uploading images to Firebase,
/// creating and uploading post details and post views, and handling the post sharing process.
///
/// ## Usage:
/// ```dart
/// PublishController publishController = Get.put(PublishController());
/// ```
class PublishController extends GetxController {
  /// List of selected images to be uploaded.
  var selectedImages = <XFile>[].obs;

  /// User ID.
  late String userId;

  /// User avatar URL.
  late String avatarUrl;

  /// User username.
  late String userName;

  /// List of uploaded image URLs.
  List<String> uploadedImageUrls = [];

  /// Instance of `HomeController` for accessing home-related functionalities.
  HomeController homeController = Get.find<HomeController>();

  /// Open image picker to select multiple images.
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

  /// Upload selected images to Firebase storage and return a list of image URLs.
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

  /// Upload post details to Firebase.
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

      print('Post uploaded successfully!');
    } catch (e) {
      print('Error uploading post: $e');
    }
  }

  /// Upload post view details to Firebase.
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
      print('Post view uploaded successfully!');
    } catch (e) {
      print('Error uploading post view: $e');
    }
  }

  /// Create a model of the post and upload it to Firebase.
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

  /// Create a model of the post view and upload it to Firebase.
  Future<void> createPostViewAndUpload(
      String content, String imagesUrl, String postId) async {
    Post newPost = Post(
        postId, globalUid, imagesUrl, content, avatarUrl, userName, 20, 10);
    uploadPostViewToFirebase(newPost);
  }

  /// After clicking the share button, upload the image to Firebase and write the URL link of the resulting image to Firebase along with the title and content entered by the user.
  void sharePost(String title, String content) async {
    try {
      final String postId = const Uuid().v4();
      List<String> imagesUrls = await uploadImagesToFirebase(selectedImages);
      await getUserData(globalUid);
      await createPostViewAndUpload(content, imagesUrls[0], postId);
      await createPostAndUpload(title, content, imagesUrls, postId);
      Get.snackbar('Success', 'Post saved successfully');
      homeController.onChangePage(0);
    } catch (error) {
      Get.snackbar('Error', 'Failed to upload images: ${error.toString()}');
    }
  }

  /// Get information about a user based on their id.
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
        print("User doesn't exist");
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetpet/fakeData/fake.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sweetpet/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:sweetpet/model/post_detail.dart';

class ApiClient {
  ApiClient._internal();
  factory ApiClient() => _instance;
  static final ApiClient _instance = ApiClient._internal();

  // MainView Data
  Future<dynamic> getIndexData() async {
    final FirebaseFirestore firestore1 = FirebaseFirestore.instance;
    final CollectionReference collection1 = firestore1.collection('postView');
    try {
      List<Post> posts = [];
      QuerySnapshot querySnapshot1 = await collection1.get();
      for (QueryDocumentSnapshot document in querySnapshot1.docs) {
        Map<String, dynamic> data1 = document.data() as Map<String, dynamic>;
        Post post = Post.fromJson(data1);
        posts.add(post);
      }
      return posts;
    } catch (e) {
      print('Error getting collection data: $e');
    }
  }

  Future<dynamic> getPostDetailData() async {
    final FirebaseFirestore firestore2 = FirebaseFirestore.instance;
    final CollectionReference collection2 = firestore2.collection('post');
    try {
      List<PostDetail> postDetails = [];
      QuerySnapshot querySnapshot2 = await collection2.get();
      for (QueryDocumentSnapshot document in querySnapshot2.docs) {
        Map<String, dynamic> data2 = document.data() as Map<String, dynamic>;
        PostDetail postDetail = PostDetail.fromJson(data2);
        postDetails.add(postDetail);
      }
      return postDetails;
    } catch (e) {
      print('Error getting collection data: $e');
    }
  }

  // Post Detail Data
  Future<PostDetail?> getIndexDetailDataById(String id) async {
    List<PostDetail> postDetails = await getPostDetailData();
    for (var v in postDetails) {
      if (v.id == id) {
        return v;
      }
    }
    return null;
  }

  Future getCommentList() async {
    await Future.delayed(const Duration(seconds: 1));
    return await Future.value(FakeData.commentList);
  }
}

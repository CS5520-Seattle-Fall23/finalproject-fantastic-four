import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sweetpet/constant/uid.dart';
import 'package:sweetpet/model/mall.dart';
import 'package:sweetpet/model/comment.dart';
import 'package:sweetpet/model/follower.dart';
import 'package:sweetpet/model/post.dart';
import 'package:http/http.dart' as http;
import 'package:sweetpet/model/post_detail.dart';
import 'package:sweetpet/model/thumb.dart';

class ApiClient {
  ApiClient._internal();
  factory ApiClient() => _instance;
  static final ApiClient _instance = ApiClient._internal();

  List<Mall> convertDynamicListToMallList(List<dynamic> dynamicList) {
    return dynamicList.map((dynamic item) => Mall.fromJson(item)).toList();
  }

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

  Future getCommentList(String id) async {
    final FirebaseFirestore firestore2 = FirebaseFirestore.instance;
    final CollectionReference collection2 = firestore2.collection('comment');
    try {
      List<Comment> comments = [];
      QuerySnapshot querySnapshot2 = await collection2.get();
      for (QueryDocumentSnapshot document in querySnapshot2.docs) {
        Map<String, dynamic> data2 = document.data() as Map<String, dynamic>;
        Comment comment = Comment.fromJson(data2);
        if (comment.toPostId == id) {
          comments.add(comment);
        }
      }
      return comments;
    } catch (e) {
      print('Error getting collection data: $e');
    }
  }

  Future getUserThumbPosts() async {
    final FirebaseFirestore firestore2 = FirebaseFirestore.instance;
    final CollectionReference collection2 = firestore2.collection('thumb');
    try {
      List<THUMB> thumbs = [];
      QuerySnapshot querySnapshot2 = await collection2.get();
      for (QueryDocumentSnapshot document in querySnapshot2.docs) {
        Map<String, dynamic> data2 = document.data() as Map<String, dynamic>;
        THUMB thumb = THUMB.fromJson(data2);
        print(thumb.userId);
        if (thumb.userId == globalUid) {
          if (thumb.tag == 1) {
            thumbs.add(thumb);
          }
        }
      }
      return thumbs;
    } catch (e) {
      print('Error getting collection data: $e');
    }
  }

  Future<bool> getFollowUser(String toUserId) async {
    print("=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=");
    print(globalUid);
    print(toUserId);
    // 查询 thumb 集合以查找匹配的文档
    QuerySnapshot thumbQuery = await FirebaseFirestore.instance
        .collection('follow')
        .where('followerId', isEqualTo: globalUid)
        .where('toUserId', isEqualTo: toUserId)
        .get();

    if (thumbQuery.docs.isNotEmpty) {
      QueryDocumentSnapshot doc = thumbQuery.docs.first;
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      bool isFollowing = data['tag'];

      print(isFollowing);
      return isFollowing;
    } else {
      return false; // 如果没有找到匹配的数据，返回 false
    }
  }

  Future getUserFollowUsers() async {
    final FirebaseFirestore firestore2 = FirebaseFirestore.instance;
    final CollectionReference collection2 = firestore2.collection('follow');
    try {
      List<Follower> followers = [];
      QuerySnapshot querySnapshot2 = await collection2.get();
      for (QueryDocumentSnapshot document in querySnapshot2.docs) {
        Map<String, dynamic> data2 = document.data() as Map<String, dynamic>;
        Follower follower = Follower.fromJson(data2);
        if (follower.followerId == globalUid && follower.tag == true) {
          followers.add(follower);
        }
      }
      return followers;
    } catch (e) {
      print('Error getting collection data: $e');
    }
  }

  Future<dynamic> getCommentListData() async {
    final FirebaseFirestore firestore2 = FirebaseFirestore.instance;
    final CollectionReference collection2 = firestore2.collection('comment');
    try {
      List<Comment> comments = [];
      QuerySnapshot querySnapshot2 = await collection2.get();
      for (QueryDocumentSnapshot document in querySnapshot2.docs) {
        Map<String, dynamic> data2 = document.data() as Map<String, dynamic>;
        Comment comment = Comment.fromJson(data2);
        if (comment.userId == globalUid) {
          comments.add(comment);
        }
      }
      return comments;
    } catch (e) {
      print('Error getting collection data: $e');
    }
  }

  Future<dynamic> getFollowerListData() async {
    final FirebaseFirestore firestore2 = FirebaseFirestore.instance;
    final CollectionReference collection2 = firestore2.collection('follow');
    try {
      List<Follower> followers = [];
      QuerySnapshot querySnapshot2 = await collection2.get();
      for (QueryDocumentSnapshot document in querySnapshot2.docs) {
        Map<String, dynamic> data2 = document.data() as Map<String, dynamic>;
        Follower follower = Follower.fromJson(data2);
        if (follower.followerId == globalUid) {
          followers.add(follower);
        }
      }
      return followers;
    } catch (e) {
      print('Error getting collection data: $e');
    }
  }

  Future<dynamic> getMallData() async {
    try {
      // 获取 Firebase Storage 实例
      FirebaseStorage storage = FirebaseStorage.instance;

      // 获取文件的引用，路径应根据您的 Firebase Storage 结构调整
      Reference ref = storage.ref('mall/mallData.json');

      // 获取文件的下载 URL
      String url = await ref.getDownloadURL();
      // 使用 http 包下载文件
      final response = await http.get(Uri.parse(url));
      List<Mall> data =
          convertDynamicListToMallList(json.decode(response.body));
      return data;
    } catch (e) {
      // 打印并处理任何异常
      print('Error occurred while fetching data: $e');
      return null;
    }
  }

    // Post Detail Data
  Future getMallDetailDataByTitle(String title) async {
// 获取 Firebase Storage 实例
    FirebaseStorage storage = FirebaseStorage.instance;

    // 获取文件的引用，路径应根据您的 Firebase Storage 结构调整
    Reference ref = storage.ref('mall/mallData.json');

    // 获取文件的下载 URL
    String url = await ref.getDownloadURL();
    // 使用 http 包下载文件
    final response = await http.get(Uri.parse(url));
    List<Mall> data =
        convertDynamicListToMallList(json.decode(response.body));

    for (var mall in data) {
      if (mall.title == title) {
        return mall;
      }
    }
    return null;
  }
}

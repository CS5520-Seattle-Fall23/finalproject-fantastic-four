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

  /// MainView Data
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

  /// Post Detail Data
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

  /// Check if the current user is following another user.
  ///
  /// This function queries the Firestore 'follow' collection to determine if the
  /// current user, identified by [globalUid], is following the user with the
  /// provided [toUserId].
  ///
  /// If the current user is following the specified user, it returns `true`.
  /// Otherwise, it returns `false`.
  ///
  /// Parameters:
  /// - [toUserId]: The ID of the user to check for following status.
  ///
  /// Returns:
  /// A [Future] that resolves to `true` if the current user is following the
  /// specified user; otherwise, it resolves to `false`.
  Future<bool> getFollowUser(String toUserId) async {
    print(globalUid);
    print(toUserId);
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
      return false;
    }
  }

  /// Retrieve a list of users that the current user is following.
  ///
  /// This function queries the Firestore 'follow' collection to retrieve a list
  /// of users that the current user, identified by [globalUid], is following.
  ///
  /// It returns a [Future] that resolves to a list of [Follower] objects
  /// representing users being followed by the current user.
  ///
  /// Example:
  /// ```dart
  /// List<Follower> followedUsers = await getUserFollowUsers();
  /// for (Follower user in followedUsers) {
  ///   print('User ${user.username} is being followed.');
  /// }
  /// ```
  ///
  /// Returns:
  /// A [Future] that resolves to a list of [Follower] objects representing users
  /// that the current user is following. If an error occurs during the query,
  /// it returns an empty list.
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

  /// Retrieve a list of comments made by the current user.
  ///
  /// This function queries the Firestore 'comment' collection to retrieve a list
  /// of comments made by the current user, identified by [globalUid].
  ///
  /// It returns a [Future] that resolves to a list of [Comment] objects
  /// representing comments made by the current user.
  ///
  /// Example:
  /// ```dart
  /// List<Comment> userComments = await getCommentListData();
  /// for (Comment comment in userComments) {
  ///   print('Comment: ${comment.text}');
  /// }
  /// ```
  ///
  /// Returns:
  /// A [Future] that resolves to a list of [Comment] objects representing comments
  /// made by the current user. If an error occurs during the query, it returns an empty list.
  ///
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

  /// Retrieve a list of followers for the current user.
  ///
  /// This function queries the Firestore 'follow' collection to retrieve a list
  /// of followers for the current user, identified by [globalUid].
  ///
  /// It returns a [Future] that resolves to a list of [Follower] objects
  /// representing users who are following the current user.
  ///
  /// Example:
  /// ```dart
  /// List<Follower> userFollowers = await getFollowerListData();
  /// for (Follower follower in userFollowers) {
  ///   print('Follower: ${follower.username}');
  /// }
  /// ```
  ///
  /// Returns:
  /// A [Future] that resolves to a list of [Follower] objects representing users
  /// who are following the current user. If an error occurs during the query, it returns an empty list.
  ///
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

  /// Retrieve mall data for a specific category and name.
  ///
  /// This function fetches mall data from Firebase Storage based on the provided
  /// [category] and [name]. It constructs a URL to download the JSON data file
  /// from Firebase Storage, fetches the data using HTTP, and returns it as a list
  /// of [Mall] objects.
  ///
  /// Parameters:
  /// - [category]: The category of the mall data (e.g., "electronics").
  /// - [name]: The name of the mall data file (e.g., "products").
  ///
  /// Example:
  /// ```dart
  /// List<Mall> mallData = await getMallData("electronics", "products");
  /// if (mallData != null) {
  ///   for (Mall mall in mallData) {
  ///     print('Mall Name: ${mall.title}, Price: ${mall.price}');
  ///   }
  /// }
  /// ```
  ///
  /// Parameters:
  /// - [category]: The category of the mall data.
  /// - [name]: The name of the mall data file.
  ///
  /// Returns:
  /// A [Future] that resolves to a list of [Mall] objects representing the mall data
  /// for the specified category and name. If an error occurs during the retrieval,
  /// it returns `null`.
  ///
  Future<dynamic> getMallData(String category, String name) async {
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref('mall/${category.toLowerCase()}$name.json');
      String url = await ref.getDownloadURL();
      final response = await http.get(Uri.parse(url));
      List<Mall> data =
          convertDynamicListToMallList(json.decode(response.body));
      return data;
    } catch (e) {
      print('Error occurred while fetching data: $e');
      return null;
    }
  }


  /// Retrieve mall detail data by title.
  ///
  /// This function fetches mall detail data from Firebase Storage by downloading a JSON
  /// data file containing mall information. It then searches for a mall with a matching
  /// [title] and returns it as a [Mall] object. If no mall with the specified [title]
  /// is found, it returns `null`.
  ///
  /// Parameters:
  /// - [title]: The title of the mall for which you want to retrieve detail data.
  ///
  /// Example:
  /// ```dart
  /// Mall mallDetail = await getMallDetailDataByTitle("Electronics Store");
  /// if (mallDetail != null) {
  ///   print('Mall Title: ${mallDetail.title}, Price: ${mallDetail.price}');
  /// } else {
  ///   print('Mall not found.');
  /// }
  /// ```
  ///
  /// Parameters:
  /// - [title]: The title of the mall.
  ///
  /// Returns:
  /// A [Future] that resolves to a [Mall] object representing the detail data of the mall
  /// with the specified [title]. If no matching mall is found, it returns `null`.
  ///
  Future getMallDetailDataByTitle(String title) async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference ref = storage.ref('mall/mallData.json');
    String url = await ref.getDownloadURL();
    final response = await http.get(Uri.parse(url));
    List<Mall> data = convertDynamicListToMallList(json.decode(response.body));
    for (var mall in data) {
      if (mall.title == title) {
        return mall;
      }
    }
    return null;
  }
}

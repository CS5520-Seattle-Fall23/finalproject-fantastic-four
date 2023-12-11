import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/constant/uid.dart';
import 'package:sweetpet/model/follower.dart';
import 'package:sweetpet/model/post_detail.dart';
import 'package:sweetpet/model/comment.dart';
import 'package:get/get.dart';
import 'package:sweetpet/model/thumb.dart';
import 'package:uuid/uuid.dart';

/// `PostController` manages the state and functionality for displaying post details.
///
/// This controller is responsible for fetching and updating post details, comments,
/// user follow statuses, and managing user interactions like commenting and following.
///
/// ## Usage:
/// ```dart
/// PostController controller = Get.put(PostController());
/// ```
class PostController extends GetxController {
  /// The detailed information about the post.
  late PostDetail postDetail;

  /// The unique identifier for the post.
  late String id;

  /// Loading state indicator.
  bool isLoading = true;

  /// Failure state indicator.
  bool isFail = false;

  /// The user ID.
  late String userId = '';

  /// User avatar URL.
  late String avatar = '';

  /// User username.
  late String username = '';

  /// List of comments on the post.
  List<Comment> commentList = [];

  /// List of thumbs (likes) on the post.
  late List<THUMB> thumbs = [];

  /// List of followers for the user.
  late List<Follower> followers = [];

  /// Follow status of the current user.
  late bool isFollowing = false;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments["id"];
    getIndexDetailData(id);
    getCommentList(id);
  }

  /// Fetch detailed information for a post by its [id].
  ///
  /// This function retrieves the user's data, updates the user's follow status, and fetches detailed information for the post with the specified [id].
  ///
  /// Parameters:
  /// - [id]: A string representing the unique identifier of the post to fetch.
  ///
  /// Example:
  /// ```dart
  /// // Fetch detailed information for a post with the specified id
  /// getIndexDetailData('12345');
  /// ```
  ///
  /// Parameters:
  /// - [id]: A string representing the unique identifier of the post to fetch.
  ///
  void getIndexDetailData(String id) async {
    await getUserData(globalUid);
    await updateUserFollow();
    ApiClient().getIndexDetailDataById(id).then((response) {
      if (response != null) {
        postDetail = response;
        getFollowUser(postDetail.uid);
      } else {
        isFail = true;
      }
      update();
    }).catchError((onError) {
      isFail = true;
    }).whenComplete(() {
      isLoading = false;
    });
  }

  /// Fetch data from Firebase and update the user's follow statuses.
  Future<void> updateUserFollow() async {
    ApiClient().getUserFollowUsers().then((response) {
      followers = response;
      update();
    });
  }

  /// Get a list of people this user follows.
  Future getFollowUser(String toUserId) async {
    ApiClient().getFollowUser(toUserId).then((response) {
      isFollowing = response;
      update();
    });
  }

  /// Get the list of comments on this post.
  void getCommentList(String id) {
    ApiClient().getCommentList(id).then((response) {
      commentList = response;
      update();
    });
  }

  /// Upload user comments into Firebase.
  Future<void> uploadCommentToFirebase(Comment comment) async {
    try {
      await FirebaseFirestore.instance
          .collection('comment')
          .doc(comment.id)
          .set({
        'id': comment.id,
        'toPostId': comment.toPostId,
        'userId': comment.userId,
        'title': comment.title,
        'content': comment.content,
        'avatar': comment.avatar,
        'nickname': comment.nickname,
        'createDate': comment.createDate,
      });
      print('comment successful！');
    } catch (e) {
      print('error：$e');
    }
  }

  /// Send a comment for a specific post.
  ///
  /// This function retrieves the user's data, creates a new comment with the provided [content], uploads the comment to Firebase Firestore,
  /// and then fetches the updated list of comments for the specified post.
  ///
  /// Parameters:
  /// - [content]: A string representing the content of the comment.
  ///
  /// Example:
  /// ```dart
  /// // Send a comment for the current post
  /// sendComment('This is a great post!');
  /// ```
  ///
  /// Parameters:
  /// - [content]: A string representing the content of the comment.
  ///
  void sendComment(String content) async {
    try {
      await getUserData(globalUid);
      await createCommentAndUpload(content);
      getCommentList(id);
    } catch (error) {
      Get.snackbar('Error', 'Failed to upload images: ${error.toString()}');
    }
  }

  /// Create a comment and upload it to Firebase Firestore.
  ///
  /// This function creates a new comment object with the provided [content] and uploads it to the 'comment' collection
  /// in Firebase Firestore. The comment includes information such as the comment's unique identifier, the user who made
  /// the comment, the post it belongs to, and the timestamp of when it was created.
  ///
  /// Parameters:
  /// - [content]: A string representing the content of the comment.
  ///
  /// Example:
  /// ```dart
  /// // Create and upload a comment for a specific post
  /// createCommentAndUpload('This is a great post!');
  /// ```
  ///
  /// Parameters:
  /// - [content]: A string representing the content of the comment.
  ///
  Future<void> createCommentAndUpload(String content) async {
    final String commentId = const Uuid().v4();
    Comment comment = Comment(
      commentId,
      id,
      postDetail.uid,
      globalUsername,
      globalAvatar,
      postDetail.title,
      content,
      DateTime.now().toString(),
    );
    uploadCommentToFirebase(comment);
  }

  /// Modify the comment count of a post in Firebase Firestore.
  ///
  /// This function increments the comment count of a post in the 'post' collection in Firebase Firestore
  /// based on the provided [id]. It retrieves the current comment count, increments it by one, and updates
  /// the 'comment' field in the post document with the new count.
  ///
  /// Parameters:
  /// - [id]: A string representing the unique identifier of the post you want to modify.
  ///
  /// Example:
  /// ```dart
  /// // Modify the comment count for a specific post
  /// modifyPostCommentCount('postID');
  /// ```
  ///
  /// Parameters:
  /// - [id]: A string representing the unique identifier of the post you want to modify.
  ///
  void modifyPostCommentCount() async {
    QuerySnapshot thumbQuery1 = await FirebaseFirestore.instance
        .collection('post')
        .where('id', isEqualTo: id)
        .get();

    if (thumbQuery1.docs.isNotEmpty) {
      thumbQuery1.docs.forEach((QueryDocumentSnapshot doc) {
        DocumentReference thumbDocRef =
            FirebaseFirestore.instance.collection('post').doc(doc.id);
        int currentFav = doc['comment'] ?? 0;
        int newFav = currentFav + 1;
        Map<String, dynamic> updatedData = {
          'comment': newFav,
        };

        thumbDocRef.set(updatedData, SetOptions(merge: true)).then((_) {
          print('Comment count updated successfully for document ${doc.id}');
        }).catchError((error) {
          print('Error updating comment count for document ${doc.id}: $error');
        });
      });
    }
  }

  /// Get user data from Firebase Firestore.
  ///
  /// This function retrieves user data from the 'users' collection in Firebase Firestore
  /// based on the provided [uid]. It updates global variables [globalUsername] and [globalAvatar]
  /// with the user's username and avatar URL if the user exists.
  ///
  /// Parameters:
  /// - [uid]: A string representing the unique user ID whose data you want to retrieve.
  ///
  /// Example:
  /// ```dart
  /// // Retrieve user data for a specific user
  /// getUserData('userUID');
  /// ```
  ///
  /// Parameters:
  /// - [uid]: A string representing the unique user ID whose data you want to retrieve.
  ///
  Future<void> getUserData(String uid) async {
    try {
      DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      if (userSnapshot.exists) {
        Map<String, dynamic> userData =
            userSnapshot.data() as Map<String, dynamic>;
        globalUsername = userData['username'];
        globalAvatar = userData['image_url'];
      } else {
        print("User doesn't exist");
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Toggle the follow status and upload the follow relationship to Firebase.
  ///
  /// This function toggles the follow status (follow/unfollow) and then calls the
  /// [createFollowAndUpload] function to update the follow relationship on Firebase.
  /// It also prints the current follow status to the console.
  ///
  /// Example:
  /// ```dart
  /// // Toggle the follow status for a user or post
  /// toggleFollow();
  /// ```
  ///
  void toggleFollow() async {
    isFollowing = !isFollowing;
    createFollowAndUpload(postDetail.uid, isFollowing);
  }

  /// Upload follow status to Firebase.
  Future<void> uploadFollowToFirebase(Follower follower) async {
    try {
      await FirebaseFirestore.instance.collection('follow').doc().set({
        'id': follower.id,
        'followerId': follower.followerId,
        'toUserId': follower.toUserId,
        'avatar': follower.avatar,
        'username': follower.username,
        'tag': follower.tag,
      });
      print('successful！');
    } catch (e) {
      print('eroor：$e');
    }
  }

  /// Create a new follow relationship and upload it to Firebase.
  ///
  /// This function checks if a follow relationship between the current user
  /// (identified by [globalUid]) and the target user (identified by [toUserId])
  /// already exists in the 'follow' collection in Firestore. If a relationship exists,
  /// it updates the 'tag' field with the specified [tag] value. If no relationship exists,
  /// it creates a new follow relationship and uploads it to Firebase.
  ///
  /// Parameters:
  /// - [toUserId]: The ID of the target user to follow or unfollow.
  /// - [tag]: A boolean value representing the follow status (true for follow, false for unfollow).
  ///
  /// Example:
  /// ```dart
  /// // Follow a user with ID 'targetUserId'
  /// createFollowAndUpload('targetUserId', true);
  ///
  /// // Unfollow a user with ID 'targetUserId'
  /// createFollowAndUpload('targetUserId', false);
  /// ```
  ///
  /// Parameters:
  /// - [toUserId]: The ID of the target user.
  /// - [tag]: A boolean value indicating the follow status (true for follow, false for unfollow).
  ///
  Future<void> createFollowAndUpload(String toUserId, bool tag) async {
    QuerySnapshot thumbQuery = await FirebaseFirestore.instance
        .collection('follow')
        .where('followerId', isEqualTo: globalUid)
        .where('toUserId', isEqualTo: toUserId)
        .get();

    if (thumbQuery.docs.isNotEmpty) {
      thumbQuery.docs.forEach((QueryDocumentSnapshot doc) {
        DocumentReference thumbDocRef =
            FirebaseFirestore.instance.collection('follow').doc(doc.id);

        Map<String, dynamic> updatedData = {
          'tag': tag,
        };

        thumbDocRef.set(updatedData, SetOptions(merge: true)).then((_) {
          print('Follow status updated successfully for document ${doc.id}');
        }).catchError((error) {
          print('Error updating follow status for document ${doc.id}: $error');
        });
      });
    } else {
      final String id = const Uuid().v4();
      Follower newFollower = Follower(
        id,
        globalUid,
        toUserId,
        globalUsername,
        globalAvatar,
        tag,
      );
      uploadFollowToFirebase(newFollower);
    }
  }
}

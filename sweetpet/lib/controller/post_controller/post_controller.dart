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

  /// Get post-specific data from Firebase based on post IDs and refresh User Interface.
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

      print('Comment uploaded successfully!');
    } catch (e) {
      print('Error uploading comment: $e');
    }
  }

  /// After the user clicks the send button, the Comment model is generated and sent to Firebase.
  void sendComment(String content) async {
    try {
      await getUserData(globalUid);
      await createCommentAndUpload(content);
      getCommentList(id);
    } catch (error) {
      Get.snackbar('Error', 'Failed to upload comment: ${error.toString()}');
    }
  }

  /// Create Comment model and upload to Firebase.
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

  /// After a user comments, update the number of Comment properties in the post.
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

  /// Get user data from Firebase based on UID.
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

  /// Follow or unfollow the current user after the user clicks on the follow button.
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
      print('Followed successfully!');
    } catch (e) {
      print('Error following: $e');
    }
  }

  /// After the user clicks the follow button, the Follower model is generated and sent to Firebase.
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

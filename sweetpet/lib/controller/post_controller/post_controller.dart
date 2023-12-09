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

class PostController extends GetxController {
  late PostDetail postDetail;
  late String id;
  bool isLoading = true;
  bool isFail = false;
  late String userId = '';
  late String avatar = '';
  late String username = '';
  List<Comment> commentList = [];
  late List<THUMB> thumbs = [];
  late List<Follower> followers = [];
  late bool isFollowing = false;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments["id"];
    getIndexDetailData(id);
    getCommentList(id);
  }

  /// Get post specific data from Firebase based on post ids and refresh User Interface
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

  /// Fetching data from firebase and updating the user's follow statuses
  Future<void> updateUserFollow() async {
    ApiClient().getUserFollowUsers().then((response) {
      followers = response;
      update();
    });
  }

  /// Get a list of people this user follows
  Future getFollowUser(String toUserId) async {
    ApiClient().getFollowUser(toUserId).then((response) {
      isFollowing = response;
      update();
    });
  }

  /// Get the list of comments on this post
  void getCommentList(String id) {
    ApiClient().getCommentList(id).then((response) {
      commentList = response;
      update();
    });
  }

  /// Upload user comments into Firebase
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

      print('评论上传成功！');
    } catch (e) {
      print('上传帖子时出现错误：$e');
    }
  }

  /// After the user clicks the send button, the Comment model is generated and sent to Firebase
  void sendComment(String content) async {
    try {
      await getUserData(globalUid);
      // 等待 imagesUrls 获取完成后再执行 createPostAndUpload
      await createCommentAndUpload(content);
      getCommentList(id);
    } catch (error) {
      // 处理上传图片失败的情况
      Get.snackbar('Error', 'Failed to upload images: ${error.toString()}');
    }
  }

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
    // 调用上传方法
    uploadCommentToFirebase(comment);
  }

  /// After a user comments, update the number of Comment properties in the post
  void modifyPostCommentCount() async {
    // 查询 thumb 集合以查找匹配的文档
    QuerySnapshot thumbQuery1 = await FirebaseFirestore.instance
        .collection('post')
        .where('id', isEqualTo: id)
        .get();

    if (thumbQuery1.docs.isNotEmpty) {
      // 如果找到匹配的文档，更新 tag 字段
      thumbQuery1.docs.forEach((QueryDocumentSnapshot doc) {
        DocumentReference thumbDocRef =
            FirebaseFirestore.instance.collection('post').doc(doc.id);
        int currentFav = doc['comment'] ?? 0;
        // 计算新的 fav 值
        int newFav = currentFav + 1;
        Map<String, dynamic> updatedData = {
          'comment': newFav, // 更新 tag 字段
        };

        thumbDocRef.set(updatedData, SetOptions(merge: true)).then((_) {
          print('Tag updated successfully for document ${doc.id}');
        }).catchError((error) {
          print('Error updating tag for document ${doc.id}: $error');
        });
      });
    }
  }

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
        print("user doesn't exit");
      }
    } catch (e) {
      print('error: $e');
    }
  }

  /// Follow the current user after the user clicks on the follow button
  void toggleFollow() async {
    print(isFollowing);
    isFollowing = !isFollowing;
    createFollowAndUpload(postDetail.uid, isFollowing);
  }

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
      print('关注成功！');
    } catch (e) {
      print('关注出现错误：$e');
    }
  }

  /// After the user clicks the follow button, the Follower model is generated and sent to Firebase
  Future<void> createFollowAndUpload(String toUserId, bool tag) async {
    // 查询 thumb 集合以查找匹配的文档
    QuerySnapshot thumbQuery = await FirebaseFirestore.instance
        .collection('follow')
        .where('followerId', isEqualTo: globalUid)
        .where('toUserId', isEqualTo: toUserId)
        .get();

    if (thumbQuery.docs.isNotEmpty) {
      // 如果找到匹配的文档，更新 tag 字段
      thumbQuery.docs.forEach((QueryDocumentSnapshot doc) {
        DocumentReference thumbDocRef =
            FirebaseFirestore.instance.collection('follow').doc(doc.id);

        Map<String, dynamic> updatedData = {
          'tag': tag, // 更新 tag 字段
        };

        thumbDocRef.set(updatedData, SetOptions(merge: true)).then((_) {
          print('Tag updated successfully for document ${doc.id}');
        }).catchError((error) {
          print('Error updating tag for document ${doc.id}: $error');
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
      // 调用上传方法
      uploadFollowToFirebase(newFollower);
    }
  }
}

import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/constant/uid.dart';
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
  List<Comment> commentList = [];
  late List<THUMB> thumbs = [];
  late String userId;
  late String avatarUrl;
  late String userName;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments["id"];
    getIndexDetailData(id);
    getCommentList(id);
  }

  void getIndexDetailData(String id) async {
    await updateUserThumbPosts();
    ApiClient().getIndexDetailDataById(id).then((response) {
      if (response != null) {
        postDetail = response;
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

  void getCommentList(String id) {
    ApiClient().getCommentList(id).then((response) {
      commentList = response;
      update();
    });
  }

  Future<void> uploadCommentToFirebase(Comment comment) async {
    try {
      await FirebaseFirestore.instance
          .collection('comment')
          .doc(comment.id)
          .set({
        'id': comment.id,
        'toPostId': comment.toPostId,
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
      userName,
      avatarUrl,
      content,
      DateTime.now().toString(),
    );
    // 调用上传方法
    uploadCommentToFirebase(comment);
  }

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

  Future<void> updateUserThumbPosts() async {
    thumbs = await ApiClient().getUserThumbPosts();
  }

  Future<void> uploadThumbToFirebase(THUMB thumb) async {
    try {
      await FirebaseFirestore.instance.collection('thumb').doc().set({
        'id': thumb.id,
        'postId': thumb.postId,
        'userId': thumb.userId,
        'tag': thumb.tag,
      });
      print('点赞成功！');
    } catch (e) {
      print('点赞出现错误：$e');
    }
  }

  Future<void> createThumbAndUpload(String postId, int tag) async {
    // 查询 thumb 集合以查找匹配的文档
    QuerySnapshot thumbQuery = await FirebaseFirestore.instance
        .collection('thumb')
        .where('userId', isEqualTo: globalUid)
        .where('postId', isEqualTo: postId)
        .get();

    if (thumbQuery.docs.isNotEmpty) {
      // 如果找到匹配的文档，更新 tag 字段
      thumbQuery.docs.forEach((QueryDocumentSnapshot doc) {
        DocumentReference thumbDocRef =
            FirebaseFirestore.instance.collection('thumb').doc(doc.id);

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
      THUMB newThumb = THUMB(
        id,
        globalUid,
        postId,
        tag,
      );
      // 调用上传方法
      uploadThumbToFirebase(newThumb);
    }
  }

  void modifyPostFavCount(String postId, int num) async {
    // 查询 thumb 集合以查找匹配的文档
    QuerySnapshot thumbQuery1 = await FirebaseFirestore.instance
        .collection('postView')
        .where('id', isEqualTo: postId)
        .get();
    QuerySnapshot thumbQuery2 = await FirebaseFirestore.instance
        .collection('post')
        .where('id', isEqualTo: postId)
        .get();

    if (thumbQuery1.docs.isNotEmpty && thumbQuery2.docs.isNotEmpty) {
      // 如果找到匹配的文档，更新 tag 字段
      thumbQuery1.docs.forEach((QueryDocumentSnapshot doc) {
        DocumentReference thumbDocRef =
            FirebaseFirestore.instance.collection('postView').doc(doc.id);
        // 计算新的 fav 值
        int newFav = max(0, num);
        Map<String, dynamic> updatedData = {
          'fav': newFav, // 更新 tag 字段
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
      // 计算新的 fav 值
      int newFav = max(0, num);
      Map<String, dynamic> updatedData = {
        'fav': newFav, // 更新 tag 字段
      };

      thumbDocRef.set(updatedData, SetOptions(merge: true)).then((_) {
        print('Tag updated successfully for document ${doc.id}');
      }).catchError((error) {
        print('Error updating tag for document ${doc.id}: $error');
      });
    });
  }
}

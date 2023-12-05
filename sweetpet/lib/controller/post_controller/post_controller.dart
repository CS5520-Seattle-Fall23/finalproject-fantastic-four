import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/constant/uid.dart';
import 'package:sweetpet/model/post_detail.dart';
import 'package:sweetpet/model/comment.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class PostController extends GetxController {
  late PostDetail postDetail;
  late String id;
  bool isLoading = true;
  bool isFail = false;
  List<Comment> commentList = [];
  late String userId;
  late String avatarUrl;
  late String userName;

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments["id"];
    getIndexDetailData(id);
    getCommentList();
  }

  void getIndexDetailData(String id) async {
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

  void getCommentList() {
    ApiClient().getCommentList().then((response) {
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
        'like': comment.like,
        'isLike': comment.isLike,
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
      0,
      false,
    );
    // 调用上传方法
    uploadCommentToFirebase(comment);
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

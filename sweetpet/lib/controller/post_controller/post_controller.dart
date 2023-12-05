import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/model/post_detail.dart';
import 'package:sweetpet/model/comment.dart';
import 'package:get/get.dart';

class PostController extends GetxController {
  late PostDetail postDetail;
  late String id;
  bool isLoading = true;
  bool isFail = false;
  List<Comment> commentList = [];

  @override
  void onInit() {
    super.onInit();
    id = Get.arguments["id"];
    getIndexDetailData(id);
    getCommentList();
  }

  void getIndexDetailData(String id) {
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
}

import 'dart:convert';
import 'dart:typed_data';
import 'package:sweetpet/fakeData/fake.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sweetpet/model/post.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  ApiClient._internal();
  factory ApiClient() => _instance;
  static final ApiClient _instance = ApiClient._internal();
  List<Post> convertDynamicListToPostList(List<dynamic> dynamicList) {
    return dynamicList.map((dynamic item) => Post.fromJson(item)).toList();
  }

  // MainView Data
  Future<dynamic> getIndexData() async {
    try {
      // 获取 Firebase Storage 实例
      FirebaseStorage storage = FirebaseStorage.instance;

      // 获取文件的引用，路径应根据您的 Firebase Storage 结构调整
      Reference ref = storage.ref('posts/postData.json');

      // 获取文件的下载 URL
      String url = await ref.getDownloadURL();
      // 使用 http 包下载文件
      final response = await http.get(Uri.parse(url));
      List<Post> data =
          convertDynamicListToPostList(json.decode(response.body));
      return data;
    } catch (e) {
      // 打印并处理任何异常
      print('Error occurred while fetching data: $e');
      return null;
    }
  }

  // Post Detail Data
  Future getIndexDetailDataById(String id) async {
    await Future.delayed(const Duration(seconds: 1));
    for (var v in FakeData.cardDetailDataList) {
      if (v.id == id) {
        return await Future.value(v);
      }
    }
    return null;
  }

  Future getCommentList() async {
    await Future.delayed(const Duration(seconds: 1));
    return await Future.value(FakeData.commentList);
  }
}

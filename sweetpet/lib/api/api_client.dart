import 'package:sweetpet/fakeData/fake.dart';

class ApiClient {
  ApiClient._internal();
  factory ApiClient() => _instance;
  static final ApiClient _instance = ApiClient._internal();

  // MainView Data
  Future getIndexData() async {
    await Future.delayed(const Duration(seconds: 1));
    return await Future.value(FakeData.indexData);
  }

  // Post Detail Data
  Future getIndexDetailDataById(int id) async {
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

import 'package:sweetpet/fakeData/fake.dart';

class ApiClient {
  ApiClient._internal();
  factory ApiClient() => _instance;
  static final ApiClient _instance = ApiClient._internal();

  // 获取首页"发现"数据
  Future getIndexData() async {
    await Future.delayed(const Duration(seconds: 1));
    return await Future.value(FakeData.indexData);
  }
}

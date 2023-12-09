// 创建一个模拟的网络请求接口
import 'package:sweetpet/model/comment.dart';
import 'package:sweetpet/model/post_detail.dart';

class MockApiClient {
  Future<PostDetail> getIndexDetailDataById(String id) async {
    // 这里可以返回模拟数据或者使用 Mockito 创建模拟对象来进行测试
    return PostDetail(
      '1', // 替换为实际的帖子ID
      '2222', // 替换为实际的头像URL
      'Post Title', // 替换为实际的帖子标题
      'Post Content', // 替换为实际的帖子内容
      'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1',
      'John Doe', // 替换为实际的昵称
      10,
      20,
      "2023.10.23",
      [
        'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1'
      ], // 替换为实际的图片URL列表
      // 填充模拟数据
    );
  }

  Future<List<Comment>> getCommentListData() async {
    // 这里可以返回模拟数据或者使用 Mockito 创建模拟对象来进行测试
    return [
      Comment(
        '1', // 替换为实际的帖子ID
        '2222', // 替换为实际的头像URL
        '3333',
        'user', // 替换为实际的帖子标题
        'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1',
        'Post Content', // 替换为实际的帖子内容
        'John Doe', // 替换为实际的昵称
        "2023.10.23",
      ),
    ];
  }
}

import 'package:flutter/material.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/model/comment.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  late List<Comment> commentsData;

  @override
  void initState() {
    super.initState();
    commentsData = [];
    // 在初始化时调用方法来获取评论数据
    fetchCommentsData();
  }

  Future<void> fetchCommentsData() async {
    try {
      // 执行网络请求，获取评论数据
      List<Comment> fetchedData =
          await ApiClient().getCommentListData(); // 请替换成你的实际网络请求代码
      setState(() {
        commentsData = fetchedData;
      });
    } catch (e) {
      // 处理异常
      print("Error fetching comments data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: commentsData != null
          ? ListView.builder(
              itemCount: commentsData.length,
              itemBuilder: (context, index) {
                Comment item = commentsData[index];
                return CommentTile(
                  userName: item.nickname,
                  postTitle: item.title,
                  commentContent: item.content,
                  avatarUrl: item.avatar,
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(), // 加载指示器
            ),
    );
  }
}

class CommentTile extends StatelessWidget {
  final String userName;
  final String postTitle;
  final String commentContent;
  final String avatarUrl;

  const CommentTile({
    Key? key,
    required this.userName,
    required this.postTitle,
    required this.commentContent,
    required this.avatarUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl),
      ),
      title: Text(userName),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            postTitle,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(commentContent),
        ],
      ),
      onTap: () {},
    );
  }
}

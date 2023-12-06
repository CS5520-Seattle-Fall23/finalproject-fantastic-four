import 'package:flutter/material.dart';

class CommentsPage extends StatefulWidget {
  @override
  _CommentsPageState createState() => _CommentsPageState();
}

class _CommentsPageState extends State<CommentsPage> {
  final List<Map<String, String>> commentsData = [
    {
      'userName': 'User1',
      'postTitle': 'Title1',
      'commentContent': 'comment1 === xxxxx',
    },
    {
      'userName': 'User2',
      'postTitle': 'Title2',
      'commentContent': 'comment2 === xxxxx',
    },
    // ... 更多评论数据
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comments'),
      ),
      body: ListView.builder(
        itemCount: commentsData.length,
        itemBuilder: (context, index) {
          final item = commentsData[index];
          return CommentTile(
            userName: item['userName']!,
            postTitle: item['postTitle']!,
            commentContent: item['commentContent']!,
            avatarUrl: 'https://example.com/user_avatar_${index + 1}.png',
          );
        },
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

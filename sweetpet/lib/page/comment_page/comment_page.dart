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
    fetchCommentsData();
  }

  /// Fetches and updates the comments data for a specific post.
  ///
  /// This function retrieves a list of comments for a specific post using the `ApiClient`.
  /// It then updates the `commentsData` state variable to reflect the fetched comments.
  ///
  /// Example:
  /// ```dart
  /// // Fetch and update comments data for a post
  /// await fetchCommentsData();
  /// ```
  ///
  /// Note: Ensure that the `ApiClient` is properly configured and that the `commentsData` state variable is appropriately initialized before calling this function.
  ///
  Future<void> fetchCommentsData() async {
    try {
      List<Comment> fetchedData = await ApiClient().getCommentListData();
      setState(() {
        commentsData = fetchedData;
      });
    } catch (e) {
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

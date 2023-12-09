import 'package:flutter/material.dart';
import 'package:sweetpet/model/thumb.dart';

class LikeButton extends StatefulWidget {
  final int initialCount;
  final Function(int tag, int num)? onLiked;
  final List<THUMB> userLikedPosts;
  final String postId;

  LikeButton(
      {required this.initialCount,
      this.onLiked,
      required this.userLikedPosts,
      required this.postId});

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialCount;
    isLiked =
        widget.userLikedPosts.any((thumb) => thumb.postId == widget.postId);
  }

  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });
    // 调用回调方法，如果回调存在的话
    if (isLiked == true && widget.onLiked != null) {
      widget.onLiked!(1, likeCount);
    } else if (isLiked == false && widget.onLiked != null) {
      widget.onLiked!(2, likeCount);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleLike,
      child: Row(
        children: [
          Image.asset(
            isLiked ? 'assets/images/liked.png' : 'assets/images/like.png',
            width: 20,
          ),
          Text(likeCount.toString()),
        ],
      ),
    );
  }
}

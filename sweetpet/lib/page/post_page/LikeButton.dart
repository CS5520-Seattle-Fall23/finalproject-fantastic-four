import 'package:flutter/material.dart';
import 'package:sweetpet/model/thumb.dart';

/// `LikeButton` is a customizable widget for handling like interactions.
///
/// This widget allows users to toggle between liking and unliking content.
/// It displays an icon representing the like state and the current like count.
///
/// ## Features:
/// - Toggle between liking and unliking content.
/// - Displays like icon and like count.
/// - Customizable through parameters like `initialCount`, `onLiked`, `userLikedPosts`, and `postId`.
///
/// ## Usage:
/// ```dart
/// LikeButton(
///   initialCount: 10,
///   onLiked: (tag, num) {
///     // Handle like events
///   },
///   userLikedPosts: userLikes,
///   postId: 'unique_post_id',
/// )
/// ```
class LikeButton extends StatefulWidget {
  /// The initial like count.
  final int initialCount;

  /// Callback function called when the like status changes.
  /// The function receives two parameters: `tag` and `num`.
  /// - `tag`: 1 if liked, 2 if unliked.
  /// - `num`: The updated like count.
  final Function(int tag, int num)? onLiked;

  /// List of liked posts by the user.
  final List<THUMB> userLikedPosts;

  /// Unique identifier for the post.
  final String postId;

  /// Constructor for `LikeButton`.
  LikeButton({
    required this.initialCount,
    this.onLiked,
    required this.userLikedPosts,
    required this.postId,
  });

  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  /// The current like status.
  bool isLiked = false;

  /// The current like count.
  int likeCount = 0;

  @override
  void initState() {
    super.initState();
    likeCount = widget.initialCount;
    isLiked =
        widget.userLikedPosts.any((thumb) => thumb.postId == widget.postId);
  }

  /// Function to toggle the like status.
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
      likeCount += isLiked ? 1 : -1;
    });

    // Invoke the callback method if it exists.
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

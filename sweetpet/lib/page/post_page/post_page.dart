import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sweetpet/model/post_detail.dart';
import 'package:sweetpet/model/thumb.dart';
import 'package:sweetpet/util/date_util.dart';
import 'package:sweetpet/constant/color_library.dart';
import 'package:sweetpet/controller/post_controller/post_controller.dart';
import 'package:get/get.dart';

class PostPage extends StatefulWidget {
  PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  PostController controller = Get.put(PostController());
  TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostController>(builder: (_) {
      if (controller.isLoading) {
        return const Scaffold(
            body: Center(
                child: CircularProgressIndicator(color: ColorLibrary.primary)));
      } else if (controller.isFail) {
        return const Scaffold(body: Center(child: Text("Load failure")));
      }
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Row(
            children: [
              ClipOval(
                child: Image.network(
                  controller.postDetail.avatar,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(controller.postDetail.nickname),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.toggleFollow();
                setState(() {}); // 通知框架重新构建页面
              },
              style: TextButton.styleFrom(
                primary: Colors.white,
                backgroundColor:
                    controller.isFollowing ? Colors.grey : Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                ),
              ),
              child: Text(controller.isFollowing ? 'No Follow' : 'Follow'),
            )
          ],
        ),
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    buildImageSwiper(),
                    buildContent(),
                    buildComment(),
                  ],
                ),
              ),
              buildBottom(controller.thumbs),
            ],
          ),
        ),
      );
    });
  }

  Widget buildImageSwiper() {
    return SizedBox(
      height: Get.height * 2 / 3,
      child: Swiper(
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            controller.postDetail.images[index],
            width: Get.width,
            fit: BoxFit.contain,
          );
        },
        loop: false,
        itemCount: controller.postDetail.images.length,
        indicatorLayout: PageIndicatorLayout.SCALE,
        pagination: const SwiperPagination(
          builder: DotSwiperPaginationBuilder(
            activeColor: ColorLibrary.primary,
            color: ColorLibrary.grey,
          ),
        ),
      ),
    );
  }

  Widget buildContent() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            controller.postDetail.title,
            style: const TextStyle(fontSize: 16),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              controller.postDetail.content,
              style: const TextStyle(color: Color(0xff333333)),
            ),
          ),
          const Divider(thickness: 0.5)
        ],
      ),
    );
  }

  Widget buildComment() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "total ${controller.commentList.length} comments",
            style: const TextStyle(color: ColorLibrary.black6),
          ),
          ...controller.commentList.map((e) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: ClipOval(
                      child: Image.network(
                        e.avatar,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(bottom: 14),
                      decoration: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: ColorLibrary.grey, width: 0.5))),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(e.nickname,
                                      style: const TextStyle(
                                          color: Colors.grey, fontSize: 14)),
                                  RichText(
                                      text: TextSpan(
                                          style: const TextStyle(
                                              color: ColorLibrary.black3),
                                          text: e.content,
                                          children: [
                                        TextSpan(
                                          text:
                                              "  ${SDateUtils.formatDate(e.createDate)}",
                                          style: const TextStyle(
                                              color: ColorLibrary.black9),
                                        ),
                                      ])),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget buildBottom(List<THUMB> list) {
    Widget buildIcon(String iconPath, int count) {
      return GestureDetector(
        onTap: () {},
        child: Row(
          children: [
            Image.asset(iconPath, width: 30, height: 30),
            Text(count.toString()),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 12.0),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: const ShapeDecoration(
                  shape: StadiumBorder(), color: ColorLibrary.background),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: 170,
                      height: 30,
                      child: TextField(
                        controller: commentController,
                        decoration: const InputDecoration(
                          hintText: 'Type',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.sendComment(commentController.text);
              controller.modifyPostCommentCount();
              commentController.clear();
            },
            child: const Text('Send'),
          ),
        ],
      ),
    );
  }
}

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
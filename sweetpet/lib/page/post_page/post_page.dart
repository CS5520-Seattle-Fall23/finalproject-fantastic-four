import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sweetpet/model/post_detail.dart';
import 'package:sweetpet/model/thumb.dart';
import 'package:sweetpet/util/date_util.dart';
import 'package:sweetpet/constant/color_library.dart';
import 'package:sweetpet/controller/post_controller/post_controller.dart';
import 'package:get/get.dart';

/// `PostPage` widget displays details of a post including images, content, and comments.
///
/// This widget includes a swiper for image viewing, post content, and a comment section.
/// Users can interact with the post by leaving comments and reacting with emojis.
/// The page also provides options for following the post creator and navigating back.
///
/// ## Features:
/// - Image swiper to navigate through multiple images.
/// - Post title, content, and comments display.
/// - User interaction for following and reacting to the post.
///
/// ### Dependencies:
/// - [card_swiper](https://pub.dev/packages/card_swiper): A swiper package for Flutter.
/// - [date_util](https://pub.dev/packages/date_util): A utility package for handling dates.
/// - [Get](https://pub.dev/packages/get): A state management package for Flutter.
///
/// ## Usage:
/// ```dart
/// PostPage()
/// ```
class PostPage extends StatefulWidget {
  PostPage({Key? key}) : super(key: key);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  /// Controller for managing post-related functionalities.
  final PostController controller = Get.put(PostController());

  /// Controller for handling comments input.
  final TextEditingController commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PostController>(builder: (_) {
      // Widget for handling loading and failure states.
      if (controller.isLoading) {
        return const Scaffold(
            body: Center(
                child: CircularProgressIndicator(color: ColorLibrary.primary)));
      } else if (controller.isFail) {
        return const Scaffold(body: Center(child: Text("Load failure")));
      }

      // Main Scaffold widget displaying post details.
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
              // User avatar display.
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
            // Button to toggle following status.
            TextButton(
              onPressed: () {
                controller.toggleFollow();
                setState(() {}); // Notify the framework to rebuild the page.
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

  /// Widget for displaying an image swiper to navigate through multiple images.
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

  /// Widget for building and displaying post content.
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

  /// Widget for building and displaying comments section.
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
                  // User avatar for each comment.
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
                                  // Displaying comment content and date.
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

  /// Widget for building and displaying the bottom section including comment input.
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
          // Button to send comments.
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

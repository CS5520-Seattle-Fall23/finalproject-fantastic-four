import 'package:flutter/material.dart';
import 'package:sweetpet/constant/color_library.dart';
import 'package:sweetpet/model/post.dart';
import 'package:get/get.dart';

import 'package:sweetpet/controller/index_controller/index_controller.dart';
import 'package:sweetpet/model/thumb.dart';
import 'package:sweetpet/page/health_page/health_page.dart';
import 'package:sweetpet/page/mall_page/mall_page.dart';

class IndexPage extends StatefulWidget {
  IndexPage({Key? key}) : super(key: key);

  @override
  _IndexPageState createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  final IndexController controller = Get.put(IndexController());

  /// Initialize page data
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorLibrary.background,
        body: Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 52),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 250,
                    child: TabBar(
                      labelColor: Colors.black,
                      dividerColor: Colors.transparent,
                      indicatorColor: ColorLibrary.primary,
                      controller: controller.tabController,
                      tabs: const [
                        Tab(text: "Health"),
                        Tab(text: "Find"),
                        Tab(text: "Mall"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: onRefresh,
                child: GetBuilder<IndexController>(
                  builder: (_) {
                    return TabBarView(
                      controller: controller.tabController,
                      children: [
                        buildFollowPage(),
                        buildDiscoverPage(),
                        buildShoppingPage(),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Method of refreshing data
  Future<void> onRefresh() async {
    await controller.refreshData();
  }

  /// Build Health Page
  Widget buildFollowPage() {
    return SummaryPage();
  }

  /// Build Discover Page
  Widget buildDiscoverPage() {
    int halfLength = (controller.data.length / 2).ceil();
    return RefreshIndicator(
      onRefresh: () async {
        // 在此处执行刷新操作，例如从服务器获取新数据
        await onRefresh(); // 替换为您的刷新逻辑
      },
      child: ListView(
        children: [
          Row(
            children: [
              Column(
                children: controller.data
                    .sublist(0, halfLength)
                    .map((e) => buildCardItem(e, controller.thumbs))
                    .toList(),
              ),
              Column(
                children: controller.data
                    .sublist(halfLength)
                    .map((e) => buildCardItem(e, controller.thumbs))
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build Shopping Mall Page
  Widget buildShoppingPage() {
    return PetDiscoveryPage();
  }

  /// Build Posts
  Widget buildCardItem(Post post, List<THUMB> list) {
    return GestureDetector(
      onTap: () {
        controller.openIndexDetailPage(post.id);
      },
      child: Container(
        width: (Get.width / 2) - 8,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                post.cover,
                width: Get.width / 2,
                height: Get.width / 2 + 30,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Text(post.content,
                  maxLines: 2, overflow: TextOverflow.ellipsis),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
              child: Row(
                children: [
                  ClipOval(
                    child: Image.network(post.avatar,
                        width: 30, height: 30, fit: BoxFit.cover),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(post.nickname),
                  ),
                  const Spacer(),
                  LikeButton(
                    initialCount: post.fav,
                    onLiked: (tag, num) {
                      // 在这里调用 controller 中的方法
                      controller.createThumbAndUpload(post.id, post.uid, tag);
                      controller.modifyPostFavCount(post.id, num);
                    },
                    userLikedPosts: list,
                    postId: post.id,
                  ),
                ],
              ),
            )
          ],
        ),
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

  /// Click on the Like button to cancel the Like if it is already in the Like status, or to proceed if it is in the Unliked status
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

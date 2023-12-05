import 'package:flutter/material.dart';
import 'package:sweetpet/constant/color_library.dart';
import 'package:sweetpet/model/post.dart';
import 'package:get/get.dart';

import 'package:sweetpet/controller/index_controller/index_controller.dart';
import 'package:sweetpet/page/mall_page/mall_page.dart';

class IndexPage extends StatelessWidget {
  IndexPage({Key? key}) : super(key: key);
  final IndexController controller = Get.put(IndexController());

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
                  Spacer(),
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
                  const SizedBox(width: 20),
                  Image.asset(
                    "assets/images/search.png",
                    width: 30,
                    height: 30,
                  ),
                ],
              ),
            ),
            Expanded(
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
          ],
        ),
      ),
    );
  }

  Widget buildFollowPage() {
    return const Center(child: Text("Coding"));
  }

  Widget buildDiscoverPage() {
    int halfLength = (controller.data.length / 2).ceil();
    return ListView(
      children: [
        Image.asset(
          "assets/images/test.png",
          width: 300,
          height: 200,
        ),
        Row(
          children: [
            Column(
              children: controller.data
                  .sublist(0, halfLength)
                  .map((e) => buildCardItem(e))
                  .toList(),
            ),
            Column(
              children: controller.data
                  .sublist(halfLength)
                  .map((e) => buildCardItem(e))
                  .toList(),
            ),
          ],
        ),
      ],
    );
  }

  Widget buildShoppingPage() {
    return PetDiscoveryPage();
  }

  Widget buildCardItem(Post post) {
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
                  Image.asset("assets/images/like.png", width: 20),
                  Text(post.fav.toString())
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sweetpet/constant/color_library.dart';
import 'package:sweetpet/controller/like_controller/like_controller.dart';
import 'package:sweetpet/model/post.dart';
import 'package:get/get.dart';

import 'package:sweetpet/controller/index_controller/index_controller.dart';

class LikePage extends StatelessWidget {
  LikePage({Key? key}) : super(key: key);
  final LikeController controller = Get.put(LikeController());

  @override
  Widget build(BuildContext context) {
    // controller.data.clear();
    // controller.getIndexData();
    // controller.update();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.of(context).pop(), // 添加返回功能
          ),
          title: const Text('Like Page'), // 可以根据您的需求自定义标题
          // 其他 AppBar 配置...
        ),
        backgroundColor: ColorLibrary.background,
        body: Column(
          children: [
            Expanded(
              child: GetBuilder<LikeController>(
                builder: (_) {
                  return TabBarView(
                    controller: controller.tabController,
                    children: [
                      buildLikePage(),
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

  Widget buildLikePage() {
    int halfLength = (controller.data.length / 2).ceil();
    return ListView(
      children: [
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
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

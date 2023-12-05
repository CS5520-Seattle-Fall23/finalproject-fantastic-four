import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:sweetpet/model/post_detail.dart';
import 'package:sweetpet/util/date_util.dart';
import 'package:sweetpet/constant/color_library.dart';
import 'package:sweetpet/controller/post_controller/post_controller.dart';
import 'package:get/get.dart';

class PostPage extends StatelessWidget {
  PostPage({Key? key}) : super(key: key);
  final PostController controller = Get.put(PostController());

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
            title: Row(
              children: [
                ClipOval(
                    child: Image.network(
                  controller.postDetail.avatar,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                )),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(controller.postDetail.nickname),
                ),
              ],
            ),
            actions: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                decoration: const ShapeDecoration(
                    shape: StadiumBorder(
                        side: BorderSide(color: ColorLibrary.primary))),
                child: const Text(
                  "Follow",
                  style: TextStyle(color: ColorLibrary.primary, fontSize: 12),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 12.0, right: 14),
                child: Image.asset("assets/images/share.png",
                    width: 20, height: 20),
              ),
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
                buildBottom(),
              ],
            ),
          ));
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
                                        TextSpan(
                                            text: "  Reply",
                                            style: const TextStyle(
                                                color: ColorLibrary.black3),
                                            recognizer: TapGestureRecognizer()
                                              ..onTap = () {
                                                print("Reply");
                                              })
                                      ])),
                                ],
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              Image.asset(
                                "assets/images/like.png",
                                width: 20,
                                height: 20,
                              ),
                              Text(e.like.toString()),
                            ],
                          )
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

  Widget buildBottom() {
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
              child: const Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: SizedBox(
                      width: 170,
                      height: 30,
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Type...',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Image.asset("assets/images/like.png", width: 30, height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(controller.postDetail.like.toString()),
          ),
          Image.asset("assets/images/fav.png", width: 30, height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(controller.postDetail.fav.toString()),
          ),
          Image.asset("assets/images/comment.png", width: 30, height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(controller.postDetail.comment.toString()),
          ),
        ],
      ),
    );
  }
}

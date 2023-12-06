import 'package:flutter/material.dart';
import 'package:sweetpet/constant/color_library.dart';
import 'package:get/get.dart';
import 'package:sweetpet/controller/chat_controller/chat_controller.dart';

import 'package:sweetpet/controller/message_controller/message_controller.dart';
import 'package:sweetpet/page/follow_page/follow_page.dart';
import 'package:sweetpet/page/like_page/like_page.dart';
import 'package:sweetpet/page/comment_page/comment_page.dart';

class MessagePage extends StatelessWidget {
  MessagePage({Key? key}) : super(key: key);
  final MessageController controller = Get.put(MessageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Messages"),
        actions: const [],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildIcon(
                    "assets/images/liked.png", "Like", ColorLibrary.primary,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LikePage()),
                  );
                }),
                buildIcon("assets/images/user.png", "Follow", Colors.blue, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FollowersPage()),
                  );
                }),
                buildIcon("assets/images/comment2.png", "Comment", Colors.green,
                    () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommentsPage()),
                  );
                }),
              ],
            ),
          ),
          buildMessage(context),
          buildMessage(context),
          buildMessage(context),
        ],
      ),
    );
  }

  Widget buildIcon(String iconPath, String text, Color color, Function onTap) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Image.asset(iconPath, width: 30, height: 30),
          ),
          Text(text),
        ],
      ),
    );
  }

  Widget buildMessage(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: GestureDetector(
        // or InkWell for ripple effect
        onTap: () {
          // Navigate to chat_controller screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChatController()),
          );
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 8, right: 12),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: Image.asset("assets/images/message.png",
                  width: 30, height: 30),
            ),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Notice", style: TextStyle(fontSize: 16)),
                      Text("Sunday",
                          style: TextStyle(
                              fontSize: 12, color: ColorLibrary.black9)),
                    ],
                  ),
                  Text(
                    "Notification:test function ---- A",
                    style: TextStyle(color: ColorLibrary.black9),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

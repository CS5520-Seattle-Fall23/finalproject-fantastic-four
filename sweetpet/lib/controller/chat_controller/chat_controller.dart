import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:sweetpet/page/chat_page/chat_message.dart';
import 'package:sweetpet/page/chat_page/new_message.dart';

class ChatController extends StatefulWidget {
  const ChatController({super.key});

  @override
  State<ChatController> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatController> {
  void setupPushNotifications() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();

    // final token = await fcm.getToken();
    // could send this token to a backend (via http or firebase sdk)

    fcm.subscribeToTopic('chat');
  }

  @override
  void initState() {
    super.initState();

    setupPushNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Flutter Chat'),
        backgroundColor: const Color.fromARGB(255, 43, 108, 206).withAlpha(180),
      ),
      body: const Column(
        children: [
          Expanded(
            child: ChatMessages(),
          ),
          NewMessage(),
        ],
      ),
    );
  }
}

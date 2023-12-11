import 'package:sweetpet/page/chat_page/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

/// A widget that displays chat messages in a ListView.
///
/// It listens to a stream of chat messages from Firestore and updates the UI accordingly.
class ChatMessages extends StatelessWidget {
  /// Constructor for the [ChatMessages] widget.
  ///
  /// Uses the default key provided by the [super] constructor.
  const ChatMessages({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the currently authenticated user
    final authenticatedUser = FirebaseAuth.instance.currentUser!;

    return Container(
      // Container decoration for the chat messages section
      decoration: BoxDecoration(
        color: Colors.blue[300],
      ),
      // StreamBuilder to listen to changes in the 'chat' collection in Firestore
      child: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chat')
            .orderBy(
              'createdAt',
              descending: true,
            )
            .snapshots(),
        builder: (ctx, chatSnapshots) {
          // Loading indicator when connection is in the waiting state
          if (chatSnapshots.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          // Display a message when no chat messages are available
          if (!chatSnapshots.hasData || chatSnapshots.data!.docs.isEmpty) {
            return const Center(
              child: Text('No messages found.'),
            );
          }
          // Display an error message if an error occurs during snapshot processing
          if (chatSnapshots.hasError) {
            return const Center(
              child: Text('Something went wrong...'),
            );
          }

          // Extract loaded chat messages from the snapshot data
          final loadedMessages = chatSnapshots.data!.docs;

          // Build a ListView of chat messages using a ListView.builder
          return ListView.builder(
            padding: const EdgeInsets.only(
              bottom: 40,
              left: 13,
              right: 13,
            ),
            reverse: true, // Display the latest messages at the bottom
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, idx) {
              // Extract data for the current chat message and the next one (if available)
              final chatMessage = loadedMessages[idx].data();
              final nextChatMessage = idx + 1 < loadedMessages.length
                  ? loadedMessages[idx + 1].data()
                  : null;

              // Extract user IDs for the current and next messages
              final currentMessageUserId = chatMessage['userId'];
              final nextMessageUserId =
                  nextChatMessage != null ? nextChatMessage['userId'] : null;

              // Check if the user is the same in the next message
              final nextUserIsSame = currentMessageUserId == nextMessageUserId;

              // Render the appropriate message bubble based on the user and message type
              if (nextUserIsSame) {
                return MessageBubble.next(
                  time: chatMessage['createdAt'],
                  message: chatMessage['text'],
                  isMe: authenticatedUser.uid == currentMessageUserId,
                );
              } else {
                return MessageBubble.first(
                  time: chatMessage['createdAt'],
                  userImage: chatMessage['userImage'],
                  username: chatMessage['username'],
                  message: chatMessage['text'],
                  isMe: authenticatedUser.uid == currentMessageUserId,
                );
              }
            },
          );
        },
      ),
    );
  }
}

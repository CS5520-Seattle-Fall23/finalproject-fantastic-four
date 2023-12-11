import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/constant/uid.dart';
import 'package:sweetpet/model/follower.dart';
import 'package:sweetpet/model/thumb.dart';
import 'package:uuid/uuid.dart';

class FollowersPage extends StatefulWidget {
  FollowersPage({Key? key}) : super(key: key);

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  late List<Follower> followers;
  @override
  void initState() {
    super.initState();
    followers = [];
    fetchCommentsData();
  }

  /// Fetches and updates the follower data for the current user.
  ///
  /// This function retrieves a list of followers for the current user using the `ApiClient`.
  /// It then updates the `followers` state variable to reflect the fetched follower data.
  ///
  /// Example:
  /// ```dart
  /// // Fetch and update follower data for the current user
  /// await fetchFollowerData();
  /// ```
  ///
  /// Note: Ensure that the `ApiClient` is properly configured, and that the `followers` state variable is appropriately initialized before calling this function.
  ///
  Future<void> fetchCommentsData() async {
    try {
      List<Follower> fetchedData = await ApiClient().getFollowerListData();
      setState(() {
        followers = fetchedData;
      });
    } catch (e) {
      print("Error fetching comments data: $e");
    }
  }

  void _toggleFollow(String id) {
    setState(() {
      final follower = followers.firstWhere((follower) => follower.id == id);
      follower.tag = !follower.tag;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: followers != null
          ? ListView.builder(
              itemCount: followers.length,
              itemBuilder: (context, index) {
                final follower = followers[index];
                print(follower.avatar);
                return FollowerTile(
                  avatarUrl: follower.avatar,
                  name: follower.username,
                  tag: follower.tag,
                  onFollowTap: () => _toggleFollow(follower.id),
                );
              },
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class FollowerTile extends StatelessWidget {
  final String avatarUrl;
  final String name;
  final bool tag;
  final VoidCallback onFollowTap;

  const FollowerTile({
    Key? key,
    required this.avatarUrl,
    required this.name,
    required this.tag,
    required this.onFollowTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(avatarUrl),
      ),
      title: Text(name),
      trailing: Wrap(
        spacing: 12,
        children: <Widget>[
          TextButton(
            child: Text(tag ? 'No Follow' : 'Follow'),
            onPressed: onFollowTap,
            style: TextButton.styleFrom(
              primary: Colors.white,
              backgroundColor: tag ? Colors.grey : Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> uploadFollowToFirebase(Follower follower) async {
  try {
    await FirebaseFirestore.instance.collection('follow').doc().set({
      'id': follower.id,
      'followerId': follower.followerId,
      'toUserId': follower.toUserId,
      'avatar': follower.avatar,
      'username': follower.username,
      'tag': follower.tag,
    });
    print('successful！');
  } catch (e) {
    print('error：$e');
  }
}

/// Creates and uploads a new follower record to Firebase Firestore.
///
/// This function checks if there is an existing follower record between the current user (identified by `globalUid`)
/// and the target user (identified by `toUserId`). If an existing record is found, it updates the 'tag' field to reflect
/// the new follow status (`tag` is `true` for following, `false` for unfollowing). If no existing record is found,
/// it creates a new follower record with a unique ID and uploads it to Firebase Firestore.
///
/// Parameters:
/// - `toUserId`: The user ID of the target user.
/// - `tag`: A boolean value indicating whether the user is following (`true`) or unfollowing (`false`) the target user.
///
/// Example:
/// ```dart
/// // Follow the target user
/// await createFoAndUpload('targetUserId', true);
/// ```
///
/// Note: Ensure that the `globalUid`, `globalUsername`, and `globalAvatar` variables are appropriately initialized before calling this function.
///
Future<void> createFoAndUpload(String toUserId, bool tag) async {
  QuerySnapshot thumbQuery = await FirebaseFirestore.instance
      .collection('follow')
      .where('followerId', isEqualTo: globalUid)
      .where('toUserId', isEqualTo: toUserId)
      .get();

  if (thumbQuery.docs.isNotEmpty) {
    thumbQuery.docs.forEach((QueryDocumentSnapshot doc) {
      DocumentReference thumbDocRef =
          FirebaseFirestore.instance.collection('follow').doc(doc.id);

      Map<String, dynamic> updatedData = {
        'tag': tag,
      };

      thumbDocRef.set(updatedData, SetOptions(merge: true)).then((_) {
        print('Tag updated successfully for document ${doc.id}');
      }).catchError((error) {
        print('Error updating tag for document ${doc.id}: $error');
      });
    });
  } else {
    final String id = const Uuid().v4();
    Follower newFollower = Follower(
      id,
      globalUid,
      toUserId,
      globalUsername,
      globalAvatar,
      tag,
    );
    uploadFollowToFirebase(newFollower);
  }
}

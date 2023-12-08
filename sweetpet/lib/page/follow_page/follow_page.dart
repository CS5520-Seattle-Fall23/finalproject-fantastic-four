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

  Future<void> fetchCommentsData() async {
    try {
      // 执行网络请求，获取评论数据
      List<Follower> fetchedData =
          await ApiClient().getFollowerListData(); // 请替换成你的实际网络请求代码
      setState(() {
        followers = fetchedData;
      });
    } catch (e) {
      // 处理异常
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
              child: CircularProgressIndicator(), // 加载指示器
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
    print('关注成功！');
  } catch (e) {
    print('关注出现错误：$e');
  }
}

Future<void> createFoAndUpload(String toUserId, bool tag) async {
  // 查询 thumb 集合以查找匹配的文档
  QuerySnapshot thumbQuery = await FirebaseFirestore.instance
      .collection('follow')
      .where('followerId', isEqualTo: globalUid)
      .where('toUserId', isEqualTo: toUserId)
      .get();

  if (thumbQuery.docs.isNotEmpty) {
    // 如果找到匹配的文档，更新 tag 字段
    thumbQuery.docs.forEach((QueryDocumentSnapshot doc) {
      DocumentReference thumbDocRef =
          FirebaseFirestore.instance.collection('follow').doc(doc.id);

      Map<String, dynamic> updatedData = {
        'tag': tag, // 更新 tag 字段
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
    // 调用上传方法
    uploadFollowToFirebase(newFollower);
  }
}

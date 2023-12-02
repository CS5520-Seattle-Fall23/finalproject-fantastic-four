import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweetpet/model/follower.dart';

class FollowersPage extends StatefulWidget {
  const FollowersPage({Key? key}) : super(key: key);

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {
  late List<Follower> followers;

  @override
  void initState() {
    super.initState();
    followers = [
      Follower(
        id: '1',
        avatarUrl: 'https://via.placeholder.com/150/0000FF/808080?Text=User1',
        name: 'User1',
        tag: true,
      ),
      Follower(
        id: '2',
        avatarUrl: 'https://via.placeholder.com/150/FF0000/FFFFFF?Text=User2',
        name: 'User2',
        tag: false,
      ),
      Follower(
        id: '3',
        avatarUrl: 'https://via.placeholder.com/150/FFFF00/000000?Text=User3',
        name: 'User',
        tag: false,
      ),
    ];
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
        title: Text('Followers'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView.builder(
        itemCount: followers.length,
        itemBuilder: (context, index) {
          final follower = followers[index];
          return FollowerTile(
            avatarUrl: follower.avatarUrl,
            name: follower.name,
            tag: follower.tag,
            onFollowTap: () => _toggleFollow(follower.id),
          );
        },
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

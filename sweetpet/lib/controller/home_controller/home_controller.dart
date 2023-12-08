import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetpet/model/post_detail.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;
  RxList<PostDetail> posts = <PostDetail>[].obs;

  void onChangePage(int index) {
    currentIndex.value = index;
  }

  Future<void> getPosts() async {
    try {
      final QuerySnapshot<Map<String, dynamic>> postSnapshot =
          await FirebaseFirestore.instance.collection('post').get();

      posts.clear(); // Clear existing posts before adding new ones

      postSnapshot.docs.forEach((DocumentSnapshot<Map<String, dynamic>> doc) {
        final Map<String, dynamic> data = doc.data()!;
        final post = PostDetail.fromJson(data);
        posts.add(post);
      });

      // Sort the posts based on the date in descending order
      posts.sort((a, b) => b.date.compareTo(a.date));

      // Update the UI
      update();
    } catch (error) {
      print('Error fetching posts: $error');
    }
  }
}

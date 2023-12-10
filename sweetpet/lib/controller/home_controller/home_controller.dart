import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sweetpet/model/post_detail.dart';

/// Controller responsible for managing the state of the home screen.
class HomeController extends GetxController {
  /// Observable representing the current index of the home screen.
  RxInt currentIndex = 0.obs;

  /// Observable list containing [PostDetail] objects representing posts.
  RxList<PostDetail> posts = <PostDetail>[].obs;

  /// Method to change the current page index.
  ///
  /// Called when the user interacts with the page navigation.
  void onChangePage(int index) {
    currentIndex.value = index;
  }

  /// Asynchronous method to fetch posts from Firestore.
  ///
  /// Fetches posts from the 'post' collection and updates the observable list.
  /// Posts are sorted based on their date in descending order.
  Future<void> getPosts() async {
    try {
      // Fetch posts from Firestore
      final QuerySnapshot<Map<String, dynamic>> postSnapshot =
          await FirebaseFirestore.instance.collection('post').get();

      // Clear existing posts before adding new ones
      posts.clear();

      // Convert Firestore documents to PostDetail objects and add them to the list
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
      // Print an error message if fetching posts fails
      print('Error fetching posts: $error');
    }
  }
}

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class PublishController extends GetxController {
  var selectedImages = <XFile>[].obs;

  void pickImages() async {
    final ImagePicker picker = ImagePicker();
    try {
      final List<XFile>? images = await picker.pickMultiImage();
      if (images != null) {
        selectedImages.value = images;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick images: ${e.toString()}');
    }
  }

  void savePost() {
    // Implement the save functionality
    Get.snackbar('Success', 'Post saved successfully');
  }

  void sharePost() {
    // Implement the share functionality
    Get.snackbar('Success', 'Post shared successfully');
  }

  void goBack() {
    Get.back();
  }
}

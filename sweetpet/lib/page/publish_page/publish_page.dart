import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:sweetpet/controller/publish_controller/publish_controller.dart';

class PublishPage extends StatelessWidget {
  final PublishController controller = Get.put(PublishController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Publish Post'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: controller.goBack,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() {
                if (controller.selectedImages.isEmpty) {
                  return Container(
                    width: double.infinity, // 占据全部宽度
                    height: 200, // 占位符高度
                    color: Colors.grey[300],
                    child:
                        Icon(Icons.image, size: 100, color: Colors.grey[600]),
                  );
                } else {
                  return Wrap(
                    children: controller.selectedImages
                        .map((image) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Image.file(File(image.path),
                                  width: 100, height: 100),
                            ))
                        .toList(),
                  );
                }
              }),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: controller.pickImages,
                child: Text('Pick Images'),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Add title....',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: TextField(
                maxLines: 5, // 增加TextField的行数
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Write your post content here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.savePost,
                      child: Text('Save'),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.sharePost,
                      child: Text('Share'),
                      style: ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

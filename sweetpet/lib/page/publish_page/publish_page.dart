import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:sweetpet/controller/publish_controller/publish_controller.dart';

class PublishPage extends StatelessWidget {
  final PublishController controller = Get.put(PublishController());
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Publish Post',
          style: TextStyle(
            fontSize: 30,
            fontFamily: 'Hiatus',
            color: Color.fromARGB(255, 106, 187, 241),
          ),
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
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                onPressed: controller.pickImages,
                child: const Text(
                  'Pick Images',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Mont',
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 106, 187, 241),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: titleController, // 使用TextEditingController
                decoration: const InputDecoration(
                  labelText: 'Add title....',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: contentController, // 使用TextEditingController
                maxLines: 5, // 增加TextField的行数
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  labelText: 'Write your post content here...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.savePost,
                      child: const Text('Save'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.sharePost(
                            titleController.text, contentController.text);
                      },
                      child: Text('Share'),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromARGB(188, 106, 225, 241)),
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

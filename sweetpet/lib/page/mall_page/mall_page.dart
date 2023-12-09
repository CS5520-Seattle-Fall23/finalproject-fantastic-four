import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweetpet/controller/home_controller/home_controller.dart';
import 'package:sweetpet/page/mall_page/pet_shop_page.dart';

class MallPage extends StatelessWidget {
  MallPage({Key? key}) : super(key: key);
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Discovery Page',
      home: PetDiscoveryPage(),
    );
  }
}

class PetDiscoveryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mall'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: 'Find the best for your pet...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: const <Widget>[
                PetCategoryWidget(
                  imageName: 'assets/images/dog.png',
                  categoryName: 'Dog',
                ),
                PetCategoryWidget(
                  imageName: 'assets/images/cat.png',
                  categoryName: 'Cat',
                ),
                // Add more categories as needed
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PetCategoryWidget extends StatelessWidget {
  final String imageName;
  final String categoryName;

  const PetCategoryWidget({
    Key? key,
    required this.imageName,
    required this.categoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Image.asset(
        imageName,
        width: 100,
        height: 100,
      ),
      title: Text(
        categoryName,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      ),
      onTap: () {
        // Handle tap
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PetShopPage(
                    name: categoryName,
                  )),
        );
      },
    );
  }
}

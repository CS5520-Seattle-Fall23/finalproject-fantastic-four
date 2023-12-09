import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweetpet/controller/home_controller/home_controller.dart';
import 'package:sweetpet/page/mall_page/pet_shop_page.dart';


/// This is  the entrance of the pet mall. It manages the application's state and logic with a homeController instance, created or found using Get.put().It returns a MaterialApp with PetDiscoveryPage as its home in the build method.
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

/// This is the homepage of mall.It includes an AppBar with a title and a Column layout, consisting of a Padding-wrapped TextFormField for search, and a ListView displaying pet categories using PetCategoryWidget instances, like dogs and cats.
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
              children: <Widget>[
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

/// This class is a StatelessWidget designed to display individual pet categories in the user interface. It accepts the image name and category name of the pet as parameters. When a user taps on this widget, it navigates to the corresponding PetShopPage for that category, enhancing user interaction and experience.
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
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24.0,
        ),
      ),
      onTap: () {
        // Handle tap
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PetShopPage(name: categoryName,)),
        );
      },
    );
  }
}
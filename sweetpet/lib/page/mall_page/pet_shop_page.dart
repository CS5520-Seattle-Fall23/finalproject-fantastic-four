import 'package:flutter/material.dart';
import 'package:sweetpet/page/mall_page/shopping_list_page.dart';


/// This class is designed to display a list of products for specific pet categories, like dogs or cats. It includes a field named name, which is used to identify the pet category. Based on this category, the class determines which products to display.
class PetShopPage extends StatelessWidget {

  final String name;

  PetShopPage({
    Key? key,
    required this.name,
  }) : super(key: key);


  final List<PetProduct> products = [
    PetProduct(imageUrl: 'assets/images/dog_food.png', name: 'Food'),
    PetProduct(imageUrl: 'assets/images/dogtreat.png', name: 'Treats'),
    PetProduct(imageUrl: 'assets/images/dogtoy.png', name: 'Toys'),
    PetProduct(imageUrl: 'assets/images/dogtreatment.png', name: 'Treatment'),
    // 添加更多产品
  ];

  final List<PetProduct> products_cat = [
    PetProduct(imageUrl: 'assets/images/catfood.png', name: 'Food'),
    PetProduct(imageUrl: 'assets/images/cattreat.png', name: 'Treats'),
    PetProduct(imageUrl: 'assets/images/cattoy.png', name: 'Toys'),
    PetProduct(imageUrl: 'assets/images/cattreatment.jpg', name: 'Treatment'),
    // 添加更多产品
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mall'),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Find the best for your pet...',
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.8,
              ),
              itemCount: name == 'Dog' ? products.length : products_cat.length,
              itemBuilder: (context, index) {
                return PetProductWidget(product: name == 'Dog' ? products[index] : products_cat[index], category: name);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// This class represents a model for an individual pet product. Each PetProduct object contains the product's image URL (imageUrl) and its name (name).
class PetProduct {
  final String imageUrl;
  final String name;

  PetProduct({required this.imageUrl, required this.name});
}

/// This class is used to display individual pet products in the user interface. It takes a PetProduct object and a category name as parameters. When clicked, it navigates to the detailed product page (ShopList). The widget includes a card view featuring the product's image and name.
class PetProductWidget extends StatelessWidget {
  final PetProduct product;
  final String category;

  const PetProductWidget({Key? key, required this.product, required this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShopList(product.name, category)),
        );
      },
      child: Card(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Image.asset(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                product.name,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

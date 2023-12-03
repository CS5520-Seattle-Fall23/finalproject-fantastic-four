import 'package:flutter/material.dart';
import 'package:sweetpet/page/mall_page/shopping_list_page.dart';

class PetShopPage extends StatelessWidget {

  final String name;

  PetShopPage({
    Key? key,
    required this.name,
  }) : super(key: key);


  final List<PetProduct> products = [
    PetProduct(imageUrl: 'assets/images/dog_food.png', name: 'Food'),
    PetProduct(imageUrl: 'assets/images/dog_food.png', name: 'Treats'),
    PetProduct(imageUrl: 'assets/images/dog_food.png', name: 'Toys'),
    PetProduct(imageUrl: 'assets/images/dog_food.png', name: 'Treatment'),
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
              itemCount: products.length,
              itemBuilder: (context, index) {
                return PetProductWidget(product: products[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PetProduct {
  final String imageUrl;
  final String name;

  PetProduct({required this.imageUrl, required this.name});
}

class PetProductWidget extends StatelessWidget {
  final PetProduct product;

  const PetProductWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
       onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ShopList()),
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

import 'package:flutter/material.dart';

class ShopList extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Shop',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Mall'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Handle back button
               Navigator.pop(context);
            },
        ),
        ),
        body: ListView(
          children: <Widget>[
            CategoryHeader(title: 'Dog/Food'),
            Padding(
            padding: const EdgeInsets.all(8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Find the best for your pet...',
                ),
              ),
            ),
            ProductTile(
              name: 'Purina Pro Plan Sensitive Skin & Stomach Adult with Probiotics Lamb & Oat Meal F...',
              price: 'US\$71.98',
              originalPrice: 'US\$74.99',
              image: 'assets/purina_pro_plan.jpg', // Add your asset image
            ),
            ProductTile(
              name: 'Purina ONE Natural SmartBlend Chicken & Rice Formula Dry Dog Food, 40-lb...',
              price: 'US\$60.48',
              originalPrice: 'US\$62.88',
              image: 'assets/purina_one.jpg', // Add your asset image
            ),
            // ... more products
          ],
        ),
      ),
    );
  }
}

class CategoryHeader extends StatelessWidget {
  final String title;

  CategoryHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ProductTile extends StatelessWidget {
  final String name;
  final String price;
  final String originalPrice;
  final String image;

  ProductTile({
    required this.name,
    required this.price,
    required this.originalPrice,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Image.asset(
              image,
              width: 100, // Set your image width
              height: 100, // Set your image height
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    price,
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    originalPrice,
                    style: TextStyle(
                      color: Colors.grey,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ),
            // Implement more choices available if necessary
          ],
        ),
      ),
    );
  }
}
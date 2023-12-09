import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweetpet/controller/mall_controller/mall_controller.dart';
import 'package:sweetpet/model/mall.dart';
import 'package:sweetpet/page/mall_page/shopping_list_page.dart';
import 'package:url_launcher/url_launcher.dart';

///  This is a StatelessWidget designed to display detailed information about a specific shop in a mall. It takes a Mall type object, mall, as a parameter, showcasing the shop's title and image, and includes a button that, when clicked, attempts to open the shop's purchase link using the url_launcher package.
class ShopDetailPage extends StatelessWidget {
  final Mall mall;

  ShopDetailPage({
    Key? key,
    required this.mall,
  }) : super(key: key);

  void _submit() async {
    final Uri url = Uri.parse(mall.realBuyLink);
    if (!await launchUrl(url)) {
          throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mall'),
      ),
      body: Column(children: <Widget>[
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
            child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                mall.title,
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                mall.pic,
                fit: BoxFit.cover,
                height: 400,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
                child: Text('Link to ${mall.store}'),
              ),
            )
          ],
        )),
      ]),
    );
  }
}

/// This class is a simple model representing an individual pet product. It includes two fields: imageUrl (the link to the product's image) and name (the product's name).
class PetProduct {
  final String imageUrl;
  final String name;

  PetProduct({required this.imageUrl, required this.name});
}

///  This is a StatelessWidget for displaying a single pet product in the interface. It includes a PetProduct object as a parameter, displaying the product's image and name. Clicking on the widget closes the current view.
class PetProductWidget extends StatelessWidget {
  final PetProduct product;

  const PetProductWidget({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
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
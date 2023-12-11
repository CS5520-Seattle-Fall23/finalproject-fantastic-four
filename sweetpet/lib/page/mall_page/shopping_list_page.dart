import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweetpet/controller/mall_controller/mall_controller.dart';
import 'package:sweetpet/model/mall.dart';
import 'package:sweetpet/page/mall_page/shopping_detail_page.dart';

/// This StatelessWidget that creates and displays a pet shop list for a specific category. 
class ShopList extends StatelessWidget {
  final String name;
  final String category;

  ShopList(this.name, this.category);

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
        body: PetDiscoveryPage(name: name, category: category),
      ),
    );
  }
}

///This stateful widget designed to display pet products for a selected category and name. It takes category name and type as parameters and contains a search box and a list view of pet products.
class PetDiscoveryPage extends StatefulWidget {
  final String name;
  final String category;

  const PetDiscoveryPage({Key? key, required this.name, required this.category}) : super(key: key);

  @override
  _PetDiscoveryPageState createState() => _PetDiscoveryPageState(name, category);
}

///This class is the state management class for PetDiscoveryPage, responsible for handling the page's state and logic. It includes references to MallController, manages the search text state, and maintains a list of pet products. The class implements the initialization of data fetching, search functionality, and the logic to construct individual pet product items.
class _PetDiscoveryPageState extends State<PetDiscoveryPage> {
  final String name;
  final String category;
  final MallController controller = Get.put(MallController());
  late String searchText = '';
  List<Mall> mallList = [];

  _PetDiscoveryPageState(this.name, this.category);

  void _onSearchChanged(text) async {
    setState(() => searchText = text);
  }

  getMallList() async {
    controller.getMallData(category, name).then((value) {
      setState(() {
        mallList = value;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    getMallList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${category}/${name}'),
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
              onChanged: _onSearchChanged,
            ),
          ),
          Expanded(
            child: ListView(
              children: <Widget>[
                Row(
                  children: [
                    Column(
                      children: mallList
                          .where((mall) => (searchText == '' ||
                              mall.title.contains(searchText)))
                          .toList()
                          .map((e) => buildCardItem(e, context))
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCardItem(Mall mall, BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ShopDetailPage(
                    mall: mall,
                  )),
        );
      },
      child: Container(
        width: Get.width,
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                mall.pic,
                width: Get.width / 2 - 100,
                height: Get.width / 2 - 100,
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
                child: Column(
              children: [
                Text(mall.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(mall.price,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.red[700],
                      )),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweetpet/controller/home_controller/home_controller.dart';
import 'package:sweetpet/controller/mall_controller/mall_controller.dart';
import 'package:sweetpet/model/mall.dart';
import 'package:sweetpet/page/mall_page/pet_shop_page.dart';

class MallPage extends StatelessWidget {
  MallPage({Key? key}) : super(key: key);
  final HomeController homeController = Get.put(HomeController());
  final MallController controller = Get.put(MallController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pet Discovery Page',
      home: PetDiscoveryPage(),
    );
  }
}

class PetDiscoveryPage extends StatefulWidget {
  const PetDiscoveryPage({Key? key}) : super(key: key);

  @override
  _PetDiscoveryPageState createState() => _PetDiscoveryPageState();
}

class _PetDiscoveryPageState extends State<PetDiscoveryPage> {
  final MallController controller = Get.put(MallController());
  late String searchText = '';
  List<Mall> mallList = [];

  void _onSearchChanged(text) async {
    setState(() => searchText = text);
  }

  getMallList() async {
    controller.getMallData().then((value) {
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
              builder: (context) => PetShopPage(
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

// class PetCategoryWidget extends StatelessWidget {
//   final String imageName;
//   final String categoryName;

//   const PetCategoryWidget({
//     Key? key,
//     required this.imageName,
//     required this.categoryName,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       leading: Image.asset(
//         imageName,
//         width: 100,
//         height: 100,
//       ),
//       title: Text(
//         categoryName,
//         style: TextStyle(
//           fontWeight: FontWeight.bold,
//           fontSize: 24.0,
//         ),
//       ),
//       onTap: () {
//         // Handle tap
//         Navigator.push(
//           context,
//           MaterialPageRoute(builder: (context) => PetShopPage(name: categoryName,)),
//         );
//       },
//     );
//   }
// }
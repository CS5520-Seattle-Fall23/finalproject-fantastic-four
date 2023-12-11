import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweetpet/controller/home_controller/home_controller.dart';
import 'package:sweetpet/page/index_page/index_page.dart';
import 'package:sweetpet/page/message_page/message_page.dart';
import 'package:sweetpet/page/publish_page/publish_page.dart';
// import 'package:firebase_storage/firebase_storage.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);
  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: homeController.currentIndex.value,
          children: [
            IndexPage(),
            // Container(color: Colors.blue),
            PublishPage(),
            MessagePage(),
          ],
        ),
        bottomNavigationBar: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            elevation: 0,
            iconSize: 24,
            unselectedItemColor: const Color(0xff999999),
            type: BottomNavigationBarType.fixed,
            currentIndex: homeController.currentIndex.value,
            unselectedFontSize: 16,
            selectedFontSize: 18,
            items: [
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/Mainview.png',
                  width: 32,
                  height: 32,
                ),
                activeIcon: Image.asset(
                  'assets/images/Mainview.png',
                  width: 32,
                  height: 32,
                ),
                label: "Main",
              ),
              const BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_box,
                  size: 32,
                  color: Colors.red,
                ),
                label: "",
              ),
              BottomNavigationBarItem(
                icon: Image.asset(
                  'assets/images/Mine.png',
                  width: 32,
                  height: 32,
                ),
                activeIcon: Image.asset(
                  'assets/images/Mine.png',
                  width: 32,
                  height: 32,
                ),
                label: "Mine",
              ),
            ],
            onTap: (index) {
              homeController.onChangePage(index);
            },
          ),
        ),
      ),
    );
  }
}

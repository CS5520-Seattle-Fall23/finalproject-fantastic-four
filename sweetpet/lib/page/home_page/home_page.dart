import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sweetpet/controller/home_controller/home_controller.dart';

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
            Container(color: Colors.red),
            Container(color: Colors.blue),
            Container(color: Colors.orange),
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
                label: "",
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
                label: "",
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

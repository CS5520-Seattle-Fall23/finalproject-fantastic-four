import 'package:sweetpet/constant/pages.dart';
import 'package:sweetpet/controller/login_controller/login_controller.dart';
import 'package:sweetpet/page/home_page/home_page.dart';
import 'package:get/get.dart';
import 'package:sweetpet/page/mall_page/mall_page.dart';
import 'package:sweetpet/page/post_page/post_page.dart';

/// Generate different controllers for jumping through GetPage method
class Routes {
  static final List<GetPage> getPages = [
    GetPage(name: Pages.login, page: () => const LoginController()),
    GetPage(name: Pages.home, page: () => HomePage()),
    GetPage(name: Pages.indexDetail, page: () => PostPage()),
    GetPage(name: Pages.mall, page: () => MallPage()),
  ];
}

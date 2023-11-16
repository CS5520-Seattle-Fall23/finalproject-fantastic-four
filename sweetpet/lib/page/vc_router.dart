import 'package:sweetpet/constant/pages.dart';
import 'package:sweetpet/page/home_page/home_page.dart';
import 'package:get/get.dart';

class Routes {
  static final List<GetPage> getPages = [
    GetPage(name: Pages.home, page: () => HomePage()),
  ];
}

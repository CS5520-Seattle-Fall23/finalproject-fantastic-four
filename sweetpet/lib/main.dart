import 'package:bot_toast/bot_toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sweetpet/constant/pages.dart';
import 'package:sweetpet/controller/home_controller/home_controller.dart';
import 'package:sweetpet/controller/login_controller/login_controller.dart';
import 'package:sweetpet/page/home_page/home_page.dart';
import 'package:sweetpet/page/vc_router.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(750, 1334),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          title: 'SweetPet',
          builder: BotToastInit(),
          navigatorObservers: [BotToastNavigatorObserver()],
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.blue,
          ),
          getPages: Routes.getPages,
          initialRoute: Pages.login,
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              return const LoginController();
            },
          ),
        );
      },
    );
  }
}

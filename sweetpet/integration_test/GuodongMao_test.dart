import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/constant/pages.dart';
import 'package:sweetpet/controller/home_controller/home_controller.dart';
import 'package:sweetpet/controller/index_controller/index_controller.dart';
import 'package:sweetpet/controller/login_controller/login_controller.dart';
import 'package:sweetpet/controller/post_controller/post_controller.dart';
import 'package:sweetpet/main.dart';
import 'package:sweetpet/model/follower.dart';
import 'package:sweetpet/model/post.dart';
import 'package:sweetpet/model/post_detail.dart';
import 'package:sweetpet/model/thumb.dart';
import 'package:sweetpet/page/chat_page/chat_message.dart';
import 'package:sweetpet/page/follow_page/follow_page.dart';
import 'package:sweetpet/page/home_page/home_page.dart';
import 'package:sweetpet/page/index_page/index_page.dart';
import 'package:sweetpet/page/like_page/like_page.dart';
import 'package:sweetpet/page/message_page/message_page.dart';
import 'package:sweetpet/page/post_page/post_page.dart';
import 'package:sweetpet/page/publish_page/publish_page.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sweetpet/page/post_page/post_page.dart';

@GenerateMocks([http.Client])
void main() {
  Get.testMode = true;
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockFirebaseAuth mockFirebaseAuth; // 使用模拟Firebase身份验证

  setUpAll(() async {
    // 初始化Firebase
    await Firebase.initializeApp();

    // 初始化模拟Firebase身份验证
    mockFirebaseAuth = MockFirebaseAuth();
  });

  // testWidgets('Test Firebase Authentication', (WidgetTester tester) async {
  //   // 创建一个模拟的 FirebaseAuthMock 对象
  //   final auth = MockFirebaseAuth();

  //   // 使用模拟用户进行登录
  //   final user = await auth.signInWithEmailAndPassword(
  //     email: 'test@example.com',
  //     password: 'password123',
  //   );

  //   // 验证用户是否成功登录
  //   expect(user, isNotNull);
  //   expect(auth.currentUser, isNotNull);
  //   expect(auth.currentUser!.email, 'test@example.com');

  //   // 执行其他身份验证测试...
  // });

  testWidgets('Test Firebase authentication', (WidgetTester tester) async {
    // 在这里编写身份验证测试
    // 使用模拟Firebase身份验证来模拟身份验证操作
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    await tester.pumpWidget(const MaterialApp(
      home: LoginController(),
    ));

    final emailField = find.byKey(const Key('emailField'));
    final passwordField = find.byKey(const Key('passwordField'));
    final loginButton = find.byKey(const Key('loginButton'));
    expect(emailField, findsOneWidget);
    expect(passwordField, findsOneWidget);
    expect(loginButton, findsOneWidget);

    await tester.enterText(emailField, 'dong200323@163.com');
    await tester.enterText(passwordField, 'mao200323');
    await tester.pumpAndSettle();

    await tester.tap(loginButton);
    // await tester.pumpAndSettle(); // Wait for navigation to complete

    await tester.pumpWidget(GetMaterialApp(
      home: HomePage(),
    ));

    //   // Verify that the HomePage widget is displayed
    expect(find.byType(HomePage), findsOneWidget);

    // Verify that the initial page (IndexPage) is displayed
    expect(find.byType(IndexPage), findsOneWidget);
    expect(find.byType(PublishPage), findsNothing);
    expect(find.byType(MessagePage), findsNothing);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: IndexPage(),
      ),
    );

    await tester.pumpWidget(MaterialApp(home: PublishPage()));

    // 查找UI元素并测试它们的存在和可交互性
    expect(find.text('Publish Post'), findsOneWidget);
    expect(find.byKey(const Key('pickImagesButton')), findsOneWidget);
    expect(find.byKey(const Key('titleField')), findsOneWidget);
    expect(find.byKey(const Key('contentField')), findsOneWidget);
    expect(find.byKey(const Key('shareButton')), findsOneWidget);

    // 模拟输入文本
    await tester.enterText(find.byKey(const Key('titleField')), 'Test Title');
    await tester.enterText(
        find.byKey(const Key('contentField')), 'Test Content');

    // // 模拟按钮点击
    // await tester.tap(find.byKey(const Key('pickImagesButton')));
    // await tester.pumpAndSettle();

    // await tester.tap(find.byKey(const Key('shareButton')));

    // // 等待UI更新
    // await tester.pump();

    // 检查UI是否反应了模拟操作
    expect(find.text('Test Title'), findsOneWidget);
    expect(find.text('Test Content'), findsOneWidget);
    // expect(find.byType(Image), findsWidgets);

    await tester.pumpWidget(GetMaterialApp(
      home: MessagePage(),
    ));

    // 确保 MessagePage 已加载
    expect(find.text('Messages'), findsOneWidget);

    // 确保三个图标按钮已加载
    expect(find.byType(GestureDetector), findsNWidgets(4));

    // 构建测试页面
    await tester.pumpWidget(
      MaterialApp(
        // home: FollowersPage(),
        home: Scaffold(
          body: FollowersPage(),
        ),
      ),
    );

    // 等待页面加载完成
    // await tester.pumpAndSettle();

    // Add more test cases here to verify UI elements, interactions, etc.

    // For example, you can test if the app bar title is displayed correctly.
    expect(find.text('Followers'), findsOneWidget);

    // // You can also test if the back button is displayed.
    // expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FollowerTile(
            avatarUrl:
                'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1',
            name: 'John Doe',
            tag: true,
            onFollowTap: () {},
          ),
        ),
      ),
    );

    // Verify that the FollowerTile widget is displayed.
    expect(find.byType(FollowerTile), findsOneWidget);

    // // Add more test cases here to verify UI elements, interactions, etc.

    // // For example, you can test if the avatar is displayed.
    expect(find.byType(CircleAvatar), findsOneWidget);

    // // You can also test if the name is displayed.
    expect(find.text('John Doe'), findsOneWidget);

    // // You can test the Follow button text.
    expect(find.text('No Follow'), findsOneWidget);

    // You can simulate a tap on the Follow button and test if it triggers the callback.
    await tester.tap(find.text('No Follow'));
    await tester.pumpAndSettle();

    // expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    // // 模拟用户点击返回按钮
    // await tester.tap(find.byIcon(Icons.arrow_back));

    // // 等待页面刷新
    // await tester.pumpAndSettle();

    // await tester.pumpWidget(
    //   const MaterialApp(
    //     home: Scaffold(
    //       body: ChatMessages(),
    //     ),
    //   ),
    // );

    //   // 在页面上查找一些预期的小部件，例如 CircularProgressIndicator 或文本
    //   expect(find.byType(CircularProgressIndicator), findsOneWidget);

    //   // 模拟 Firestore 数据
    //   final messages = [
    //     {'userId': 'user1', 'text': 'Hello', 'createdAt': Timestamp.now()},
    //     {'userId': 'user2', 'text': 'Hi', 'createdAt': Timestamp.now()},
    //   ];

    //   // final collectionReference = firestore.collection('chat');
    //   // messages.forEach((message) {
    //   //   collectionReference.add(message);
    //   // });

    //   // 刷新页面以加载消息
    //   await tester.pumpAndSettle();

    //   // 验证消息是否正确显示
    //   expect(find.text('Hello'), findsOneWidget);
    //   expect(find.text('Hi'), findsOneWidget);
    // });

    // 模拟点击 "Like" 按钮
    // await tester.tap(find.byKey(const Key('LikePostsButton')));
    // await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        home: LikePage(),
      ),
    );

    // // 验证是否已导航到 LikePage 页面
    expect(find.byType(LikePage), findsOneWidget);
    expect(find.text('Like Page'), findsOneWidget);

    Get.testMode = true;
    Get.toNamed("/indexDetail", arguments: {'id': "1"});

    final controller = PostController();
    // controller.onInit();
    PostDetail postDetail = PostDetail(
      '1', // 替换为实际的帖子ID
      '2222', // 替换为实际的头像URL
      'Post Title', // 替换为实际的帖子标题
      'Post Content', // 替换为实际的帖子内容
      'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1',
      'John Doe', // 替换为实际的昵称
      10,
      20,
      "2023.10.23",
      [
        'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1'
      ], // 替换为实际的图片URL列表
    );
    controller.postDetail = postDetail;

    // 等待PostController的onInit完成
    await Future.delayed(const Duration(seconds: 3));

    await tester.pumpWidget(
      MaterialApp(
        home: GetBuilder<PostController>(
          init: controller, // 使用实际的PostController
          builder: (_) => PostPage(),
        ),
      ),
    );

    // 在这里编写测试代码，验证PostController的状态和行为
    // expect(controller.id, '1');
    // expect(controller.postDetail, postDetail);
    // 构建PostPage小部件

    // 验证页面是否正确构建
    // expect(find.text('John Doe'), findsOneWidget); // 验证昵称文本
    // expect(find.text('Post Title'), findsOneWidget); // 验证标题文本
    // expect(find.text('Post Content'), findsOneWidget); // 验证内容文本
    // expect(find.byType(Image), findsNWidgets(1)); // 验证图片数量
  });
}

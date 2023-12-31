import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/controller/home_controller/home_controller.dart';
import 'package:sweetpet/controller/index_controller/index_controller.dart';
import 'package:sweetpet/controller/login_controller/login_controller.dart';
import 'package:sweetpet/main.dart';
import 'package:sweetpet/model/follower.dart';
import 'package:sweetpet/model/post.dart';
import 'package:sweetpet/model/thumb.dart';
import 'package:sweetpet/page/chat_page/chat_message.dart';
import 'package:sweetpet/page/follow_page/follow_page.dart';
import 'package:sweetpet/page/health_page/add_sleep_data.dart';
import 'package:sweetpet/page/health_page/heart_rate.dart';
import 'package:sweetpet/page/health_page/sleep.dart';
import 'package:sweetpet/page/home_page/home_page.dart';
import 'package:sweetpet/page/index_page/index_page.dart';
import 'package:sweetpet/page/like_page/like_page.dart';
import 'package:sweetpet/page/message_page/message_page.dart';
import 'package:sweetpet/page/publish_page/publish_page.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

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

    // // Tap on the PublishPage icon in the bottom navigation
    // await tester.tap(find.byIcon(Icons.add_box));
    // await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        home: PublishPage(),
      ),
    );
    // // 确保 PublishPage 已加载
    // expect(find.text('Publish Post'), findsOneWidget);
    // expect(find.text('Pick Images'), findsOneWidget);
    // expect(find.text('Share'), findsOneWidget);

    // 输入标题和内容
    await tester.enterText(find.byKey(const Key('titleField')), 'Test Title');
    await tester.enterText(
        find.byKey(const Key('contentField')), 'Test Content');

    // // 模拟点击 "Pick Images" 按钮
    // await tester.tap(find.byKey(const Key('pickImagesButton')));
    // await tester.pumpAndSettle();

    // final firstImage = find.byType(Image).first;
    // await tester.tap(firstImage);
    // await tester.pumpAndSettle(); // 等待

    // // 模拟点击 "Share" 按钮
    await tester.tap(find.byKey(const Key('shareButton')));
    await tester.pumpAndSettle();

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
        home: FollowersPage(),
        // home: Scaffold(
        //   body: FollowersPage(),
        // ),
      ),
    );

    // 等待页面加载完成
    // await tester.pumpAndSettle();

    // Add more test cases here to verify UI elements, interactions, etc.

    // For example, you can test if the app bar title is displayed correctly.
    expect(find.text('Followers'), findsOneWidget);

    // You can also test if the back button is displayed.
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: FollowerTile(
            avatarUrl:
                'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1',
            name: 'John Doe',
            tag: false,
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
    expect(find.text('Follow'), findsOneWidget);

    // You can simulate a tap on the Follow button and test if it triggers the callback.
    await tester.tap(find.text('Follow'));
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
    expect(find.text('Like Page'), findsOneWidget);
    // expect(find.byIcon(Icons.arrow_back), findsOneWidget);
  });

  testWidgets('HeartRatePage UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: HeartRatePage(),
    ));

    // Verify that the AppBar title is displayed.
    expect(find.text('Heart Rate'), findsOneWidget);

    // Verify the existence of 'Add Data' button in the AppBar.
    expect(find.text('Add Data'), findsOneWidget);

    // Tap the 'Add Data' button and verify navigation.
    await tester.tap(find.text('Add Data'));
    await tester.pumpAndSettle();
    expect(find.text('Add Heart Rate Data'),
        findsOneWidget); // Assuming this is the title on the Add Data page.

    // Verify the existence of ToggleButtons.
    expect(find.byType(ToggleButtons), findsOneWidget);

    // Verify the existence of the 'Trend' text.
    expect(find.text('Trend'), findsOneWidget);
  });

  testWidgets('SleepPage UI Test', (WidgetTester tester) async {
    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: SleepPage(),
    ));

    // Verify that the AppBar title is displayed.
    expect(find.text('Sleep'), findsOneWidget);

    // Verify the existence of 'Add Data' button in the AppBar.
    expect(find.text('Add Data'), findsOneWidget);

    // Tap the 'Add Data' button and verify navigation.
    await tester.tap(find.text('Add Data'));
    await tester.pumpAndSettle();
    expect(find.text('Add Sleep Data'),
        findsOneWidget); // Assuming this is the title on the Add Data page.

    // Verify the existence of ToggleButtons.
    expect(find.byType(ToggleButtons), findsOneWidget);

    // Tap on one of the toggle buttons and verify the change.
    await tester.tap(find.text('W'));
    await tester.pump();
    expect(find.text('AVG. TIME IN BED'),
        findsOneWidget); // Check if UI updates accordingly.

    // Verify the existence of 'Trend' text.
    expect(find.text('Trend'), findsOneWidget);


    // Verify that the data displayed matches the expected format.
    final sleepTimeTextFinder = find.byWidgetPredicate((widget) =>
        widget is Text && (widget.data?.startsWith('TIME IN BED ') ?? false));
    expect(sleepTimeTextFinder, findsOneWidget);

    // Verify the presence of the Back button in the AppBar.
    expect(find.byType(BackButton), findsOneWidget);
  });

  group('AddSleepDataPage Tests', () {
    testWidgets('Page should have a title and action buttons',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddSleepDataPage()));

      // Verify the app bar title is present.
      expect(find.text('Add Sleep Data'), findsOneWidget);
      // Verify the cancel button is present.
      expect(find.byIcon(Icons.cancel), findsOneWidget);
      // Verify the add button is present.
      expect(find.text('Add'), findsOneWidget);
    });

    testWidgets('Should display DateTime pickers when tapping on fields',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddSleepDataPage()));

      // Tap on the 'In Bed' ListTile to trigger the date picker.
      await tester.tap(find.text('In Bed'));
      await tester.pump(); // Rebuild the widget after the state has changed.

      // Verify that the date and time pickers are displayed.
      expect(find.byType(DatePickerDialog), findsOneWidget);
      expect(find.byType(TimePickerDialog), findsOneWidget);
    });

    testWidgets('Add button should be disabled if form is not filled',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddSleepDataPage()));

      // Initially, the add button should be disabled.
      final addBtn =
          tester.widget<TextButton>(find.widgetWithText(TextButton, 'Add'));
      expect(addBtn.onPressed, isNull);
    });

    testWidgets('Add button should enable when form is filled',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home: AddSleepDataPage()));

      // Input mock data into the fields.
      await tester.enterText(find.byType(TextFormField).at(0), 'Dec 8, 2023');
      await tester.enterText(find.byType(TextFormField).at(1), '11:00 PM');
      await tester.enterText(find.byType(TextField),
          '5'); // Assuming this is an input field for hours of REM sleep.
      await tester.pumpAndSettle(); // Wait until all animations have completed.

      // The add button should now be enabled.
      final addBtn =
          tester.widget<TextButton>(find.widgetWithText(TextButton, 'Add'));
      expect(addBtn.onPressed, isNotNull);
    });

    group('AddSleepDataPage Tests', () {
      testWidgets('Page should have a title and action buttons',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: AddSleepDataPage()));

        // Verify the app bar title is present.
        expect(find.text('Add Sleep Data'), findsOneWidget);
        // Verify the cancel button is present.
        expect(find.byIcon(Icons.cancel), findsOneWidget);
        // Verify the add button is present.
        expect(find.text('Add'), findsOneWidget);
      });

      testWidgets('Should display DateTime pickers when tapping on fields',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: AddSleepDataPage()));

        // Tap on the 'In Bed' ListTile to trigger the date picker.
        await tester.tap(find.text('In Bed'));
        await tester.pump(); // Rebuild the widget after the state has changed.

        // Verify that the date and time pickers are displayed.
        expect(find.byType(DatePickerDialog), findsOneWidget);
        expect(find.byType(TimePickerDialog), findsOneWidget);
      });

      testWidgets('Add button should be disabled if form is not filled',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: AddSleepDataPage()));

        // Initially, the add button should be disabled.
        final addBtn =
            tester.widget<TextButton>(find.widgetWithText(TextButton, 'Add'));
        expect(addBtn.onPressed, isNull);
      });

      testWidgets('Add button should enable when form is filled',
          (WidgetTester tester) async {
        await tester.pumpWidget(MaterialApp(home: AddSleepDataPage()));

        // Input mock data into the fields.
        await tester.enterText(find.byType(TextFormField).at(0), 'Dec 8, 2023');
        await tester.enterText(find.byType(TextFormField).at(1), '11:00 PM');
        await tester.enterText(find.byType(TextField),
            '5'); // Assuming this is an input field for hours of REM sleep.
        await tester
            .pumpAndSettle(); // Wait until all animations have completed.

        // The add button should now be enabled.
        final addBtn =
            tester.widget<TextButton>(find.widgetWithText(TextButton, 'Add'));
        expect(addBtn.onPressed, isNotNull);
      });
    });
  });
}

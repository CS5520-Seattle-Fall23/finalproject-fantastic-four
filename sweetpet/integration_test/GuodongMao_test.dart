import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:sweetpet/api/api_client.dart';
import 'package:sweetpet/constant/pages.dart';
import 'package:sweetpet/controller/comment_controller/comment_controller.dart';
import 'package:sweetpet/controller/home_controller/home_controller.dart';
import 'package:sweetpet/controller/index_controller/index_controller.dart';
import 'package:sweetpet/controller/login_controller/forget_password.dart';
import 'package:sweetpet/controller/login_controller/login_controller.dart';
import 'package:sweetpet/controller/post_controller/post_controller.dart';
import 'package:sweetpet/main.dart';
import 'package:sweetpet/model/comment.dart';
import 'package:sweetpet/model/follower.dart';
import 'package:sweetpet/model/mall.dart';
import 'package:sweetpet/model/post.dart';
import 'package:sweetpet/model/post_detail.dart';
import 'package:sweetpet/model/thumb.dart';
import 'package:sweetpet/model/userModel.dart';
import 'package:sweetpet/page/chat_page/chat_message.dart';
import 'package:sweetpet/page/chat_page/message_bubble.dart';
import 'package:sweetpet/page/chat_page/new_message.dart';
import 'package:sweetpet/page/chat_page/user_image_picker.dart';
import 'package:sweetpet/page/comment_page/comment_page.dart';
import 'package:sweetpet/page/follow_page/follow_page.dart';
import 'package:sweetpet/page/health_page/active_energy.dart';
import 'package:sweetpet/page/health_page/add_data.dart';
import 'package:sweetpet/page/health_page/health_page.dart';
import 'package:sweetpet/page/home_page/home_page.dart';
import 'package:sweetpet/page/index_page/index_page.dart';
import 'package:sweetpet/page/like_page/like_page.dart';
import 'package:sweetpet/page/mall_page/mall_page.dart';
import 'package:sweetpet/page/mall_page/pet_shop_page.dart';
import 'package:sweetpet/page/mall_page/pet_shop_page.dart';
import 'package:sweetpet/page/mall_page/shopping_detail_page.dart';
import 'package:sweetpet/page/mall_page/shopping_list_page.dart';
import 'package:sweetpet/page/message_page/message_page.dart';
import 'package:sweetpet/page/post_page/post_page.dart';
import 'package:sweetpet/page/publish_page/publish_page.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:sweetpet/page/post_page/post_page.dart';
import 'package:sweetpet/page/mall_page/pet_shop_page.dart'
    show PetProductWidget;
import 'package:sweetpet/page/mall_page/shopping_detail_page.dart';
import 'package:sweetpet/page/vc_router.dart';
import 'package:sweetpet/util/date_util.dart';

import 'MockApiCilent.dart';

@GenerateMocks([http.Client])
void main() {
  Get.testMode = true;
  TestWidgetsFlutterBinding.ensureInitialized();

  // late MockFirebaseAuth mockFirebaseAuth; // 使用模拟Firebase身份验证

  setUpAll(() async {
    // 初始化Firebase
    await Firebase.initializeApp();

    // 初始化模拟Firebase身份验证
    // mockFirebaseAuth = MockFirebaseAuth();
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

    expect(Routes.getPages[0].name, Pages.login);
    expect(Routes.getPages[0].page(), isA<LoginController>());

    expect(Routes.getPages[1].name, Pages.home);
    expect(Routes.getPages[1].page(), isA<HomePage>());

    expect(Routes.getPages[2].name, Pages.indexDetail);
    expect(Routes.getPages[2].page(), isA<PostPage>());

    expect(Routes.getPages[3].name, Pages.mall);
    expect(Routes.getPages[3].page(), isA<MallPage>());

    final String formattedDate = SDateUtils.formatDate('2023-12-31');
    expect(formattedDate, '2023-12-31');

    final String formattedDate3 = SDateUtils.formatDate(null);
    final String currentDate = SDateUtils.formatDate(DateTime.now().toString());
    expect(formattedDate3, currentDate);

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

    await tester.pumpWidget(GetMaterialApp(
      home: ActiveEnergyPage(),
    ));

    // Verify that the title text is displayed.
    expect(find.text('Active Energy'), findsOneWidget);

    // // Verify that the toggle buttons are displayed.
    expect(find.byType(ToggleButtons), findsOneWidget);

    // // Verify that the bar chart is displayed.
    expect(find.byType(BarChart), findsOneWidget);

    // Build our widget and trigger a frame.
    await tester.pumpWidget(MaterialApp(home: AddDataPage()));

    // Verify that the title text is displayed.
    expect(find.text('Add Active Energy Data'), findsOneWidget);

    // Verify that the Date and Time fields are displayed.
    expect(find.text('Date'), findsOneWidget);
    expect(find.text('Time'), findsOneWidget);

    // Tap the Date field and verify that the date picker dialog appears.
    // await tester.tap(find.byWidgetPredicate(
    //   (widget) => widget is TextField && widget.decoration?.labelText == 'Date',
    // ));
    // await tester.pumpAndSettle(); // Wait for the dialog to appear.
    // // expect(find.byType(DatePicker), findsOneWidget);

    // // Tap the Time field and verify that the time picker dialog appears.
    // await tester.tap(find.byWidgetPredicate(
    //   (widget) => widget is TextField && widget.decoration?.labelText == 'Time',
    // ));
    // await tester.pumpAndSettle(); // Wait for the dialog to appear.
    // expect(find.byType(TimePicker()), findsOneWidget);

    // Verify that the Calories field is displayed.
    expect(find.text('Calories (cal)'), findsOneWidget);

    // Verify that the "Add" button is displayed and disabled initially.
    expect(find.text('Add'), findsOneWidget);

    await tester.pumpWidget(MaterialApp(home: SummaryPage()));

    // Verify that the title text is displayed.
    expect(find.text('Health'), findsOneWidget);

    // Verify that the "Pick Image" button is displayed.
    expect(find.byIcon(Icons.account_circle), findsOneWidget);

    // Verify that the list items are displayed with their icons and data.
    expect(find.byIcon(Icons.flash_on), findsOneWidget);
    expect(find.text('Active Energy'), findsOneWidget);
    expect(find.text('122 cal'), findsOneWidget);

    expect(find.byIcon(Icons.favorite), findsOneWidget);
    expect(find.text('Heart Rate'), findsOneWidget);

    expect(find.byIcon(Icons.hotel), findsOneWidget);
    expect(find.text('Sleep'), findsOneWidget);
    expect(find.text('6 hr 4 min'), findsOneWidget);

    expect(find.byIcon(Icons.accessibility_new), findsOneWidget);
    expect(find.text('Stand Hours'), findsOneWidget);

    expect(find.byIcon(Icons.directions_walk), findsOneWidget);
    expect(find.text('Steps'), findsOneWidget);
    expect(find.text('4,254 steps'), findsOneWidget);

    expect(find.byIcon(Icons.transfer_within_a_station), findsOneWidget);
    expect(find.text('Walking Asymmetry'), findsOneWidget);
    expect(find.text('3.6%'), findsOneWidget);

    // Verify that there is no image initially.
    // expect(find.byType(Image), findsNothing);

    // Tap the "Pick Image" button and verify that an image can be picked.
    // await tester.tap(find.byIcon(Icons.account_circle));
    // await tester.pumpAndSettle(); // Wait for the image picker to appear.
    // expect(find.byType(Image), findsOneWidget);

    // // Verify that the "Add" button is now enabled.
    // expect(tester.widget<TextButton>(addButton).enabled, isTrue);

    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MaterialApp(
        home: IndexPage(),
      ),
    );

    final Map<String, dynamic> jsonData = {
      'id': '123',
      'uid': 'user123',
      'title': 'Test Post',
      'content': 'This is a test post content.',
      'avatar': 'avatar_url.jpg',
      'nickname': 'TestUser',
      'fav': 10,
      'comment': 5,
      'date': '2023-12-08',
      'images': ['image1.jpg', 'image2.jpg'],
    };

    // 调用 PostDetail.fromJson 方法
    final postDetail = PostDetail.fromJson(jsonData);

    // 验证 PostDetail 对象是否正确地从 JSON 数据中解析出来
    expect(postDetail.id, '123');
    expect(postDetail.uid, 'user123');
    expect(postDetail.title, 'Test Post');
    expect(postDetail.content, 'This is a test post content.');
    expect(postDetail.avatar, 'avatar_url.jpg');
    expect(postDetail.nickname, 'TestUser');
    expect(postDetail.fav, 10);
    expect(postDetail.comment, 5);
    expect(postDetail.date, '2023-12-08');
    expect(postDetail.images, ['image1.jpg', 'image2.jpg']);

    final postDetail1 = PostDetail(
      '123',
      'user123',
      'Test Post',
      'This is a test post content.',
      'avatar_url.jpg',
      'TestUser',
      10,
      5,
      '2023-12-08',
      ['image1.jpg', 'image2.jpg'],
    );

    // 调用 PostDetail.toJson 方法
    final jsonData1 = postDetail.toJson();

    // 验证生成的 JSON 数据是否与预期的匹配
    expect(jsonData1['id'], '123');
    expect(jsonData1['uid'], 'user123');
    expect(jsonData1['title'], 'Test Post');
    expect(jsonData1['content'], 'This is a test post content.');
    expect(jsonData1['avatar'], 'avatar_url.jpg');
    expect(jsonData1['nickname'], 'TestUser');
    expect(jsonData1['fav'], 10);
    expect(jsonData1['comment'], 5);
    expect(jsonData1['date'], '2023-12-08');
    expect(jsonData1['images'], ['image1.jpg', 'image2.jpg']);

    final Map<String, dynamic> jsonData2 = {
      'username': 'testuser',
      'email': 'testuser@example.com',
      'avatarUrl': 'avatar_url.jpg',
    };

    // 调用 UserModel.fromJson 方法
    final userModel = UserModel.fromJson(jsonData2);

    // 验证 UserModel 对象是否正确地从 JSON 数据中解析出来
    expect(userModel.username, 'testuser');
    expect(userModel.email, 'testuser@example.com');
    expect(userModel.avatarUrl, 'avatar_url.jpg');

    final userModel1 = UserModel(
      username: 'testuser',
      email: 'testuser@example.com',
      avatarUrl: 'avatar_url.jpg',
    );

    // 调用 UserModel.toJson 方法
    final jsonData3 = userModel1.toJson();

    // 验证生成的 JSON 数据是否与预期的匹配
    expect(jsonData3['username'], 'testuser');
    expect(jsonData3['email'], 'testuser@example.com');
    expect(jsonData3['avatarUrl'], 'avatar_url.jpg');

    final Map<String, dynamic> json = {
      'id': '1',
      'followerId': 'follower123',
      'toUserId': 'user456',
      'username': 'JohnDoe',
      'avatar': 'avatar_url',
      'tag': true,
    };

    final Follower follower = Follower.fromJson(json);

    expect(follower.id, '1');
    expect(follower.followerId, 'follower123');
    expect(follower.toUserId, 'user456');
    expect(follower.username, 'JohnDoe');
    expect(follower.avatar, 'avatar_url');
    expect(follower.tag, true);

    final Follower follower1 = Follower(
      '1',
      'follower123',
      'user456',
      'JohnDoe',
      'avatar_url',
      true,
    );

    final Map<String, dynamic> json1 = follower1.toJson();

    expect(json1['id'], '1');
    expect(json1['followerId'], 'follower123');
    expect(json1['toUserId'], 'user456');
    expect(json1['username'], 'JohnDoe');
    expect(json1['avatar'], 'avatar_url');
    expect(json1['tag'], true);

    final Map<String, dynamic> jsonData4 = {
      'id': '1',
      'toPostId': '123',
      'userId': 'user123',
      'nickname': 'Test User',
      'avatar': 'avatar_url.jpg',
      'title': 'Comment Title',
      'content': 'This is a test comment.',
      'createDate': '2023-12-08T12:00:00',
    };

    final Map<String, dynamic> json2 = {
      'title': 'Product Title',
      'dealLink': 'https://example.com/deal',
      'realBuyLink': 'https://example.com/buy',
      'store': 'Store Name',
      'price': '100.00',
      'redPrice': '80.00',
      'thumbs': 42,
      'views': '1234',
      'pic': 'product_image.jpg',
    };

    final Map<String, dynamic> jsonData5 = {
      'id': '1',
      'uid': 'user1',
      'cover': 'cover_url.jpg',
      'content': 'Sample content',
      'avatar': 'avatar_url.jpg',
      'nickname': 'John Doe',
      'fav': 42,
      'like': 100,
    };

    final Post post = Post.fromJson(jsonData5);

    expect(post.id, '1');
    expect(post.uid, 'user1');
    expect(post.cover, 'cover_url.jpg');
    expect(post.content, 'Sample content');
    expect(post.avatar, 'avatar_url.jpg');
    expect(post.nickname, 'John Doe');
    expect(post.fav, 42);
    expect(post.like, 100);

    final Post post1 = Post(
      '1',
      'user1',
      'cover_url.jpg',
      'Sample content',
      'avatar_url.jpg',
      'John Doe',
      42,
      100,
    );

    final Map<String, dynamic> jsonData6 = post1.toJson();

    expect(jsonData6['id'], '1');
    expect(jsonData6['uid'], 'user1');
    expect(jsonData6['cover'], 'cover_url.jpg');
    expect(jsonData6['content'], 'Sample content');
    expect(jsonData6['avatar'], 'avatar_url.jpg');
    expect(jsonData6['nickname'], 'John Doe');
    expect(jsonData6['fav'], 42);
    expect(jsonData6['like'], 100);

    final Mall mall = Mall.fromJson(json2);

    expect(mall.title, 'Product Title');
    expect(mall.dealLink, 'https://example.com/deal');
    expect(mall.realBuyLink, 'https://example.com/buy');
    expect(mall.store, 'Store Name');
    expect(mall.price, '100.00');
    expect(mall.redPrice, '80.00');
    expect(mall.thumbs, 42);
    expect(mall.views, '1234');
    expect(mall.pic, 'product_image.jpg');

    final Mall mall1 = Mall(
      'Product Title',
      'https://example.com/deal',
      'https://example.com/buy',
      'Store Name',
      '100.00',
      '80.00',
      42,
      '1234',
      'product_image.jpg',
    );

    final Map<String, dynamic> json3 = mall1.toJson();

    expect(json3['title'], 'Product Title');
    expect(json3['dealLink'], 'https://example.com/deal');
    expect(json3['realBuyLink'], 'https://example.com/buy');
    expect(json3['store'], 'Store Name');
    expect(json3['price'], '100.00');
    expect(json3['redPrice'], '80.00');
    expect(json3['thumbs'], 42);
    expect(json3['views'], '1234');
    expect(json3['pic'], 'product_image.jpg');

    // 调用 Comment.fromJson 方法
    final comment = Comment.fromJson(jsonData4);

    // 验证 Comment 对象是否正确地从 JSON 数据中解析出来
    expect(comment.id, '1');
    expect(comment.toPostId, '123');
    expect(comment.userId, 'user123');
    expect(comment.nickname, 'Test User');
    expect(comment.avatar, 'avatar_url.jpg');
    expect(comment.title, 'Comment Title');
    expect(comment.content, 'This is a test comment.');
    expect(comment.createDate, '2023-12-08T12:00:00');

    final comment2 = Comment(
      '1',
      '123',
      'user123',
      'Test User',
      'avatar_url.jpg',
      'Comment Title',
      'This is a test comment.',
      '2023-12-08T12:00:00',
    );

    // 调用 Comment.toJson 方法
    final jsonData7 = comment2.toJson();

    // 验证生成的 JSON 数据是否与预期的匹配
    expect(jsonData7['id'], '1');
    expect(jsonData7['toPostId'], '123');
    expect(jsonData7['userId'], 'user123');
    expect(jsonData7['nickname'], 'Test User');
    expect(jsonData7['avatar'], 'avatar_url.jpg');
    expect(jsonData7['title'], 'Comment Title');
    expect(jsonData7['content'], 'This is a test comment.');
    expect(jsonData7['createDate'], '2023-12-08T12:00:00');

    final thumb = THUMB(
      '1',
      'author123',
      'user123',
      'post123',
      1,
    );

    // 调用 THUMB.toJson 方法
    final jsonData8 = thumb.toJson();

    // 验证生成的 JSON 数据是否与预期的匹配
    expect(jsonData8['id'], '1');
    expect(jsonData8['authorId'], 'author123');
    expect(jsonData8['userId'], 'user123');
    expect(jsonData8['postId'], 'post123');
    expect(jsonData8['tag'], 1);

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: PostPage(),
      ),
    ));

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

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ChatMessages(),
        ),
      ),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: MessageBubble.first(
          userImage: 'user_image_url',
          username: 'username',
          message: 'Hello!',
          isMe: true,
          time: Timestamp.fromDate(DateTime.now()),
        ),
      ),
    );

    // 使用 expect 来测试 MessageBubble.first 是否显示了正确的内容
    expect(find.text('Hello!'), findsOneWidget);
    expect(find.text('username'), findsOneWidget);

    // 构建一个 MessageBubble.next 实例
    await tester.pumpWidget(
      MaterialApp(
        home: MessageBubble.next(
          message: 'Hi there!',
          isMe: false,
          time: Timestamp.fromDate(DateTime.now()),
        ),
      ),
    );

    // 使用 expect 来测试 MessageBubble.next 是否显示了正确的内容
    expect(find.text('Hi there!'), findsOneWidget);
    expect(
        find.text('username'), findsNothing); // 因为这是一个 MessageBubble.next，没有用户名
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: NewMessage(),
        ),
      ),
    );

    // 在文本框中输入一条消息
    await tester.enterText(find.byType(TextField), 'Hello, world!');

    // 点击发送按钮
    await tester.tap(find.byIcon(Icons.send));
    await tester.pump();

    // 检查文本框是否已清除
    expect(find.text('Hello, world!'), findsNothing);

    File? pickedImage;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: UserImagePicker(
            onPickImage: (image) {
              pickedImage = image;
            },
          ),
        ),
      ),
    );

    // 初始状态下应该没有图像
    expect(find.byType(CircleAvatar), findsOneWidget);
    expect(find.byIcon(Icons.camera), findsOneWidget);
    expect(find.byIcon(Icons.image), findsOneWidget);
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

    expect(find.byType(LikePage), findsOneWidget);
    expect(find.text('Like Page'), findsOneWidget);

    final mockApiClient = MockApiClient();
    final commentcontroller = CommentController();

    await tester.pumpWidget(
      MaterialApp(
        home: CommentsPage(),
      ),
    );

    expect(find.byType(CommentsPage), findsOneWidget);
    expect(find.text('Comments'), findsOneWidget);

    await tester.pumpWidget(MaterialApp(
      home: MallPage(),
    ));

    // 查找AppBar标题
    expect(find.text('Mall'), findsOneWidget);

    // 查找文本输入框
    expect(find.byType(TextFormField), findsOneWidget);

    // 查找PetCategoryWidget组件数量
    expect(find.byType(PetCategoryWidget),
        findsNWidgets(2)); // 假设有两个PetCategoryWidget

    // 检查PetCategoryWidget的文本内容
    expect(find.text('Dog'), findsOneWidget);
    expect(find.text('Cat'), findsOneWidget);

    await tester.pumpWidget(MaterialApp(
      home: PetShopPage(name: 'Dog'),
    ));

    // 查找AppBar标题
    expect(find.text('Mall'), findsOneWidget);

    // 查找文本输入框
    expect(find.byType(TextField), findsOneWidget);

    // 查找PetProductWidget组件数量，假设有4个
    expect(find.byType(PetShopPage), findsNWidgets(1));

    // 查找Card Widget，假设有4个
    expect(find.byType(Card), findsNWidgets(4));

    // 检查PetProductWidget中的文本内容
    expect(find.text('Food'), findsOneWidget);
    expect(find.text('Treats'), findsOneWidget);
    expect(find.text('Toys'), findsOneWidget);
    expect(find.text('Treatment'), findsOneWidget);

    // 模拟按钮点击
    // await tester.tap(find.text('Link to Sample Store'));
    // await tester.pumpAndSettle(); // 等待动画完成

    await Future.delayed(const Duration(seconds: 5));

    await tester.pumpWidget(MaterialApp(
      home: ShopList('Dog', 'Category'), // 请提供适当的参数
    ));

    // 确保 ShopList 页面已经加载
    expect(find.text('Mall'), findsOneWidget);

    // 触发返回按钮的点击事件
    // await tester.tap(find.byType(IconButton));
    // await tester.pump();

    await tester.pumpWidget(MaterialApp(
      home: ShopDetailPage(
        mall: Mall(
          'Sample Mall',
          'https://example.com/deal-link',
          'https://example.com/real-buy-link',
          'Sample Store',
          '100',
          '80',
          50,
          '1000',
          'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1',
        ),
      ),
    ));

    // 在测试中，你可以使用 find 方法查找小部件并进行断言
    expect(find.text('Sample Mall'), findsOneWidget); // 查找标题文本
    expect(find.byType(Image), findsOneWidget); // 查找图片小部件
    expect(find.text('Link to Sample Store'), findsOneWidget); // 查找按钮文本

    await tester.pumpWidget(MaterialApp(
      home: ForgotPassword(),
    ));

    // Verify if the title is displayed.
    expect(find.text('Reset password'), findsOneWidget);

    // Verify if the "Enter your email and press continue" text is displayed.
    expect(
      find.text('Enter your email and press continue'),
      findsOneWidget,
    );

    // Verify if the email TextFormField is displayed.
    expect(find.byType(TextFormField), findsOneWidget);

    // Enter a valid email and tap the "Continue" button.
    await tester.enterText(find.byType(TextFormField), 'test@example.com');
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Verify if the dialog appears.
    expect(find.text('Password reset link sent'), findsOneWidget);
    expect(
      find.text(
          'Please follow the instructions in the email to reset your password.'),
      findsOneWidget,
    );

    // Verify if the "OK" button in the dialog works.
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();

    // Verify if the dialog is dismissed.
    expect(find.text('Password reset link sent'), findsNothing);

    await tester.pumpWidget(
      const MaterialApp(
        home: NewMessage(),
      ),
    );

    // 输入一条消息并提交
    await tester.enterText(find.byType(TextField), 'Hello, World!');
    await tester.tap(find.byIcon(Icons.send));
    await tester.pumpAndSettle();

    // 验证消息文本框是否被清空
    expect(find.text('Hello, World!'), findsNothing);

    await Future.delayed(const Duration(seconds: 5));

    // await tester.pumpWidget(
    //   MaterialApp(
    //     home: MessageBubble.first(
    //       userImage:
    //           'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1',
    //       username: 'John',
    //       message: 'Hello, World!',
    //       isMe: true,
    //       time: Timestamp.now(), // 请替换成适当的时间戳
    //     ),
    //   ),
    // );

    // // 等待组件渲染完成
    // await tester.pumpAndSettle();

    // // 验证用户名和消息文本是否正确显示
    // expect(find.text('John'), findsOneWidget);
    // expect(find.text('Hello, World!'), findsOneWidget);

    final apiClient = MockApiClient();

    // // 验证是否已导航到 LikePage 页面

    // Get.testMode = true;
    // Get.toNamed("/indexDetail", arguments: {'id': "1"});
    // final controller = PostController();
    // when(apiClient.getIndexDetailDataById("1")).thenAnswer((_) async {
    //   // 返回模拟数据
    //   return PostDetail(
    //     '1', // 替换为实际的帖子ID
    //     '2222', // 替换为实际的头像URL
    //     'Post Title', // 替换为实际的帖子标题
    //     'Post Content', // 替换为实际的帖子内容
    //     'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1',
    //     'John Doe', // 替换为实际的昵称
    //     10,
    //     20,
    //     "2023.10.23",
    //     [
    //       'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1'
    //     ], // 替换为实际的图片URL列表
    //   );
    // });

    // PostDetail postDetail = PostDetail(
    //   '1', // 替换为实际的帖子ID
    //   '2222', // 替换为实际的头像URL
    //   'Post Title', // 替换为实际的帖子标题
    //   'Post Content', // 替换为实际的帖子内容
    //   'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1',
    //   'John Doe', // 替换为实际的昵称
    //   10,
    //   20,
    //   "2023.10.23",
    //   [
    //     'https://profile-avatar.csdnimg.cn/42128bd6c1f1431180b621b98ed187db_u011068702.jpg!1'
    //   ], // 替换为实际的图片URL列表
    // );
    // controller.postDetail = postDetail;

    // // 等待PostController的onInit完成
    // await Future.delayed(const Duration(seconds: 3));

    // await tester.pumpWidget(
    //   MaterialApp(
    //     home: GetBuilder<PostController>(
    //       init: controller, // 使用实际的 PostController
    //       builder: (_) => PostPage(),
    //     ),
    //   ),
    // );

    // // 等待异步操作完成
    // await tester.pump();

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

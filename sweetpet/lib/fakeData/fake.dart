import 'package:sweetpet/model/comment.dart';
import 'package:sweetpet/model/post_detail.dart';

class FakeData {
  static List<Comment> commentList = [
    Comment(
      "1",
      "2d31d58c-e243-4ab0-976b-69f96d64e9ea",
      "Alice",
      "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202003%2F10%2F20200310204111_sfgix.thumb.1000_0.jpg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1694143887&t=56d596ea77bb95611580c4307e2236b1",
      "Test Comment Function",
      "2023-06-15 16:54:27",
      1,
      false,
    ),
    Comment(
      "2",
      "2d31d58c-e243-4ab0-976b-69f96d64e9ea",
      "momo",
      "https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fc-ssl.duitang.com%2Fuploads%2Fitem%2F202003%2F10%2F20200310204111_sfgix.thumb.1000_0.jpg&refer=http%3A%2F%2Fc-ssl.duitang.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=auto?sec=1694143887&t=56d596ea77bb95611580c4307e2236b1",
      "Test Comment Function Version 2",
      "2023-06-17 16:54:27",
      6,
      false,
    ),
  ];
}

import 'package:flutter/material.dart';
import 'package:flutter_wordpress/models/postlisttype.dart';
import 'package:flutter_wordpress/widgets/PaginatePosts.dart';

class ResultScreen extends StatelessWidget {
  final String search;

  const ResultScreen({Key key, this.search}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Result: ${this.search}"),
      ),
      body: PaginatePosts(
        postListType: PostListType.asListRandom,
        search: this.search,
      ),
    );
  }
}

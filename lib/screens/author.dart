import 'package:flutter/material.dart';
import 'package:flutter_wordpress/models/Author.dart';
import 'package:flutter_wordpress/models/postlisttype.dart';
import 'package:flutter_wordpress/widgets/PaginatePosts.dart';

class AuthorScreen extends StatelessWidget {
  final Author author;

  const AuthorScreen({Key key, this.author}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Author: ${author.name}"),
      ),
      body: PaginatePosts(
        postListType: PostListType.asListRandom,
        author: author,
      ),
    );
  }
}

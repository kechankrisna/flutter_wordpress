import 'package:flutter/material.dart';
import 'package:flutter_wordpress/models/models.dart';
import 'package:flutter_wordpress/models/postlisttype.dart';
import 'package:flutter_wordpress/widgets/PaginatePosts.dart';

class ArchiveScreen extends StatelessWidget {
  final Term category;

  const ArchiveScreen({Key key, this.category}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Archive: ${category.name}"),
      ),
      body: PaginatePosts(
        postListType: PostListType.asListRandom,
        category: category,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_wordpress/bloc/bloc.dart';
import 'package:flutter_wordpress/models/Author.dart';
import 'package:flutter_wordpress/models/models.dart';
import 'package:flutter_wordpress/models/postlisttype.dart';
import 'package:flutter_wordpress/widgets/PostCard.dart';
import 'package:flutter_wordpress/widgets/PostList.dart';

class LazyLoadPosts extends StatefulWidget {
  final PostListType postListType;
  final Term category;
  final int randomBy;
  final String search;
  final Author author;

  const LazyLoadPosts({
    Key key,
    this.postListType: PostListType.asListile,
    this.randomBy: 5,
    this.category,
    this.search,
    this.author,
  }) : super(key: key);
  @override
  _LazyLoadPostsState createState() => _LazyLoadPostsState();
}

class _LazyLoadPostsState extends State<LazyLoadPosts> {
  PostBloc _postBloc;
  ScrollController _controller = ScrollController();
  bool _refresh = false;

  @override
  void initState() {
    _postBloc = PostBloc(perPage: 15);
    if (this.widget.category != null) {
      _postBloc.category = this.widget.category;
    } else if (this.widget.search != null) {
      _postBloc.search = this.widget.search;
    } else if (this.widget.author != null) {
      _postBloc.author = this.widget.author;
    }
    _postBloc?.init();

    super.initState();
    _controller.addListener(_scrollListener);
  }

  //scroll controller
  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent - 20 &&
        !_controller.position.outOfRange) {
      // print('message = "reach the bottom"');
      _postBloc.loadMore();
    }
    if (_controller.offset <= _controller.position.minScrollExtent &&
        !_controller.position.outOfRange) {
      print('message = "reach the top"');
      setState(() => _refresh = true);
      _postBloc.refresh().then((value) {
        setState(() => _refresh = false);
      });
    }
  }

  Widget _contentWidget({@required Post post}) {
    switch (this.widget.postListType) {
      case PostListType.asListile:
        return PostList(
          post: post,
        );
        break;
      case PostListType.asListCard:
        return PostCard(
          post: post,
        );
        break;
      case PostListType.asListRandom:
        return post.id % this.widget.randomBy == 0
            ? PostCard(
                post: post,
              )
            : PostList(
                post: post,
              );
        break;
      default:
        return Container();
    }
  }

  @override
  void dispose() {
    _postBloc?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _postBloc.stream,
      builder: (_, AsyncSnapshot<List<Post>> snapshots) {
        if (snapshots.hasError) {
          return Container(
            alignment: Alignment.center,
            child: Text("Error: ${snapshots.error}"),
          );
        }
        if (_refresh)
          return Container(
            alignment: Alignment.center,
            child: CircularProgressIndicator(),
          );

        if (snapshots.hasData) {
          if (snapshots.data.length <= 0) {
            return Container(
              alignment: Alignment.center,
              child: Text("No Data"),
            );
          }

          final List<Post> datas = snapshots.data;
          return Container(
            child: ListView.builder(
              controller: _controller,
              itemCount: datas.length + 1,
              shrinkWrap: true,
              itemBuilder: (_, i) => i == datas.length
                  ? Container(
                      alignment: Alignment.bottomCenter,
                      child: CircularProgressIndicator(),
                    )
                  : _contentWidget(post: datas[i]),
            ),
          );
        }

        return Container(
          alignment: Alignment.topCenter,
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

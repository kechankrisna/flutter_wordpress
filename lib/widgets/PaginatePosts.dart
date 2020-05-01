import 'package:flutter/material.dart';
import 'package:flutter_wordpress/bloc/bloc.dart';
import 'package:flutter_wordpress/models/Author.dart';
import 'package:flutter_wordpress/models/models.dart';
import 'package:flutter_wordpress/models/postlisttype.dart';

import 'PostCard.dart';
import 'PostList.dart';

class PaginatePosts extends StatefulWidget {
  final PostListType postListType;
  final Term category;
  final int randomBy;
  final String search;
  final Author author;

  const PaginatePosts({
    Key key,
    this.postListType: PostListType.asListile,
    this.randomBy: 5,
    this.category,
    this.search,
    this.author,
  }) : super(key: key);
  @override
  _PaginatePostsState createState() => _PaginatePostsState();
}

class _PaginatePostsState extends State<PaginatePosts> {
  int _currentPage = 1;
  int _perPage = 15;
  PostBloc _postBloc;
  bool _refresh = false;

  @override
  void initState() {
    _postBloc = PostBloc(perPage: _perPage, currentPage: this._currentPage);
    if (this.widget.category != null) {
      _postBloc.category = this.widget.category;
    } else if (this.widget.search != null) {
      _postBloc.search = this.widget.search;
    } else if (this.widget.author != null) {
      _postBloc.author = this.widget.author;
    }

    _postBloc?.init();

    super.initState();
  }

  List<Widget> _paginationBars({@required int totalPages}) {
    List<int> pages = [_currentPage - 1, _currentPage, _currentPage + 1];
    if (_currentPage == 1) {
      pages = [_currentPage, _currentPage + 1, _currentPage + 2];
    } else if (_currentPage == totalPages) {
      pages = [_currentPage - 2, _currentPage - 1, _currentPage];
    }
    if (_postBloc.totalPages < 3) {
      pages =
          List.generate(_postBloc.totalPages, (index) => index += 1).toList();
    }

    return pages
        .map(
          (page) => SizedBox(
              width: 60,
              child: MaterialButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0),
                  side: BorderSide(color: Theme.of(context).primaryColor),
                ),
                color: _currentPage == page
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                onPressed: () {
                  setState(() => _currentPage = page);
                  setState(() => _refresh = true);
                  _postBloc.moveToPage(page: _currentPage).then((value) {
                    setState(() => _refresh = false);
                  });
                },
                child: Text(
                  "$page",
                  style: TextStyle(
                    color: _currentPage != page
                        ? Theme.of(context).primaryColor
                        : Colors.white,
                  ),
                ),
              )),
        )
        .toList();
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

        if (snapshots.hasData) {
          if (_refresh)
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          if (snapshots.data.length <= 0) {
            return Container(
              alignment: Alignment.center,
              child: Text("No Data"),
            );
          }

          final List<Post> datas = snapshots.data;
          return Container(
            child: ListView(
              children: [
                ...datas
                    .map((post) => _contentWidget(
                          post: post,
                        ))
                    .toList(),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: _currentPage == 1
                              ? null
                              : () {
                                  setState(() => _currentPage =
                                      _currentPage > 1 ? _currentPage -= 1 : 1);

                                  setState(() => _refresh = true);
                                  _postBloc
                                      .moveToPage(page: _currentPage)
                                      .then((value) {
                                    setState(() => _refresh = false);
                                  });
                                }),
                      ..._paginationBars(totalPages: _postBloc.totalPages),
                      IconButton(
                          icon: Icon(Icons.arrow_forward_ios),
                          onPressed: _currentPage == _postBloc.totalPages
                              ? null
                              : () {
                                  setState(() => _currentPage =
                                      _currentPage < _postBloc.totalPages
                                          ? _currentPage += 1
                                          : _postBloc.totalPages);
                                  setState(() => _refresh = true);
                                  _postBloc
                                      .moveToPage(page: _currentPage)
                                      .then((value) {
                                    setState(() => _refresh = false);
                                  });
                                }),
                    ],
                  ),
                )
              ],
            ),
          );
        }

        return Container(
          alignment: Alignment.center,
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

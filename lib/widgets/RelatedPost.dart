import 'package:flutter/material.dart';
import 'package:flutter_wordpress/bloc/bloc.dart';
import 'package:flutter_wordpress/models/models.dart';
import 'package:flutter_wordpress/widgets/PostGrid.dart';

class RelatedPosts extends StatefulWidget {
  final Term category;
  final List<int> excludes;

  const RelatedPosts({Key key, this.category, this.excludes : const []}) : super(key: key);
  @override
  _RelatedPostsState createState() => _RelatedPostsState();
}

class _RelatedPostsState extends State<RelatedPosts> {
  PostBloc _postBloc;
  ScrollController _controller = ScrollController();
  bool _refresh = false;

  @override
  void initState() {
    _postBloc = PostBloc(perPage: 3);
    if (this.widget.category != null) {
      _postBloc.category = this.widget.category;
    }
    if(this.widget.excludes.length>0){
      _postBloc.excludes = this.widget.excludes;
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
            width: MediaQuery.of(context).size.width,
            
            child: SingleChildScrollView(
              controller: _controller,
              scrollDirection: Axis.horizontal,
              child: Container(
                child: Row(
                  children: datas
                      .map(
                        (post) => PostGrid(
                          perRow: 2,
                          post: post,
                        ),
                      )
                      .toList(),
                ),
              ),
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

import 'package:flutter/material.dart';
import 'package:flutter_wordpress/models/postlisttype.dart';
import 'package:flutter_wordpress/widgets/CategoryDrawer.dart';
import 'package:flutter_wordpress/widgets/LazyLoadPosts.dart';
import 'package:flutter_wordpress/widgets/PaginatePosts.dart';
import './../config.dart';


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> options = [
    {
      "name": "LIST",
      "type": PostListType.asListile,
    },
    {
      "name": "CARD",
      "type": PostListType.asListCard,
    },
    {
      "name": "RANDOM",
      "type": PostListType.asListRandom,
    }
  ];
  PostListType _type = PostListType.asListile;

  String _view = "lazy";
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("$app_name"),
        actions: [
          DropdownButton(
            value: _type,
            items: options
                .map(
                  (option) => DropdownMenuItem(
                    child: Text(option["name"]),
                    value: option["type"],
                  ),
                )
                .toList(),
            onChanged: (type) => setState(() => _type = type),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.of(context).pushNamed("/search");
            },
          ),
        ],
      ),
      drawer: CategoryDrawer(),
      body: _view == "lazy"
          ? LazyLoadPosts(
              postListType: _type,
            )
          : PaginatePosts(
              postListType: _type,
            ),
      floatingActionButton: FlatButton.icon(
          onPressed: () =>
              setState(() => _view = _view == "lazy" ? "page" : "lazy"),
          icon: Icon(Icons.compare_arrows),
          label: Text("SWITCH")),
    );
  }
}

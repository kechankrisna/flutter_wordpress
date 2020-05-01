import 'package:flutter/material.dart';
import 'package:flutter_wordpress/bloc/CategoryBloc.dart';
import 'package:flutter_wordpress/models/models.dart';

import '../config.dart';

class CategoryDrawer extends StatefulWidget {
  @override
  _CategoryDrawerState createState() => _CategoryDrawerState();
}

class _CategoryDrawerState extends State<CategoryDrawer> {
  CategoryBloc _categoryBloc = CategoryBloc();
  @override
  void initState() {
    _categoryBloc.init();
    super.initState();
  }

  @override
  void dispose() {
    _categoryBloc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: StreamBuilder(
          stream: _categoryBloc.stream,
          builder: (_, AsyncSnapshot<List<Term>> snapshots) {
            if (snapshots.hasData) {
              if (snapshots.data.length <= 0) {
                return Container(
                  alignment: Alignment.center,
                  child: Text("No Data"),
                );
              }
              final List<Term> datas = snapshots.data;
              return ListView(
                children: [
                  DrawerHeader(
                    padding: EdgeInsets.all(0),
                    child: UserAccountsDrawerHeader(
                      onDetailsPressed: () {
                        Navigator.of(context).pushNamed("/");
                      },
                      accountName: Text(
                        "$app_name",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      accountEmail: Text("$app_description"),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        image: DecorationImage(
                          image: NetworkImage(app_icon),
                        ),
                      ),
                    ),
                  ),
                  ...datas
                      .map(
                        (category) => ListTile(
                          title: Text("${category.name}"),
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed("/archive", arguments: category);
                          },
                        ),
                      )
                      .toList(),
                  ListTile(
                    title: Text("More..."),
                  )
                ],
              );
            }
            return Container(
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}

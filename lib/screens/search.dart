import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final String search;

  const SearchScreen({Key key, this.search}) : super(key: key);
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController _controller;
  String _search;

  @override
  void initState() {
    _search = this.widget.search ?? "";
    _controller =
        TextEditingController.fromValue(TextEditingValue(text: _search));
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          color: Colors.black,
          icon: Icon(
            Icons.arrow_back,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
          child: TextField(
            keyboardType: TextInputType.text,
            controller: _controller,
            onChanged: (value) {
              setState(() {
                _search = value;
              });
            },
            autofocus: true,
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.search),
                onPressed: _search.length <= 0
                    ? null
                    : () {
                        Navigator.of(context)
                            .pushNamed("/result", arguments: _search);
                      },
              ),
            ),
          ),
        ),
      ),
      body: Container(
        color: Colors.grey,
      ),
    );
  }
}

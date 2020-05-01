import 'package:flutter/material.dart';

class ErrorScreen extends StatefulWidget {
  @override
  _ErrorScreenState createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ErrorScreen"),
      ),
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Icon(
                Icons.info,
                size: 55,
                color: Colors.grey,
              ),
              Container(
                child: Text(
                  "404 Error",
                  style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                ),
                padding: EdgeInsets.all(
                  10,
                ),
              ),
              Container(
                padding: EdgeInsets.all(
                  5,
                ),
                child: Text("Page error, not found"),
              ),
              FlatButton.icon(
                onPressed: () {
                  Navigator.of(context).pushNamed("/");
                },
                icon: Icon(Icons.arrow_back),
                label: Text("GO HOME"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

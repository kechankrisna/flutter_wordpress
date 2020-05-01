

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/image_properties.dart';
import 'package:flutter_wordpress/models/Author.dart';
import 'package:flutter_wordpress/models/models.dart';
import 'package:html/dom.dart' as dom;
import 'package:flutter_wordpress/widgets/RelatedPost.dart';
import 'package:url_launcher/url_launcher.dart';

class PostScreen extends StatelessWidget {
  final Post post;

  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  const PostScreen({Key key, this.post}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Post"),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 250,
              child: CachedNetworkImage(
                imageUrl: post.image,
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
            Container(
              padding: EdgeInsets.all(5),
              child: Text(
                "${post.title}",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
              ),
            ),
            Html(
              customTextAlign: (_) => TextAlign.left,
              defaultTextStyle: TextStyle(
                fontSize: 16,
              ),
              imageProperties: ImageProperties(
                fit: BoxFit.fitWidth,
                matchTextDirection: true,
                height: MediaQuery.of(context).size.width * 0.7,
              ),
              data: post.content,
              //Optional parameters:
              padding: EdgeInsets.all(5.0),
              linkStyle: const TextStyle(
                color: Colors.blueAccent,
                decorationColor: Colors.blueAccent,
                decoration: TextDecoration.underline,
              ),

              onLinkTap: (url) => _launchURL("$url"),
              customRender: (node, children) {
                print(node);
                if (node is dom.Element) {
                  switch (node.localName) {
                    case "custom_tag":
                      return Column(children: children);
                  }
                }
              },
            ),
            Wrap(
              alignment: WrapAlignment.start,
              runSpacing: 5,
              spacing: 5,
              children: [
                Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    "Terms :",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                ...post.terms
                    .where((term) =>
                        term.taxonomy == "category" ||
                        term.taxonomy == "post_tag")
                    .map((Term category) => GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed("/archive", arguments: category);
                          },
                          child: Chip(
                            label: Text("${category.name}"),
                          ),
                        ))
                    .toList()
              ],
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Author ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            AuthorBar(
              author: post.author,
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "RECOMMENDED FOR YOU: ",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.left,
              ),
            ),
            Container(
              child: RelatedPosts(
                category: post.terms
                    .where((term) => term.taxonomy == "category")
                    .first,
                excludes: [this.post.id],
              ),
            )
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   child: Bar,
      // ),
    );
  }
}

class AuthorBar extends StatelessWidget {
  final Author author;

  const AuthorBar({Key key, this.author}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 48,
            width: 48,
            child: CircleAvatar(
              child: CachedNetworkImage(
                imageUrl: author.avatar_urls["48"],
                imageBuilder: (context, imageProvider) => Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
            ),
          ),
          Expanded(
            child: InkWell(
              onTap: () {
                Navigator.of(context).pushNamed("/author", arguments: author);
              },
              child: Container(
                padding: EdgeInsets.only(left: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Name: ${author.name}",
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    if (author.description != null)
                      Text("${author.description}"),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

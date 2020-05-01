import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import './../models/Post.dart';

class PostGrid extends StatelessWidget {
  final Post post;
  final int perRow;

  const PostGrid({Key key, this.post, this.perRow: 3}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () =>
          Navigator.of(context).pushNamed("/post", arguments: this.post),
      child: Card(
        child: Container(
          width: MediaQuery.of(context).size.width / this.perRow,
          padding: EdgeInsets.all(5),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: post.image,
                imageBuilder: (context, imageProvider) => Container(
                  height:
                      (MediaQuery.of(context).size.width / this.perRow) - 50,
                  alignment: Alignment.bottomLeft,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(
                            Colors.black, BlendMode.colorDodge)),
                  ),
                ),
                placeholder: (context, url) => Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(),
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Text(
                "${post.title}",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.left,
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

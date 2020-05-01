import 'package:flutter_wordpress/config.dart';
import 'package:flutter_wordpress/models/Author.dart';
import 'package:flutter_wordpress/models/models.dart';

class Post {
  final int id;
  final String date;
  final String date_gmt;
  final String guid;
  final String modified;
  final String modified_gmt;
  final String slug;
  final String status;
  final String type;
  final String link;
  final String title;
  final String excerpt;
  final String content;
  final int feature_media;
  final String thumbnail;
  final String image;
  final String comment_status;
  final String ping_status;
  final bool sticky;
  final String template;
  final String format;
  final List<int> categories;
  final List<Term> terms;
  final List<int> tags;
  final Author author;

  Post({
    this.id,
    this.date,
    this.date_gmt,
    this.guid,
    this.modified,
    this.modified_gmt,
    this.slug,
    this.status,
    this.type,
    this.link,
    this.title,
    this.excerpt,
    this.content,
    this.author,
    this.feature_media,
    this.thumbnail,
    this.image,
    this.comment_status,
    this.ping_status,
    this.sticky,
    this.template,
    this.format,
    this.categories,
    this.terms,
    this.tags,
  });

  factory Post.fromJson(Map<String, dynamic> map) {
    final RegExp reg = RegExp(r"(&|#\w+;)");
    final more_details =
        map["_embedded"]["wp:featuredmedia"]?.first["media_details"];

    List<Term> t = [];
    for (var terms in map["_embedded"]["wp:term"] as List) {
      t = [...terms.cast().map((json) => Term.fromJson(json)).toList(), ...t];
    }
    return Post(
      id: map['id'],
      date: map['date'],
      date_gmt: map['date_gmt'],
      guid: map['guid']['rendered'],
      modified: map['modified'],
      modified_gmt: map['modified_gmt'],
      slug: map['slug'],
      status: map['status'],
      type: map['type'],
      link: map['link'],
      title: map['title']['rendered']
          .replaceAll(RegExp("<p>|</p>"), "")
          .replaceAll(reg, ""),
      excerpt: map['excerpt']['rendered']
          .replaceAll(RegExp("<p>|</p>"), "")
          .replaceAll(reg, ""),
      content: map['content']['rendered'],
      author: Author.fromJson((map["_embedded"]['author'] as List).first),
      feature_media: map['feature_media'],
      thumbnail: more_details != null
          ? more_details["sizes"]["medium"]["source_url"]
          : map["_embedded"]["wp:featuredmedia"]?.first['source_url'] ??
              app_thumbnail,
      image: map["_embedded"]["wp:featuredmedia"]?.first['source_url'] ??
          app_thumbnail,
      comment_status: map['comment_status'],
      ping_status: map['ping_status'],
      sticky: map['sticky'],
      template: map['template'],
      format: map['format'],
      categories: List.castFrom(map['categories']),
      terms: t,
      tags: List.castFrom(map['tags']),
    );
  }
}

import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_wordpress/models/Author.dart';
import './../config.dart';
import './../models/models.dart';

class PostBloc {
  List<Post> _lists = List<Post>();
  bool loading = false;
  List<Post> get lists => this._lists;
  StreamController<List<Post>> _controller = StreamController<List<Post>>();
  Stream<List<Post>> get stream => this._controller.stream;
  StreamSink<List<Post>> get _streamSink => this._controller.sink;

  int perPage;
  int currentPage = 1;
  int totalPages = 1;
  int totalPosts = 0;
  String order;
  String orderBy;

  Term category;
  Author author;
  String search;
  List<int> excludes;

  PostBloc({
    int perPage: 10,
    int currentPage: 1,
    String order: "desc",
    String orderBy: "date",
    Term category,
    String search,
    Author author,
    List<int> excludes: const [],
  }) {
    this.perPage = perPage;
    this.currentPage = currentPage;
    this.order = order;
    this.orderBy = orderBy;
    this.category = category;
    this.search = search;
    this.excludes = excludes;
    this.author = author;
  }

  Future<bool> refresh() async {
    _lists.clear();
    loading = true;
    currentPage = 1;
    await load(page: currentPage);
    return true;
  }

  loadMore() {
    if (!loading && totalPosts > lists.length) {
      loading = true;
      currentPage += 1;
      load(page: currentPage);
    }
    print(totalPosts > lists.length);
  }

  Future<bool> init() async {
    loading = true;
    await load(page: 1);
    return loading;
  }

  Future<bool> moveToPage({int page: 1}) async {
    _lists.clear();
    loading = true;
    currentPage = page;
    await load(page: currentPage);
    return loading;
  }

  Future<bool> load({int page: 1}) async {
    try {
      String url =
          "$api/posts?_embed&page=$page&per_page=$perPage&order=$order&orderBy=$orderBy";
      if (category != null) {
        switch (category.taxonomy) {
          case "category":
            url += "&categories=${category.id}";
            break;
          case "post_tag":
            url += "&tags=${category.id}";
            break;
          default:
        }
      } else if (search != null) {
        url += "&search=$search";
      } else if (author != null) {
        url += "&author=${author.id}";
      }
      if (excludes.length > 0) {
        url += "&exclude=${excludes.first}";
      }
      print(url);
      Response response = await Dio().get(url);

      var _totalPosts = response.headers["x-wp-total"].first;
      var _totalPages = response.headers["x-wp-totalpages"].first;
      print(
          "totalPosts $_totalPosts, totalPages $_totalPages, currentPage $currentPage");

      totalPages = int.parse(_totalPages);
      totalPosts = int.parse(_totalPosts);

      List<dynamic> datas = response.data;
      List<Post> _posts =
          datas.cast().map((json) => Post.fromJson(json)).toList();

      _lists.addAll(_posts);
      _streamSink.add(_lists);
      loading = false;
      return loading;
    } catch (e) {
      print("load() method got error $e");
      return false;
    }
  }

  List<Post> generate() {
    List<Post> _posts = [];
    final int startIndex = lists.length;
    for (var i = startIndex; i < startIndex + 30; i++) {
      final Post post = Post(
        id: i,
        title: "title $i",
        content: "Content $i",
        excerpt: "Except $i",
      );
      _posts.add(post);
    }
    return _posts;
  }

  dispose() {
    _controller.close();
    _streamSink.close();
  }
}

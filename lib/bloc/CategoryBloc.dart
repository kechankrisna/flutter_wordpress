import 'dart:async';
import 'package:dio/dio.dart';
import './../config.dart';
import './../models/models.dart';

class CategoryBloc {
  List<Term> _lists = List<Term>();
  List<Term> get lists => this._lists;
  StreamController<List<Term>> _controller =
      StreamController<List<Term>>();
  Stream<List<Term>> get stream => this._controller.stream;
  StreamSink<List<Term>> get _streamSink => this._controller.sink;

  CategoryBloc();

  Future<bool> init() async {
    return await load();
  }

  Future<bool> load({int page: 1}) async {
    try {
      Response response = await Dio().get("$api/categories?_embed");

      List<dynamic> datas = response.data;
      List<Term> _posts =
          datas.cast().map((json) => Term.fromJson(json)).toList();

      _lists.addAll(_posts);
      _streamSink.add(_lists);
      return true;
    } catch (e) {
      print("load() method got error $e");
      return false;
    }
  }

  dispose() {
    _controller.close();
    _streamSink.close();
  }
}

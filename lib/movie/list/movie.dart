import 'dart:convert';

import 'package:meta/meta.dart';

class Movie{
  final String title;
  final String average; //这里解析 double 是报错的
  final int collectCount;
  final String smallImage;
  final String director;
  final String cast;
  final String movieId;

  //构造函数
  Movie({
    @required this.title,
    @required this.average,
    @required this.collectCount,
    @required this.smallImage,
    @required this.director,
    @required this.cast,
    @required this.movieId,
  });

  static List<Movie> allFromResponse(String response) {
    print(JSON.decode(response).toString());
    return JSON.decode(response)['subjects'].map((obj) => Movie.fromMap(obj)).toList();

  }

  static fromMap(Map map) {
    List directors = map['directors'];
    List cast = map['casts'];

    var d = '';
    for(int i = 0;i < directors.length;i++){
      if(i == 0){
        d += directors[i]['name'];
      }else{
        d += '/' + directors[i]['name'];
      }
    }

    var c = '';
    for(int i = 0;i < cast.length;i++){
      if(i == 0){
        c += cast[i]['name'];
      }else{
        c += '/' + cast[i]['name'];
      }
    }

    return new Movie(title: map['title'], average: map['rating']['average'].toString(), collectCount: map['collect_count'], smallImage: map['images']['small'], director: d, cast: c, movieId: map['id']);
  }

}
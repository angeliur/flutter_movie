import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_movie/movie/detail/movie_detail_page.dart';
import 'package:flutter_movie/movie/list/movie.dart';

class MovieListPage extends StatefulWidget{
  @override
  MovieListPageState createState() => new MovieListPageState();

}

class MovieListPageState extends State<MovieListPage> {

  List<Movie> movies = [];

  var url = 'https://api.douban.com/v2/movie/in_theaters?'
      'apikey=0b2bdeda43b5688921839c8ecb20399b&city=%E5%8C%97%E4%BA%AC&'
      'start=0&count=100&client=&udid=';
  

  @override
  void initState() {
    super.initState();
    //一进页面就请求接口
    getMovieListData();
  }

  @override
  Widget build(BuildContext context) {
    var content;
    if(movies.isEmpty){
      content = new CircularProgressIndicator();
    }else{
      content = new ListView.builder(
          itemCount: movies.length,
          itemBuilder: buildMovieItem
      );
    }

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("angeliur"),
      ),
      body: content
    );
  }

  //网络请求
  getMovieListData() async {
    //createHttpClient() 来自 package:flutter/services.dart，不能自己导包
    String response = await createHttpClient().read(url);
    print(response.toString());
    // setState 相当于 runOnUiThread
    setState((){
      movies = Movie.allFromResponse(response);
    });
  }

  navigateToMovieDetailPage(Movie movie, Object imageTag) {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (BuildContext context){
        return new MovieDetailPage(movie,imageTag: imageTag);
      })
    );
  }

  buildMovieItem(BuildContext context, int index) {
    Movie movie = movies[index];
    var movieImage = new Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 10.0,
        right: 10.0,
        bottom: 10.0),
      child: new Image.network(
        movie.smallImage,
        width: 120.0,
        height: 100.0)
    );

    var movieMsg = new Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        new Text(
          movie.title,
          textAlign: TextAlign.left,
          style: new TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14.0
          ),
        ),
        new Text('导演' + movie.director),
        new Text('主演' + movie.cast),
        new Text(
          movie.collectCount.toString() + '人看过',
          style: new TextStyle(
            fontSize: 12.0,
            color: Colors.redAccent
          ),
        )
      ],
    );

    var movieItem = new GestureDetector(
      //点击事件
      onTap: () => navigateToMovieDetailPage(movie,index),
        child: new Column(
          children: <Widget>[
            new Row(
              children: <Widget>[
                movieImage,
                //Expanded 均分
                new Expanded(child: movieMsg),
                const Icon(Icons.keyboard_arrow_right)
              ],
            ),
            new Divider()
          ],
        ),
    );

    return movieItem;
  }


}
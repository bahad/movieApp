import 'package:flutter/material.dart';

import '../services/movieservices.dart';

class MovieDetailViewModel extends ChangeNotifier {
  var movie;
  bool loading = false;

  getMovieDetail(String imdbID) async {
    loading = true;
    MovieServices().getMovieDetail(imdbID).then((value) {
      movie = value;
      loading = false;
      notifyListeners();
    });
  }
}

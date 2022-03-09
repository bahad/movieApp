import 'dart:convert';
import 'package:defacto_interview/src/model/movieDetailModel.dart';
import 'package:http/http.dart';
import '../model/moviemodel.dart';

abstract class IMovieRepository {
  Future searchMovie(String query, int page);
  Future getMovieDetail(String imdbID);
}

class MovieServices implements IMovieRepository {
  static const apiKey = "9655f948";
  static const apiUrl_ = "www.omdbapi.com";

  @override
  Future searchMovie(String query, int page) async {
    MovieModel movieModel;
    try {
      final queryParameters = {
        's': query,
        'page': page.toString(),
        'apikey': apiKey,
      };
      final response = await get(
        Uri.http(apiUrl_, '', queryParameters),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        movieModel = MovieModel.fromJson(decodedJson);
        return movieModel;
      } else {
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }

  @override
  Future getMovieDetail(String imdbID) async {
    MovieDetailModel movieDetailModel;
    try {
      final queryParameters = {
        'i': imdbID,
        'apikey': apiKey,
      };
      final response = await get(
        Uri.http(apiUrl_, '', queryParameters),
        headers: {"Accept": "application/json"},
      );

      if (response.statusCode == 200) {
        final decodedJson = json.decode(response.body);
        movieDetailModel = MovieDetailModel.fromJson(decodedJson);
        return movieDetailModel;
      } else {
        return 0;
      }
    } catch (e) {
      print(e);
      return 0;
    }
  }
}

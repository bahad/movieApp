import 'package:flutter/material.dart';
import '../model/favorites.dart';
import '../services/sqfservices.dart';

class FavoriteViewModel with ChangeNotifier {
  List<Favorite>? favList;
  bool isFavMatch = false;
  bool loading = false;
  bool isInsert = false;
  final DbHelper? _dbHelper = DbHelper();

  FavoriteViewModel() {
    getFav();
  }

  getFav() async {
    loading = true;
    favList = await _dbHelper!.getFavorite();
    loading = false;
    notifyListeners();
  }

  deleteFav(id) async {
    await _dbHelper!.removeFavorite(id);
    notifyListeners();
  }
}

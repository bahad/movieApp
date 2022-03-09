class Favorite {
  int? id;
  String? imdbID;
  String? title;
  String? year;
  String? type;
  String? poster;

  Favorite({this.imdbID, this.title, this.year, this.type, this.poster});
  Favorite.withId(
      {this.id, this.imdbID, this.title, this.year, this.type, this.poster});

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (id != null) {
      map["id"] = id;
    }
    map["imdbID"] = imdbID;
    map["title"] = title;
    map["year"] = year;
    map["type"] = type;
    map["poster"] = poster;
    return map;
  }

  Favorite.fromMap(Map<String, dynamic> map) {
    id = map["id"];
    imdbID = map["imdbID"];
    title = map["title"];
    year = map["year"];
    type = map["type"];
    poster = map["poster"];
  }
}

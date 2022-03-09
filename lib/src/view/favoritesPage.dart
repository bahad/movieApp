import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/sqfservices.dart';
import '../viewmodel/favoriteViewModel.dart';
import '../widgets/movieItem.dart';
import '../widgets/noData.dart';
import 'movieDetailPage.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late DbHelper dbHelper;

  @override
  void initState() {
    dbHelper = DbHelper();
    final favProvider = Provider.of<FavoriteViewModel>(context, listen: false);
    favProvider.getFav();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favProvider = Provider.of<FavoriteViewModel>(context);
    Size size = MediaQuery.of(context).size;
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: favProvider.favList == null
            ? const Center(child: CircularProgressIndicator())
            : favProvider.favList!.isEmpty
                ? const NoData(messages: "You haven't added favorites yet")
                : _buildGrid(favProvider.favList, favProvider, size));
  }

  _buildGrid(favList, FavoriteViewModel favProvider, size) {
    return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: favProvider.favList!.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          mainAxisSpacing: 5,
          crossAxisSpacing: 5,
          crossAxisCount: size.width < 500 ? 2 : 3,
          childAspectRatio: size.width < 500 ? 0.75 : 0.6,
        ),
        itemBuilder: (context, index) {
          var data = favProvider.favList![index];
          return MovieGridItem(
            data: data,
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MovieDetailPage(
                            movieName: data.title,
                            imdbID: data.imdbID,
                          )));
            },
          );
        });
  }
}

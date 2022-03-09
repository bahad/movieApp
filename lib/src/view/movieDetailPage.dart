import 'package:defacto_interview/src/components/custom_dialog.dart';
import 'package:defacto_interview/src/components/custom_text.dart';
import 'package:defacto_interview/src/services/sqfservices.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

import '../components/custom_snackbar.dart';
import '../constants.dart';
import '../model/favorites.dart';
import '../viewmodel/movieDetailViewModel.dart';

class MovieDetailPage extends StatefulWidget {
  final String? imdbID;
  final String? movieName;
  const MovieDetailPage(
      {Key? key, required this.imdbID, required this.movieName})
      : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  late DbHelper dbHelper;
  bool fav = false;
  @override
  void initState() {
    dbHelper = DbHelper();
    final movieDetailViewModel =
        Provider.of<MovieDetailViewModel>(context, listen: false);
    movieDetailViewModel.getMovieDetail(widget.imdbID!);
    getFav();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getFav() {
    dbHelper.getFavoriteMatch(widget.imdbID!).then((value) {
      if (mounted) {
        setState(() {
          if (mounted) {
            fav = value;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final movieDetailViewModel = Provider.of<MovieDetailViewModel>(context);

    return Scaffold(
        backgroundColor: primaryColor,
        floatingActionButton: FloatingActionButton(
          backgroundColor: secondaryColor,
          child: Icon(
            fav ? Icons.favorite : Icons.favorite_border_rounded,
          ),
          onPressed: () async {
            if (fav == false && movieDetailViewModel.movie != null) {
              var favorite = Favorite(
                title: movieDetailViewModel.movie.title.toString(),
                year: movieDetailViewModel.movie.year.toString(),
                imdbID: movieDetailViewModel.movie.imdbID.toString(),
                type: movieDetailViewModel.movie.type.toString(),
                poster: movieDetailViewModel.movie.poster.toString(),
              );
              CustomDialog.showConfirmDialog(
                  context, "Are you sure to add this movie favorite list", () {
                dbHelper.insertFavorite(favorite).then((value) {
                  if (value != 0) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(CustomSnackBar().addFavoriteSuccess);
                    setState(() {
                      fav = true;
                    });
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(CustomSnackBar().addFavoriteFail);
                  }
                  Navigator.of(context).pop();
                });
              });
              setState(() {});
            } else if (fav == true && movieDetailViewModel.movie != null) {
              CustomDialog.showConfirmDialog(
                  context, "Are you sure you want to delete", () {
                dbHelper
                    .removeFavorite(movieDetailViewModel.movie.imdbID!)
                    .then((value) {
                  if (value != 0) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(CustomSnackBar().removeFavoriteSuccess);
                    setState(() {
                      fav = false;
                    });
                  } else {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(CustomSnackBar().addFavoriteFail);
                  }
                  Navigator.of(context).pop();
                });
                setState(() {});
              });
            }
          },
        ),
        body: movieDetailViewModel.loading || movieDetailViewModel.movie == null
            ? const Center(child: CircularProgressIndicator())
            : NestedScrollView(
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      automaticallyImplyLeading: true,
                      expandedHeight: size.height / 3.4, //215
                      floating: false,
                      pinned: true,
                      backgroundColor: primaryColor,

                      flexibleSpace: LayoutBuilder(builder:
                          (BuildContext context, BoxConstraints constraints) {
                        var top = constraints.biggest.height;
                        return FlexibleSpaceBar(
                          centerTitle: false,
                          title: AnimatedOpacity(
                            duration: const Duration(seconds: 1),
                            opacity: top >= 105
                                ? 0.0
                                : top < (size.height / 3.4) / 2
                                    ? 1.0
                                    : 0.0,
                            child: Text(movieDetailViewModel.movie.title),
                          ),
                          collapseMode: CollapseMode.parallax,
                          background: AnimatedOpacity(
                              duration: const Duration(seconds: 2),
                              opacity: top <= 95
                                  ? 0.0
                                  : top < (size.height / 3.4) / 2
                                      ? 0.0
                                      : 1.0,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  Image.network(
                                    movieDetailViewModel.movie.poster,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                      bottom: 10,
                                      left: 0,
                                      child: Container(
                                        width: size.width,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            CustomText(
                                              sizes: Sizes.sliverTitle,
                                              fontWeight: FontWeight.bold,
                                              text: movieDetailViewModel
                                                  .movie.title,
                                              textAlign: TextAlign.center,
                                              color: Colors.white,
                                            ),
                                            const SizedBox(height: 12),
                                            CustomText(
                                              sizes: Sizes.normal,
                                              fontWeight: FontWeight.bold,
                                              text: movieDetailViewModel
                                                      .movie.year +
                                                  " | " +
                                                  movieDetailViewModel
                                                      .movie.genre +
                                                  " | " +
                                                  movieDetailViewModel
                                                      .movie.runtime,
                                              textAlign: TextAlign.center,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      )),
                                ],
                              )),
                        );
                      }),
                    )
                  ];
                },
                body: _body(movieDetailViewModel, size)));
  }

  Widget _body(MovieDetailViewModel movieDetailViewModel, Size size) {
    var actors = movieDetailViewModel.movie.actors.toString().split(',');
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //DIRECTOR
              CustomText(
                color: Colors.white,
                sizes: Sizes.normal,
                fontWeight: FontWeight.normal,
                text: "Director: " + movieDetailViewModel.movie.director,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    decoration: const BoxDecoration(),
                    child: RatingBar.builder(
                      itemSize: size.width < 500 ? 27.0 : 55.0,
                      initialRating:
                          double.parse(movieDetailViewModel.movie.imdbRating) /
                              2,
                      minRating: 1,
                      direction: Axis.horizontal,
                      allowHalfRating: true,
                      ignoreGestures: true,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 1.0),
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      tapOnlyMode: false,
                      onRatingUpdate: (_) {},
                    ),
                  ),
                  const SizedBox(width: 10.0),
                  //RATING
                  CustomText(
                    color: Colors.white,
                    sizes: Sizes.normal,
                    fontWeight: FontWeight.normal,
                    text: "( " + movieDetailViewModel.movie.imdbRating + " )",
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              // DESCRIPTION
              CustomText(
                color: Colors.white,
                sizes: Sizes.normal,
                fontWeight: FontWeight.normal,
                text: movieDetailViewModel.movie.plot,
                lineLimit: false,
              ),
              const SizedBox(height: 16.0),
              //ACTORS
              Container(
                decoration: const BoxDecoration(),
                height: size.height * 0.16,
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: actors.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: size.width < 500 ? 30 : 50,
                              backgroundImage: index == 0
                                  ? const AssetImage(
                                      'assets/images/avatar1.jpeg')
                                  : index == 1
                                      ? const AssetImage(
                                          'assets/images/avatar2.png')
                                      : const AssetImage(
                                          'assets/images/avatar3.jpeg'),
                            ),
                            const SizedBox(height: 6),
                            CustomText(
                              sizes: Sizes.small,
                              color: Colors.white,
                              text: actors[index],
                            )
                          ],
                        ),
                      );
                    }),
              ),

              const SizedBox(height: 6.0),
              //AWARDS
              Row(
                children: [
                  Image.asset(
                    'assets/images/awards.png',
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    child: CustomText(
                        sizes: Sizes.small,
                        color: Colors.white,
                        textAlign: TextAlign.left,
                        text: movieDetailViewModel.movie.awards),
                  )
                ],
              ),
              const SizedBox(height: 10.0),
              Row(
                children: [
                  Image.asset(
                    'assets/images/boxoffice.png',
                    height: 30,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 15),
                  Flexible(
                    child: CustomText(
                        sizes: Sizes.small,
                        color: Colors.white,
                        textAlign: TextAlign.left,
                        text: movieDetailViewModel.movie.boxOffice),
                  )
                ],
              )
            ],
          )),
    );
  }
}

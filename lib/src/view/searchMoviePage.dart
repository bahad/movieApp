import 'package:defacto_interview/src/components/custom_snackbar.dart';
import 'package:defacto_interview/src/components/custom_textfield.dart';
import 'package:defacto_interview/src/constants.dart';
import 'package:defacto_interview/src/services/movieservices.dart';
import 'package:defacto_interview/src/widgets/noData.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../widgets/movieItem.dart';
import 'movieDetailPage.dart';

class SearchMoviePage extends StatefulWidget {
  const SearchMoviePage({Key? key}) : super(key: key);

  @override
  State<SearchMoviePage> createState() => _SearchMoviePageState();
}

class _SearchMoviePageState extends State<SearchMoviePage> {
  var searchResult;
  late TextEditingController searchController;
  int currentPage = 1;
  late RefreshController refreshController;
  late ScrollController scrollController;

  @override
  void initState() {
    searchController = TextEditingController();
    refreshController = RefreshController(initialRefresh: true);
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    refreshController.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SmartRefresher(
        enablePullDown: false,
        enablePullUp: true,
        controller: refreshController,
        scrollController: scrollController,
        onLoading: () async {
          if (searchResult != null && searchResult!.isNotEmpty) {
            try {
              setState(() {
                currentPage++;
              });
              print(currentPage);
              MovieServices()
                  .searchMovie(searchController.text, currentPage)
                  .then((value) {
                if (value != 0 && value.search.length > 0) {
                  setState(() {
                    searchResult!.addAll(value.search);
                  });
                }
              });
              refreshController.refreshCompleted();
              refreshController.loadComplete();
              setState(() {});
            } catch (e) {
              refreshController.refreshFailed();
              refreshController.loadComplete();
            }
          } else {
            refreshController.refreshFailed();
            refreshController.loadComplete();
            setState(() {});
          }
        },
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            child: Column(
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        child: CustomTextField(
                      textEditingController: searchController,
                    )),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      child: const Text('Search'),
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(primaryColor)),
                      onPressed: () {
                        if (searchController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              CustomSnackBar().searchValidationMessage);
                        } else {
                          MovieServices()
                              .searchMovie(searchController.text, currentPage)
                              .then((value) {
                            if (value != 0 && value.search.length > 0) {
                              setState(() {
                                searchResult = value.search;
                              });
                            }
                          });
                        }
                      },
                    )
                  ],
                ),
                const SizedBox(height: 16.0),
                _buildGrid(size)
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGrid(Size size) {
    if (searchResult != null) {
      return Container(
        decoration: const BoxDecoration(),
        child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: searchResult!.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5,
              crossAxisSpacing: 5,
              crossAxisCount: size.width < 500 ? 2 : 3,
              childAspectRatio: size.width < 500 ? 0.75 : 0.6,
            ),
            itemBuilder: (context, index) {
              var data = searchResult![index];
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
            }),
      );
    } else if (searchResult == 0) {
      return const NoData(messages: "Check Your Internet Connection !");
    } else {
      return const SizedBox();
    }
  }
}

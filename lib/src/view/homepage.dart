import 'package:defacto_interview/src/constants.dart';
import 'package:flutter/material.dart';

import '../components/custom_text.dart';
import 'favoritesPage.dart';
import 'searchMoviePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: _body(size),
    );
  }

  Widget _body(Size size) {
    return DefaultTabController(
        animationDuration: const Duration(milliseconds: 500),
        length: 2,
        child: Scaffold(
          appBar: AppBar(
              backgroundColor: primaryColor,
              centerTitle: true,
              title: const CustomText(
                sizes: Sizes.title,
                text: 'Movies',
                fontWeight: FontWeight.normal,
              ),
              bottom: TabBar(
                labelStyle: TextStyle(
                    fontSize: size.width < 390
                        ? 14.0
                        : size.width >= 500
                            ? 22.0
                            : 16.0),
                tabs: const [
                  Tab(text: 'Movies'),
                  Tab(
                    text: 'Favorites',
                  ),
                ],
              )),
          body: const TabBarView(
            children: [
              SearchMoviePage(),
              FavoritesPage(),
            ],
          ),
        ));
  }
}

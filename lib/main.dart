import 'package:animations/animations.dart';
import 'package:defacto_interview/src/viewmodel/favoriteViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'src/view/homepage.dart';
import 'src/viewmodel/movieDetailViewModel.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<MovieDetailViewModel>(
            create: (_) => MovieDetailViewModel(),
          ),
          ChangeNotifierProvider<FavoriteViewModel>(
            create: (_) => FavoriteViewModel(),
          ),
        ],
        child: MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
                primarySwatch: Colors.blue,
                // fontFamily: 'gilroy-bold',

                pageTransitionsTheme: const PageTransitionsTheme(builders: {
                  TargetPlatform.android: SharedAxisPageTransitionsBuilder(
                    transitionType: SharedAxisTransitionType.horizontal,
                  ),
                  TargetPlatform.iOS: SharedAxisPageTransitionsBuilder(
                    transitionType: SharedAxisTransitionType.horizontal,
                  ),
                })),
            home: const HomePage()));
  }
}

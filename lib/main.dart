import 'package:flutter/material.dart';
import 'package:flutter_restoran_apps/common/style.dart';
import 'package:flutter_restoran_apps/models/restaurants.dart';
import 'package:flutter_restoran_apps/ui/home_page.dart';
import 'package:flutter_restoran_apps/ui/restaurants_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Restaurant App',
        theme: ThemeData(
          colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: primaryColor,
              onPrimary: Colors.black,
              secondary: secondaryColor),
          textTheme: myTextTheme,
          appBarTheme: const AppBarTheme(elevation: 0),
        ),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => const HomePage(),
          RestaurantsDetailPage.routeName: (context) => RestaurantsDetailPage(
              restaurant:
                  ModalRoute.of(context)?.settings.arguments as Restaurant)
        });
  }
}

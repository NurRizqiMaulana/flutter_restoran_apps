// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restoran_apps/models/restaurants.dart';
import 'package:flutter_restoran_apps/ui/restaurants_detail_page.dart';
import 'package:flutter_restoran_apps/widgets/platform_widgets.dart';

class RestaurantsListPage extends StatelessWidget {
  static const routeName = '/restaurants_list';

  const RestaurantsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  FutureBuilder<String> _buildList(BuildContext context) {
    return FutureBuilder<String>(
      future:
          DefaultAssetBundle.of(context).loadString('assets/restaurants.json'),
      builder: (context, snapshot) {
        List<Restaurant> restaurants = parseRestaurant(snapshot.data);
        return ListView.builder(
            itemCount: restaurants.length,
            itemBuilder: (context, index) {
              return _buildRestaurantItem(context, restaurants[index]);
            });
      },
    );
  }

  Widget _buildRestaurantItem(BuildContext context, Restaurant restaurant) {
    return Material(
      child: ListTile(
        leading: Hero(
          tag: restaurant.pictureId,
          child: Image.network(
            restaurant.pictureId,
            width: 100,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Padding(
            padding: const EdgeInsets.only(bottom: 2),
            child: Text(
              restaurant.name,
              style: Theme.of(context).textTheme.titleLarge,
            )),
        subtitle: Column(
          children: [
            Row(
              children: [
                const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(restaurant.city),
              ],
            ),
            const SizedBox(
              height: 8.0,
            ),
            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 15,
                ),
                const SizedBox(width: 5),
                Text(restaurant.rating.toString()),
              ],
            ),
          ],
        ),
        onTap: () {
          Navigator.pushNamed(context, RestaurantsDetailPage.routeName,
              arguments: restaurant);
        },
      ),
    );
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurant App',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.orange,
      ),
      body: _buildList(context),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
        navigationBar: const CupertinoNavigationBar(
          middle: Text('Restaurant App'),
          transitionBetweenRoutes: false,
        ),
        child: _buildList(context));
  }
}

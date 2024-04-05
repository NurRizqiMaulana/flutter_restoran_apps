// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restoran_apps/provider/get_list_restaurants_provider.dart';
import 'package:flutter_restoran_apps/ui/restaurants_search.dart';
import 'package:flutter_restoran_apps/ui/restaurants_favorite_page.dart';
import 'package:flutter_restoran_apps/widgets/card_restaurant.dart';
import 'package:flutter_restoran_apps/widgets/platform_widgets.dart';
import 'package:provider/provider.dart';

class RestaurantsListPage extends StatefulWidget {
  const RestaurantsListPage({super.key});

  @override
  State<RestaurantsListPage> createState() => _RestaurantsListPageState();
}

class _RestaurantsListPageState extends State<RestaurantsListPage> {
  Widget _buildList(BuildContext context) {
    return Consumer<GetListRestaurantProvider>(
      builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.blue,
          ));
        } else if (state.state == ResultState.hasData) {
          return ListView.builder(
              shrinkWrap: true,
              itemCount: state.result.restaurants.length,
              itemBuilder: (context, index) {
                var restaurant = state.result.restaurants[index];
                return CardRestaurant(restaurant: restaurant);
              });
        } else if (state.state == ResultState.noData) {
          return const Center(
            child: Material(child: Text('Gagal memuat data!')),
          );
        } else if (state.state == ResultState.error) {
          return const Center(
            child: Material(
              child: Text('Gagal memuat data!'),
            ),
          );
        } else {
          return const Center(
            child: Material(
              child: Text(''),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Restaurant App',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: RestaurantSearch());
            },
            icon: const Icon(Icons.search),
            color: Colors.white,
          )
        ],
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

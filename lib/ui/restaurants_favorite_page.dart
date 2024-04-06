import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restoran_apps/provider/database_provider.dart';
import 'package:flutter_restoran_apps/utils/result_state.dart';
import 'package:flutter_restoran_apps/widgets/card_restaurant.dart';
import 'package:flutter_restoran_apps/widgets/platform_widgets.dart';
import 'package:provider/provider.dart';

class RestaurantFavoritePage extends StatelessWidget {
  static const String favoriteTitle = 'Favorite';

  const RestaurantFavoritePage({Key? key}) : super(key: key);

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(favoriteTitle),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: _buildList(),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text(favoriteTitle),
      ),
      child: _buildList(),
    );
  }

  Widget _buildList() {
    return Consumer<DatabaseProvider>(
      builder: (context, provider, child) {
        if (provider.state == ResultState.hasData) {
          return ListView.builder(
            itemCount: provider.favorite.length,
            itemBuilder: (context, index) {
              return CardRestaurant(restaurant: provider.favorite[index]);
            },
          );
        } else {
          return Center(
            child: Material(
              child: Text(provider.message),
            ),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(
      androidBuilder: _buildAndroid,
      iosBuilder: _buildIos,
    );
  }
}

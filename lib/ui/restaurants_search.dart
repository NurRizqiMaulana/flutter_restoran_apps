import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_restoran_apps/data/api/api_service.dart';
import 'package:flutter_restoran_apps/provider/search_restaurants_provider.dart';
import 'package:flutter_restoran_apps/widgets/card_restaurant.dart';
import 'package:provider/provider.dart';

class RestaurantSearch extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: const Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    return ChangeNotifierProvider<SearchRestaurantProvider>(
      create: (context) => SearchRestaurantProvider(
          apiService: ApiService(client: http.Client()), query: query),
      child: Consumer<SearchRestaurantProvider>(builder: (context, state, _) {
        if (state.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
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
            child: Material(child: Text('Koneksi Terputus!')),
          );
        } else {
          return const Material(
            child: Text(''),
          );
        }
      }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text('Search restaurant'));
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return theme.copyWith(
      appBarTheme: const AppBarTheme(
        color: Colors.orange, // Ubah sesuai warna yang diinginkan
      ),
    );
  }
}

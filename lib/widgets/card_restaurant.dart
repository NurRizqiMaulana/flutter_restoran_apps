import 'package:flutter/material.dart';
import 'package:flutter_restoran_apps/data/model/restaurants.dart';
import 'package:flutter_restoran_apps/ui/restaurants_detail_page.dart';

class CardRestaurant extends StatelessWidget {
  final Restaurant restaurant;
  final _baseUrl = 'https://restaurant-api.dicoding.dev/images/small';

  const CardRestaurant({super.key, required this.restaurant});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Hero(
          tag: restaurant.pictureId,
          child: Image.network(
            '$_baseUrl/${restaurant.pictureId}',
            width: 100,
          ),
        ),
        title: Text(restaurant.name),
        subtitle: Row(children: [
          Row(children: [
            const Icon(
              Icons.location_pin,
              color: Colors.red,
              size: 15,
            ),
            const SizedBox(width: 5),
            Text(restaurant.city)
          ]),
          const Spacer(),
          Row(
            children: [
              const Icon(
                Icons.star,
                color: Colors.yellow,
                size: 15,
              ),
              const SizedBox(width: 5),
              Text(restaurant.rating.toString())
            ],
          )
        ]),
        onTap: () {
          Navigator.pushNamed(context, RestaurantsDetailPage.routeName,
              arguments: restaurant.id);
        },
      ),
    );
  }
}

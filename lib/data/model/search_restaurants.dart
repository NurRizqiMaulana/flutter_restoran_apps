import 'dart:convert';

import 'package:flutter_restoran_apps/data/model/restaurants.dart';

class SearchRestaurantResult {
  bool error;
  int founded;
  List<Restaurant> restaurants;

  SearchRestaurantResult({
    required this.error,
    required this.founded,
    required this.restaurants,
  });

  factory SearchRestaurantResult.fromRawJson(String str) =>
      SearchRestaurantResult.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory SearchRestaurantResult.fromJson(Map<String, dynamic> json) =>
      SearchRestaurantResult(
        error: json["error"],
        founded: json["founded"],
        restaurants: List<Restaurant>.from(
            json["restaurants"].map((x) => Restaurant.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "error": error,
        "founded": founded,
        "restaurants": List<dynamic>.from(restaurants.map((x) => x.toJson())),
      };
}

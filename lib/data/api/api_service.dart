import 'dart:convert';
import 'package:flutter_restoran_apps/data/model/detail_restaurants.dart';
import 'package:flutter_restoran_apps/data/model/restaurants.dart';
import 'package:flutter_restoran_apps/data/model/search_restaurants.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'https://restaurant-api.dicoding.dev';

  Future<RestaurantsResult> getListRestaurant() async {
    final response = await http.get(Uri.parse('$_baseUrl/list'));
    if (response.statusCode == 200) {
      return RestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get list restaurant');
    }
  }

  Future<DetailRestaurantsResult> getDetailRestaurant(id) async {
    final response = await http.get(Uri.parse('$_baseUrl/detail/$id'));
    if (response.statusCode == 200) {
      return DetailRestaurantsResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get list restaurant');
    }
  }

  Future<SearchRestaurantResult> searchRestaurant(query) async {
    final response = await http.get(Uri.parse('$_baseUrl/search?q=$query'));
    if (response.statusCode == 200) {
      return SearchRestaurantResult.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get restaurants');
    }
  }
}

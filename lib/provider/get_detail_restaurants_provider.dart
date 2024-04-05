import 'package:flutter/material.dart';
import 'package:flutter_restoran_apps/data/api/api_service.dart';
import 'package:flutter_restoran_apps/data/model/detail_restaurants.dart';

enum ResultState { loading, noData, hasData, error }

class GetDetailRestaurantProvider extends ChangeNotifier {
  final ApiService apiService;
  final String id;

  GetDetailRestaurantProvider({required this.apiService, required this.id}) {
    _fetchAllRestaurant();
  }

  late DetailRestaurantsResult _detailRestaurantsResult;
  late ResultState _state;
  String _message = '';

  String get message => _message;

  DetailRestaurantsResult get result => _detailRestaurantsResult;

  ResultState get state => _state;

  Future<dynamic> _fetchAllRestaurant() async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final response = await apiService.getDetailRestaurant(id);
      if (response.error) {
        _state = ResultState.noData;
        notifyListeners();
        return _message = 'Empty Data';
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        return _detailRestaurantsResult = response;
      }
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      return _message = e.toString();
    }
  }
}

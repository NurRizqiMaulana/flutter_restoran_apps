import 'package:flutter_restoran_apps/data/model/restaurants.dart';
import 'package:flutter_test/flutter_test.dart';

var testRestaurant = {
  "id": "rqdv5juczeskfw1e867",
  "name": "Melting Pot",
  "description":
      "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. ...",
  "city": "Medan",
  "address": "Jln. Pandeglang no 19",
  "pictureId": "14",
  "rating": 4.2,
};
void main() {
  test("Test Parsing", () async {
    var result = Restaurant.fromJson(testRestaurant).id;

    expect(result, "rqdv5juczeskfw1e867");
  });
}

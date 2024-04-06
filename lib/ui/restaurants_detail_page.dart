import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_restoran_apps/data/api/api_service.dart';
import 'package:flutter_restoran_apps/data/model/restaurants.dart';
import 'package:flutter_restoran_apps/provider/database_provider.dart';
import 'package:flutter_restoran_apps/provider/get_detail_restaurants_provider.dart';
import 'package:provider/provider.dart';

class RestaurantsDetailPage extends StatefulWidget {
  static const routeName = '/restaurant_detail';

  final String id;

  const RestaurantsDetailPage({
    super.key,
    required this.id,
  });

  @override
  State<RestaurantsDetailPage> createState() => _RestaurantsDetailPageState();
}

class _RestaurantsDetailPageState extends State<RestaurantsDetailPage> {
  final _baseUrl = 'https://restaurant-api.dicoding.dev/images/large';
  bool isReadMore = false;
  int maxLine = 2;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<GetDetailRestaurantProvider>(
      create: (context) => GetDetailRestaurantProvider(
          apiService: ApiService(client: http.Client()), id: widget.id),
      child: Consumer<GetDetailRestaurantProvider>(
        builder: (context, state, _) {
          if (state.state == ResultState.loading) {
            return const Material(
              child: Center(
                  child: CircularProgressIndicator(
                color: Colors.orange,
              )),
            );
          } else if (state.state == ResultState.hasData) {
            var restaurant = state.result.restaurant;
            return Scaffold(
              appBar: AppBar(
                title: Text(restaurant.name),
                foregroundColor: Colors.white,
                backgroundColor: Colors.orange,
              ),
              body: SingleChildScrollView(
                child: Column(
                  children: [
                    Hero(
                        tag: restaurant.pictureId,
                        child:
                            Image.network('$_baseUrl/${restaurant.pictureId}')),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              SizedBox(
                                child: Text(
                                  restaurant.name,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                  ),
                                ),
                              ),
                              Consumer<DatabaseProvider>(
                                builder: (context, provider, child) {
                                  return FutureBuilder<bool>(
                                    future: provider.isFavorited(restaurant.id),
                                    builder: (context, snapshot) {
                                      var isFavorited = snapshot.data ?? false;
                                      return IconButton(
                                        icon: Icon(
                                          isFavorited
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                        ),
                                        onPressed: () {
                                          if (isFavorited) {
                                            // Hapus dari favorit jika sudah ditandai sebagai favorit
                                            provider
                                                .removeFavorite(restaurant.id);
                                          } else {
                                            // Tambahkan ke favorit jika belum ditandai sebagai favorit
                                            provider.addFavorite(
                                                restaurant as Restaurant);
                                          }
                                          // Handle favorite button press
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                              Icon(Icons.favorite_border_outlined)
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            children: [
                              Row(children: [
                                const Icon(
                                  Icons.location_pin,
                                  color: Colors.red,
                                  size: 15,
                                ),
                                const SizedBox(width: 5),
                                Text(
                                    '${restaurant.address}, ${restaurant.city}')
                              ]),
                              const Spacer(),
                            ],
                          ),
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              Text(
                                restaurant.rating.toString(),
                              ),
                              RatingBarIndicator(
                                rating: restaurant.rating,
                                itemBuilder: (context, index) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                itemSize: 18,
                              ),
                            ],
                          ),
                          const Divider(color: Colors.grey),
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Categories',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: restaurant.categories.length,
                              itemBuilder: (_, index) {
                                return Align(
                                  alignment: Alignment.center,
                                  child:
                                      Text(restaurant.categories[index].name),
                                );
                              }),
                          const Divider(color: Colors.grey),
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
                            alignment: Alignment.topLeft,
                            child: Text(
                              'Description : ',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            child: Text(
                              restaurant.description,
                              textAlign: TextAlign.justify,
                            ),
                          ),
                          const Divider(
                            color: Colors.grey,
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Menu',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const Text(
                                      'Foods:',
                                      textAlign: TextAlign.center,
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: restaurant.menus.foods.length,
                                      itemBuilder: (_, index) {
                                        return Align(
                                          alignment: Alignment.topLeft,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical:
                                                    4), // Padding untuk jarak antara teks dan tepi kontainer
                                            margin: const EdgeInsets.symmetric(
                                                vertical:
                                                    8), // Padding agar teks tidak berdekatan dengan tepi kontainer
                                            decoration: BoxDecoration(
                                              color: Colors.orange[
                                                  200], // Warna latar belakang
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              // Membuat sudut kontainer lebih melengkung
                                            ),
                                            child: Column(
                                              children: [
                                                Text(
                                                  restaurant
                                                      .menus.foods[index].name,
                                                  style: const TextStyle(
                                                      fontSize:
                                                          16), // Ukuran teks
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                children: [
                                  const Text('Drinks:'),
                                  ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: restaurant.menus.drinks.length,
                                    itemBuilder: (_, index) {
                                      return Align(
                                        alignment: Alignment.topLeft,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical:
                                                  4), // Padding untuk jarak antara teks dan tepi kontainer
                                          margin: const EdgeInsets.symmetric(
                                              vertical:
                                                  8), // Padding agar teks tidak berdekatan dengan tepi kontainer
                                          decoration: BoxDecoration(
                                            color: Colors.orange[
                                                200], // Warna latar belakang
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            // Membuat sudut kontainer lebih melengkung
                                          ),
                                          child: Column(
                                            children: [
                                              Text(
                                                restaurant
                                                    .menus.drinks[index].name,
                                                style: const TextStyle(
                                                    fontSize:
                                                        16), // Ukuran teks
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ))
                            ],
                          ),
                          const Divider(color: Colors.grey),
                          const SizedBox(
                            height: 10,
                          ),
                          const Align(
                            alignment: Alignment.center,
                            child: Text(
                              'Customer Review',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: restaurant.customerReviews.length,
                            itemBuilder: (_, index) {
                              return Align(
                                alignment: Alignment.center,
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                        restaurant.customerReviews[index].name),
                                    Text(
                                        restaurant.customerReviews[index].date),
                                    Text(restaurant
                                        .customerReviews[index].review),
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          } else if (state.state == ResultState.noData) {
            return const Material(
                child: Center(child: Text('Gagal memuat data!')));
          } else if (state.state == ResultState.error) {
            return const Material(
                child: Center(child: Text('Gagal memuat data!')));
          } else {
            return const Material(child: Text(''));
          }
        },
      ),
    );
  }
}

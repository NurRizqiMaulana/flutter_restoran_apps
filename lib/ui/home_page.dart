import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_restoran_apps/common/style.dart';
import 'package:flutter_restoran_apps/data/api/api_service.dart';
import 'package:flutter_restoran_apps/provider/get_list_restaurants_provider.dart';
import 'package:flutter_restoran_apps/provider/scheduling_provider.dart';
import 'package:flutter_restoran_apps/ui/restaurants_detail_page.dart';
import 'package:flutter_restoran_apps/ui/restaurants_list_page.dart';
import 'package:flutter_restoran_apps/ui/restaurants_favorite_page.dart';
import 'package:flutter_restoran_apps/ui/setting_page.dart';
import 'package:flutter_restoran_apps/utils/notification_helper.dart';
import 'package:flutter_restoran_apps/widgets/platform_widgets.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  static const routeName = '/home_page';

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final NotificationHelper _notificationHelper = NotificationHelper();
  int _bottomNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return PlatformWidget(androidBuilder: _buildAndroid, iosBuilder: _buildIos);
  }

  Widget _buildAndroid(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: secondaryColor,
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: (selected) {
          setState(() {
            _bottomNavIndex = selected;
          });
        },
      ),
    );
  }

  Widget _buildIos(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
          activeColor: secondaryColor, items: _bottomNavBarItems),
      tabBuilder: (_, index) {
        switch (index) {
          case 1:
            return const RestaurantFavoritePage();
          case 2:
            return const SettingsPage();
          default:
            return const RestaurantsListPage();
        }
      },
    );
  }

  final List<BottomNavigationBarItem> _bottomNavBarItems = [
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.news : Icons.home),
      label: "Home",
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.favorite),
      label: "Favorite",
    ),
    BottomNavigationBarItem(
      icon: Icon(Platform.isIOS ? CupertinoIcons.settings : Icons.settings),
      label: "Settings",
    ),
  ];

  final List<Widget> _listWidget = [
    ChangeNotifierProvider(
      create: (_) => GetListRestaurantProvider(apiService: ApiService()),
      child: const RestaurantsListPage(),
    ),
    const RestaurantFavoritePage(),
    ChangeNotifierProvider<SchedulingProvider>(
      create: (_) => SchedulingProvider(),
      child: const SettingsPage(),
    ),
    const SettingsPage(),
    // ChangeNotifierProvider(
    //   create: (_) => SearchRestaurantProvider(apiService: ApiService()),
    //   child: const RestaurantSearchPage(),
    // ),
  ];

  @override
  void initState() {
    super.initState();
    _notificationHelper.configureSelectNotificationSubject(
        context, RestaurantsDetailPage.routeName);
  }

  @override
  void dispose() {
    selectNotificationSubject.close();
    super.dispose();
  }
}

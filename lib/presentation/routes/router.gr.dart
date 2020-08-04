// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import '../pages/basket_page.dart';
import '../pages/store_page.dart';

class Routes {
  static const String storePage = '/';
  static const String basketPage = '/basket-page';
  static const all = <String>{
    storePage,
    basketPage,
  };
}

class Router extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.storePage, page: StorePage),
    RouteDef(Routes.basketPage, page: BasketPage),
  ];
  @override
  Map<Type, AutoRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, AutoRouteFactory>{
    StorePage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => StorePage(),
        settings: data,
      );
    },
    BasketPage: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => BasketPage(),
        settings: data,
      );
    },
  };
}

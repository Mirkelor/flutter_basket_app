import 'dart:convert';

import 'package:basket_app/core/constants.dart';
import 'package:basket_app/core/exception.dart';
import 'package:basket_app/domain/listing_item.dart';
import 'package:basket_app/model/listing_item_model.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

@lazySingleton
class ListingItemLocalDataSource {
  SharedPreferences sharedPreferences;

  ListingItemLocalDataSource({@required this.sharedPreferences});

  Future<Map<String, int>> getBasket() async {
    final jsonString = sharedPreferences.get(BASKET);
    if (jsonString != null) {
      final jsonMap = json.decode(jsonString) as Map;
      final Map<String, int> jsonObject = jsonMap.cast<String, int>() ?? null;
      return jsonObject;
    } else {
      throw CacheException();
    }
  }

  Future<void> addToBasket(ListingItemModel listingItemModel) async {
    final jsonString = sharedPreferences.get(BASKET);
    var jsonMap;
    Map<String, int> jsonObject;
    if (jsonString != null) {
      jsonMap = json.decode(jsonString) as Map;
      jsonObject = jsonMap.cast<String, int>();
    } else {
      jsonObject = Map<String, int>();
    }
    final String key = listingItemModel.id;
    if (jsonObject.containsKey(key)) {
      jsonObject.update(key, (value) => value + 1);
    } else if (!jsonObject.containsKey(key)) {
      jsonObject[key] = 1;
    }
    sharedPreferences.setString(BASKET, json.encode(jsonObject));
  }

  Future<void> saveStoreItemList(List<ListingItem> listingItemList) async {
    final jsonObject = sharedPreferences.get(STORE);
    if (jsonObject == null) {
      sharedPreferences.setString(STORE, json.encode(listingItemList));
    }
  }

  Future<List<ListingItem>> getStoreItemList() async {
    final jsonObject = sharedPreferences.get(STORE);
    if (jsonObject != null) {
      return jsonObject;
    } else {
      return null;
    }
  }

  ListingItem getStoreItemById(String id) {
    final jsonString = sharedPreferences.getString(STORE);
    if (jsonString != null) {
      final List<ListingItem> jsonObject = (json.decode(jsonString) as List)
          .map((e) => ListingItemModel.fromJson(e).toDomain())
          .toList();
      return jsonObject.firstWhere((e) => e.id == id);
    } else {
      return null;
    }
  }

  Future<void> clearKey(String key) async {
    await sharedPreferences.remove(key);
  }
}

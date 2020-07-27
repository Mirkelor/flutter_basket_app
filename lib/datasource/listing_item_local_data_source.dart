import 'dart:convert';

import 'package:basket_app/core/constants.dart';
import 'package:basket_app/core/exception.dart';
import 'package:basket_app/domain/listing_item.dart';
import 'package:basket_app/model/listing_item_model.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListingItemLocalDataSource {
  SharedPreferences sharedPreferences;

  ListingItemLocalDataSource({@required this.sharedPreferences});

  Future<Map<String, int>> getBasket() async {
    final Map<String, int> jsonObject = sharedPreferences.get(BASKET);
    if (jsonObject != null) {
      return jsonObject;
    } else {
      throw CacheException();
    }
  }

  Future<void> addToBasket(ListingItemModel listingItemModel) async {
    final Map<String, int> jsonObject =
        sharedPreferences.get(BASKET) ?? Map<String, int>();
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

  Future<ListingItem> getStoreItemById(String id) async {
    final jsonObject = sharedPreferences.get(STORE);
    if (jsonObject != null) {
      return (jsonObject as List<ListingItem>).firstWhere((e) => e.id == id);
    } else {
      return null;
    }
  }
}

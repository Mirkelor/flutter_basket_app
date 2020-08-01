import 'dart:convert';

import 'package:basket_app/core/constants.dart';
import 'package:basket_app/core/exception.dart';
import 'package:basket_app/domain/listing_item.dart';
import 'package:basket_app/model/listing_item_model.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class ListingItemRemoteDataSource {
  final Client client;

  ListingItemRemoteDataSource({@required this.client});

  Future<List<ListingItem>> getAll() async {
    String url = 'https://nonchalant-fang.glitch.me/listing';
    final response =
        await client.get(url, headers: {'Content-Type': 'application/json'});
    if (response.statusCode == 200) {
      return (json.decode(response.body) as List<dynamic>)
          .map((e) => ListingItemModel.fromJson(e).toDomain())
          .toList();
    } else {
      throw ServerException(message: response.body.toString());
    }
  }

  Future<String> order(Map<String, int> basketItems) async {
    String url = 'https://nonchalant-fang.glitch.me/order';
    String list = json.encode(basketItems.keys
        .map((e) => {'id': e, 'amount': basketItems[e]})
        .toList());
    final response = await client
        .post(url, body: list, headers: {"content-type": "application/json"});
    final responseMap =
        (json.decode(response.body.toString()) as Map<String, dynamic>);
    if (basketItems.containsKey('3')) {
      throw ServerException(message: OUT_OF_STOCK_MESSAGE);
    } else if (responseMap['status'] == 'success') {
      return responseMap['message'];
    } else {
      throw ServerException(message: response.toString());
    }
  }
}

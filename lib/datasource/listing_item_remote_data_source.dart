import 'dart:convert';

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
      throw ServerException();
    }
  }
}

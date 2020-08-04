import 'dart:convert';

import 'package:basket_app/core/constants.dart';
import 'package:basket_app/core/exception.dart';
import 'package:basket_app/datasource/listing_item_local_data_source.dart';
import 'package:basket_app/domain/listing_item.dart';
import 'package:basket_app/model/listing_item_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  ListingItemLocalDataSource dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = ListingItemLocalDataSource(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('basketTests', () {
    final listingItemModel = ListingItemModel(
        id: '1',
        name: 'test',
        price: '1',
        currency: 'try',
        image: 'test image url');
    final List<ListingItem> listingItemList = [listingItemModel.toDomain()];
    final Map<String, int> testBasket1 = Map<String, int>();
    testBasket1['1'] = 1;
    final Map<String, int> testBasket2 = Map<String, int>();
    testBasket2['1'] = 2;
    final Map<String, int> testBasket3 = Map<String, int>();
    testBasket3['1'] = 3;

    test('should return basket when getBasket method called', () async {
      when(mockSharedPreferences.get(any))
          .thenAnswer((_) => json.encode(testBasket1));

      final response = await dataSource.getBasket();

      verify(mockSharedPreferences.get(BASKET));
      expect(response, equals(testBasket1));
    });

    test('should throw CacheException when basket is empty', () async {
      when(mockSharedPreferences.get(any)).thenAnswer((_) => null);

      final call = dataSource.getBasket;

      expect(call, throwsA(isInstanceOf<CacheException>()));
    });
    test('''should addToBasket when there is basket item with 2 qty then 
    item qty should be 3''', () async {
      when(mockSharedPreferences.get(any)).thenReturn(json.encode(testBasket2));

      await dataSource.addToBasket(listingItemModel);
      final expectedJsonMap = json.encode(testBasket3);

      verify(mockSharedPreferences.setString(BASKET, expectedJsonMap));
    });

    test('''should addToBasket when there is no basket item then item qty 
    should be 1''', () async {
      when(mockSharedPreferences.get(any)).thenReturn(null);

      await dataSource.addToBasket(listingItemModel);
      final expectedJsonMap = json.encode(testBasket1);

      verify(mockSharedPreferences.setString(BASKET, expectedJsonMap));
    });

    test('''should saveStoreItemList when there is no store item 
    in shared preferences''', () async {
      when(mockSharedPreferences.get(any)).thenReturn(null);

      await dataSource.saveStoreItemList(listingItemList);
      final expectedJsonMap = json.encode(listingItemList);

      verify(mockSharedPreferences.setString(STORE, expectedJsonMap));
    });

    test('''should getStoreItemList when there is store items 
        in shared preferences''', () async {
      when(mockSharedPreferences.get(any)).thenReturn(listingItemList);

      final result = await dataSource.getStoreItemList();

      verify(mockSharedPreferences.get(STORE));
      expect(result, equals(listingItemList));
    });

    test('''should getStoreItemById when there is store item with given id
        in shared preferences''', () async {
      when(mockSharedPreferences.get(any)).thenReturn(listingItemList);

      final result = dataSource.getStoreItemById('1');

      verify(mockSharedPreferences.get(STORE));
      expect(result, equals(listingItemModel.toDomain()));
    });
  });
}

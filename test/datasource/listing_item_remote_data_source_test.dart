import 'dart:convert';

import 'package:basket_app/core/constants.dart';
import 'package:basket_app/core/exception.dart';
import 'package:basket_app/datasource/listing_item_remote_data_source.dart';
import 'package:basket_app/domain/listing_item.dart';
import 'package:basket_app/model/listing_item_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements Client {}

void main() {
  ListingItemRemoteDataSource dataSource;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = ListingItemRemoteDataSource(client: mockHttpClient);
  });

  group('getAllListingItem', () {
    final listingItemModel = ListingItemModel(
        id: '1',
        name: 'test',
        price: '1',
        currency: 'try',
        image: 'test image url');
    final List<ListingItem> listingItemList = [listingItemModel.toDomain()];
    final String testResponse =
        json.encode(List.filled(1, listingItemModel.toJson()));

    test('should perform a GET request on a URL with application/json header',
        () {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(testResponse, 200));

      dataSource.getAll();

      verify(mockHttpClient.get('https://nonchalant-fang.glitch.me/listing',
          headers: {'Content-Type': 'application/json'}));
    });

    test('should return listing item when the response code is 200 (success)',
        () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(testResponse, 200));

      final response = await dataSource.getAll();

      expect(response, equals(listingItemList));
    });

    test(
        'should throw a ServerException when the response code is 404 or other',
        () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers')))
          .thenAnswer((_) async => Response('Something went wrong', 404));

      final call = dataSource.getAll;

      expect(call(), throwsA(isInstanceOf<ServerException>()));
    });
  });

  group('order test', () {
    final String successResponse =
        json.encode({'status': 'success', 'message': 'test message'});
    final Map<String, int> testBasket = Map<String, int>();
    testBasket['1'] = 1;
    final Map<String, int> testBasketFail = Map<String, int>();
    testBasketFail['3'] = 1;

    test('should POST request on a URL with application/json header', () async {
      when(mockHttpClient.post(any,
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(successResponse, 200));
      await dataSource.order(testBasket);

      verify(mockHttpClient.post('https://nonchalant-fang.glitch.me/order',
          body: anyNamed('body'),
          headers: {'content-type': 'application/json'}));
    });

    test('should not throw exception when the response code is 200 (success)',
        () async {
      when(mockHttpClient.post(any,
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(successResponse, 200));

      final response = await dataSource.order(testBasket);

      expect(response, 'test message');
    });

    test('''should throw ServerException with out of stock message 
    when the basket item is out of stock''', () async {
      when(mockHttpClient.post(any,
              body: anyNamed('body'), headers: anyNamed('headers')))
          .thenAnswer((_) async => Response(successResponse, 200));

      final call = dataSource.order;

      expect(
          call(testBasketFail),
          throwsA(predicate((e) =>
              e is ServerException && e.message == OUT_OF_STOCK_MESSAGE)));
    });
  });
}

import 'package:basket_app/core/constants.dart';
import 'package:basket_app/core/exception.dart';
import 'package:basket_app/core/failure.dart';
import 'package:basket_app/core/network_info.dart';
import 'package:basket_app/datasource/listing_item_local_data_source.dart';
import 'package:basket_app/datasource/listing_item_remote_data_source.dart';
import 'package:basket_app/domain/listing_item.dart';
import 'package:basket_app/model/listing_item_model.dart';
import 'package:basket_app/repository/listing_item_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockRemoteDataSource extends Mock implements ListingItemRemoteDataSource {
}

class MockLocalDataSource extends Mock implements ListingItemLocalDataSource {}

void main() {
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;
  ListingItemRepository repository;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    repository = ListingItemRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('listing item repository test', () {
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
    final Map<String, int> testBasketFail = Map<String, int>();
    testBasket3['3'] = 1;
    test('should check if the device is online', () {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);

      repository.getAll();

      verify(mockNetworkInfo.isConnected);
    });

    test('''should return remote data when the call to remote data source 
    is successful''', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAll())
          .thenAnswer((_) async => listingItemList);

      final result = await repository.getAll();

      verify(mockRemoteDataSource.getAll());
      verify(mockLocalDataSource.saveStoreItemList(listingItemList));
      expect(result, equals(Right(listingItemList)));
    });

    test('''should return server failure when the call to remote data source 
    is unsuccessful''', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAll())
          .thenThrow(ServerException(message: 'test error message'));

      final result = await repository.getAll();

      verify(mockRemoteDataSource.getAll());
      expect(result, Left(ServerFailure('test error message')));
    });

    test('should return no internet failure when the device offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getAll();

      verify(mockNetworkInfo.isConnected);
      expect(result, Left(NoInternetFailure(NO_INTERNET_FAILURE_MESSAGE)));
    });

    test('should get basket when there is basket data', () async {
      when(mockLocalDataSource.getBasket())
          .thenAnswer((_) async => testBasket1);

      final result = await repository.getBasket();

      verify(mockLocalDataSource.getBasket());
      expect(result, equals(Right(testBasket1)));
    });

    test('''should return cache failure to get basket call 
    when there is no basket data''', () async {
      when(mockLocalDataSource.getBasket()).thenThrow(CacheException());

      final result = await repository.getBasket();

      verify(mockLocalDataSource.getBasket());
      expect(result, equals(Left(CacheFailure(CACHE_FAILURE_MESSAGE))));
    });

    test('should addToBasket to given listing item model', () async {
      await repository.addToBasket(listingItemModel.toDomain());

      verify(mockLocalDataSource.addToBasket(listingItemModel));
    });

    test('should saveStoreItemList to given listing item list', () async {
      await repository.saveStoreItemList(listingItemList);

      verify(mockLocalDataSource.saveStoreItemList(listingItemList));
    });

    test('should getStoreItemList to return listing item list', () async {
      await repository.getStoreItemList();

      verify(mockLocalDataSource.getStoreItemList());
    });

    test('should getStoreItemById to return listing item by id', () async {
      await repository.getStoreItemById('2');

      verify(mockLocalDataSource.getStoreItemById('2'));
    });

    test('should order successfully', () async {
      when(mockRemoteDataSource.order(testBasket1))
          .thenAnswer((_) async => 'test response');

      await repository.order(testBasket1);

      verify(mockRemoteDataSource.order(testBasket1));
    });

    test('should return server failure when order request is fail', () async {
      when(mockRemoteDataSource.order(testBasket1))
          .thenThrow(ServerException(message: 'test error message'));

      final result = await repository.order(testBasket1);

      verify(mockRemoteDataSource.order(testBasket1));
      expect(result, equals(Left(ServerFailure('test error message'))));
    });
  });
}

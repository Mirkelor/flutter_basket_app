import 'package:basket_app/core/exception.dart';
import 'package:basket_app/core/failure.dart';
import 'package:basket_app/core/network_info.dart';
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

void main() {
  MockRemoteDataSource mockRemoteDataSource;
  MockNetworkInfo mockNetworkInfo;
  ListingItemRepository repository;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockRemoteDataSource = MockRemoteDataSource();
    repository = ListingItemRepository(
      remoteDataSource: mockRemoteDataSource,
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
      expect(result, equals(Right(listingItemList)));
    });

    test('''should return server failure when the call to remote data source 
    is unsuccessful''', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(mockRemoteDataSource.getAll()).thenThrow(ServerException());

      final result = await repository.getAll();

      verify(mockRemoteDataSource.getAll());
      expect(result, Left(ServerFailure()));
    });

    test('should return no internet failure when the device offline', () async {
      when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final result = await repository.getAll();

      verify(mockNetworkInfo.isConnected);
      expect(result, Left(NoInternetFailure()));
    });
  });
}

import 'package:basket_app/core/constants.dart';
import 'package:basket_app/core/exception.dart';
import 'package:basket_app/core/failure.dart';
import 'package:basket_app/core/network_info.dart';
import 'package:basket_app/datasource/listing_item_local_data_source.dart';
import 'package:basket_app/datasource/listing_item_remote_data_source.dart';
import 'package:basket_app/domain/listing_item.dart';
import 'package:basket_app/model/listing_item_model.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:meta/meta.dart';

@lazySingleton
class ListingItemRepository {
  final ListingItemRemoteDataSource remoteDataSource;
  final ListingItemLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ListingItemRepository({
    @required this.remoteDataSource,
    @required this.localDataSource,
    @required this.networkInfo,
  });

  Future<Either<Failure, List<ListingItem>>> getAll() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteItemList = await remoteDataSource.getAll();
        localDataSource.saveStoreItemList(remoteItemList);
        return Right(remoteItemList);
      } on ServerException catch (error) {
        return Left(ServerFailure(error.message));
      }
    } else {
      return Left(NoInternetFailure(NO_INTERNET_FAILURE_MESSAGE));
    }
  }

  Future<Either<Failure, Map<String, int>>> getBasket() async {
    try {
      final basket = await localDataSource.getBasket();
      return Right(basket);
    } on CacheException {
      return Left(CacheFailure(CACHE_FAILURE_MESSAGE));
    }
  }

  Future<void> addToBasket(ListingItem listingItem) async {
    ListingItemModel listingItemModel =
        ListingItemModel.fromDomain(listingItem);
    localDataSource.addToBasket(listingItemModel);
  }

  Future<void> saveStoreItemList(List<ListingItem> listingItemList) async {
    localDataSource.saveStoreItemList(listingItemList);
  }

  Future<List<ListingItem>> getStoreItemList() async {
    return localDataSource.getStoreItemList();
  }

  ListingItem getStoreItemById(String id) {
    return localDataSource.getStoreItemById(id);
  }

  Future<Either<Failure, String>> order(Map<String, int> basketItems) async {
    try {
      final order = await remoteDataSource.order(basketItems);
      return Right(order);
    } on ServerException catch (error) {
      return Left(ServerFailure(error.message));
    }
  }

  Future<void> clearKey(String key) async {
    return localDataSource.clearKey(key);
  }
}

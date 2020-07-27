import 'package:basket_app/core/exception.dart';
import 'package:basket_app/core/failure.dart';
import 'package:basket_app/core/network_info.dart';
import 'package:basket_app/datasource/listing_item_local_data_source.dart';
import 'package:basket_app/datasource/listing_item_remote_data_source.dart';
import 'package:basket_app/domain/listing_item.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

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
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }

  Future<Either<Failure, Map<String, int>>> getBasket() async {
    try {
      final basket = await localDataSource.getBasket();
      return Right(basket);
    } on CacheException {
      return Left(CacheFailure());
    }
  }
}

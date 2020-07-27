import 'package:basket_app/core/exception.dart';
import 'package:basket_app/core/failure.dart';
import 'package:basket_app/core/network_info.dart';
import 'package:basket_app/datasource/listing_item_remote_data_source.dart';
import 'package:basket_app/domain/listing_item.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class ListingItemRepository {
  final ListingItemRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

//  TODO: localDataSource yap, orada addToBasket itemlarini bir key ile
//        sharedpreferences'da tut

  ListingItemRepository({
    @required this.remoteDataSource,
    @required this.networkInfo,
  });

  Future<Either<Failure, List<ListingItem>>> getAll() async {
    if (await networkInfo.isConnected) {
      try {
        final remoteItem = await remoteDataSource.getAll();
        return Right(remoteItem);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NoInternetFailure());
    }
  }
}

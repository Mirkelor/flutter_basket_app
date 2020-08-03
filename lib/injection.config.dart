// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

import 'package:http/http.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/get_it_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/injectable_module.dart';
import 'presentation/bloc/listing_item_bloc.dart';
import 'datasource/listing_item_local_data_source.dart';
import 'datasource/listing_item_remote_data_source.dart';
import 'repository/listing_item_repository.dart';
import 'core/network_info.dart';

/// adds generated dependencies
/// to the provided [GetIt] instance

Future<void> $initGetIt(GetIt g, {String environment}) async {
  final gh = GetItHelper(g, environment);
  final injectableModule = _$InjectableModule();
  gh.lazySingleton<Client>(() => injectableModule.client);
  gh.lazySingleton<DataConnectionChecker>(
      () => injectableModule.dataConnectionChecker);
  gh.lazySingleton<ListingItemRemoteDataSource>(
      () => ListingItemRemoteDataSource(client: g<Client>()));
  gh.lazySingleton<NetworkInfo>(() => NetworkInfo(g<DataConnectionChecker>()));
  final sharedPreferences = await injectableModule.sharedPreferences;
  gh.lazySingleton<SharedPreferences>(() => sharedPreferences);
  gh.lazySingleton<ListingItemLocalDataSource>(() =>
      ListingItemLocalDataSource(sharedPreferences: g<SharedPreferences>()));
  gh.lazySingleton<ListingItemRepository>(() => ListingItemRepository(
        remoteDataSource: g<ListingItemRemoteDataSource>(),
        localDataSource: g<ListingItemLocalDataSource>(),
        networkInfo: g<NetworkInfo>(),
      ));
  gh.factory<ListingItemBloc>(
      () => ListingItemBloc(repository: g<ListingItemRepository>()));
}

class _$InjectableModule extends InjectableModule {}

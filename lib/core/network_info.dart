import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class NetworkInfo {
  final DataConnectionChecker connectionChecker;

  NetworkInfo(this.connectionChecker);

  Future<bool> get isConnected => connectionChecker.hasConnection;
}

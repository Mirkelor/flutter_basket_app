import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  ServerFailure(String message) : super(message);
}

class NoInternetFailure extends Failure {
  NoInternetFailure(String message) : super(message);
}

class CacheFailure extends Failure {
  CacheFailure(String message) : super(message);
}

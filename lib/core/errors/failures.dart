import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure([List<Object?> props = const []]);

  @override
  List<Object?> get props => [];
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class MediaFailure extends Failure {
  const MediaFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

class StorageFailure extends Failure {
  const StorageFailure(this.message);
  final String message;

  @override
  List<Object?> get props => [message];
}

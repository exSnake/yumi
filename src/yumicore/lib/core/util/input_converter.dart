import 'package:dartz/dartz.dart';

import '../error/failures.dart';

class InputConverter {
  Either<Failure, String> stringToUnsignedInteger(String str) {
    try {
      if (str.isEmpty) return Left(InvalidInputFailure());
      return Right(str);
    } on FormatException {
      throw const FormatException();
    }
  }
}

class InvalidInputFailure extends Failure {
  @override
  List<Object?> get props => [''];
}

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumicore/core/util/input_converter.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() async {
    inputConverter = InputConverter();
  });

  group('InputConverter', () {
    test(
      'should return an integer when the string represent ans unsigned integer',
      () async {
        // arrange
        const str = '123';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, const Right(123));
      },
    );

    test(
      'should return a failure when string is not an integer',
      () async {
        // arrange
        const str = 'abc';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return a failure when string is a negative integer',
      () async {
        // arrange
        const str = '-123';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}

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
      'should return a string when the string',
      () async {
        // arrange
        const str = '123';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, const Right('123'));
      },
    );

    test(
      'should return a failure when string is empty',
      () async {
        // arrange
        const str = '';
        // act
        final result = inputConverter.stringToUnsignedInteger(str);
        // assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:yumicore/core/error/failures.dart';
import 'package:yumicore/core/util/input_converter.dart';
import 'package:yumicore/features/conversation/domain/entities/conversation.dart';
import 'package:yumicore/features/conversation/domain/usecases/get_concrete_conversation.dart';
import 'package:yumicore/features/conversation/domain/usecases/get_random_conversation.dart';
import 'package:yumicore/features/conversation/presentation/bloc/conversation_bloc.dart';

import '../../domain/usecases/get_concrete_conversation_test.dart';

class MockGetConcreteConversation extends Mock
    implements GetConcreteConversation {}

class MockGetRandomConverastion extends Mock implements GetRandomConversation {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  late ConversationBloc bloc;
  late MockGetConcreteConversation mockGetConcreteConversation;
  late MockGetRandomConverastion mockGetRandomConverastion;
  late MockInputConverter mockInputConverter;
  late MockConversationRepository mockConversationRepository;

  setUp(() async {
    mockGetConcreteConversation = MockGetConcreteConversation();
    mockGetRandomConverastion = MockGetRandomConverastion();
    mockInputConverter = MockInputConverter();
    mockConversationRepository = MockConversationRepository();

    bloc = ConversationBloc(
        getConcreteConversation: mockGetConcreteConversation,
        getRandomConversation: mockGetRandomConverastion,
        inputConverter: mockInputConverter);
  });

  setUpAll(() {
    registerFallbackValue(const Params(1));
  });

  test('initial state should be Empty', () {
    expect(bloc.state, equals(Empty()));
  });

  group('GetConversationForConcreteString', () {
    const tString = '1';
    const tNumberParsed = 1;
    const tConversation = Conversation(number: 1, text: 'Test Text');

    void setUpInputConverterSuccess() =>
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(const Right(tNumberParsed));

    test(
      'should call the InputConverter to validate and conver the string to as unsigned integer',
      () async {
        // arrange
        setUpInputConverterSuccess();
        when(() => mockConversationRepository.getConcreteConversation(any()))
            .thenAnswer((_) async => const Right(tConversation));

        when(() => mockConversationRepository.getRandomConversation())
            .thenAnswer((_) async => const Right(tConversation));

        when(() => mockGetConcreteConversation.call(any())).thenAnswer(
            (_) async => mockConversationRepository
                .getConcreteConversation(tNumberParsed));
        // act
        bloc.add(const GetConversationForConcreteStringEvent(tString));
        await untilCalled(
            () => mockInputConverter.stringToUnsignedInteger(any()));
        // assert
        verify(() => mockInputConverter.stringToUnsignedInteger(tString));
      },
    );

    test(
      'should emit [Error] when the input is invalid',
      () async {
        // arrange
        when(() => mockInputConverter.stringToUnsignedInteger(any()))
            .thenReturn(Left(InvalidInputFailure()));
        // act
        bloc.add(const GetConversationForConcreteStringEvent(tString));
        // assert later
        final expected = [Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
        expectLater(bloc.stream, emitsInOrder(expected));
      },
    );

    test(
      'should get data from concrete use case',
      () async {
        // arrange
        setUpInputConverterSuccess();
        when(() => mockGetConcreteConversation(any()))
            .thenAnswer((_) async => const Right(tConversation));
        // act
        bloc.add(const GetConversationForConcreteStringEvent(tString));
        await untilCalled(() => mockGetConcreteConversation(any()));
        // assert
        verify(() => mockGetConcreteConversation(const Params(tNumberParsed)));
      },
    );

    test(
      'should emit [Loading, Loaded] when data is gotten successfully',
      () {
        // arrange
        setUpInputConverterSuccess();
        when(() => mockGetConcreteConversation(any()))
            .thenAnswer((_) async => const Right(tConversation));
        // act
        bloc.add(const GetConversationForConcreteStringEvent(tString));
        // assert later
        final expected = [
          Loading(),
          Loaded(conversation: tConversation),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
      },
    );

    test(
      'should emit [Loading, Error] when getting data dailss',
      () {
        // arrange
        setUpInputConverterSuccess();
        when(() => mockGetConcreteConversation(any()))
            .thenAnswer((_) async => Left(ServerFailure()));
        // act
        bloc.add(const GetConversationForConcreteStringEvent(tString));
        // assert later
        final expected = [
          Loading(),
          Error(message: SERVER_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
      },
    );

    test(
      'should emit [Loading, Error] with a proper message for the error when getting data fails',
      () {
        // arrange
        setUpInputConverterSuccess();
        when(() => mockGetConcreteConversation(any()))
            .thenAnswer((_) async => Left(CacheFailure()));
        // act
        bloc.add(const GetConversationForConcreteStringEvent(tString));
        // assert later
        final expected = [
          Loading(),
          Error(message: CACHE_FAILURE_MESSAGE),
        ];
        expectLater(bloc.stream, emitsInOrder(expected));
      },
    );
  });
}

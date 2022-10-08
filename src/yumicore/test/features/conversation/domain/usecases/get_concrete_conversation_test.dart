import 'package:dartz/dartz.dart';
import 'package:yumicore/features/conversation/domain/entities/conversation.dart';
import 'package:yumicore/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:yumicore/features/conversation/domain/usecases/get_concrete_conversation.dart';
import 'package:mocktail/mocktail.dart';

class MockConversationRepository extends Mock
    implements ConversationRepository {}

void main() {
  late GetConcreteConversation usecase;
  late MockConversationRepository mockConversationRepository;

  setUp(() {
    mockConversationRepository = MockConversationRepository();
    usecase = GetConcreteConversation(mockConversationRepository);
  });

  const tNumber = 1;
  const tConversation = Conversation(number: 1, text: 'test');

  test('should get conversation for the input from the repository', () async {
    // arrange
    when(() => mockConversationRepository.getConcreteConversation(any()))
        .thenAnswer((_) async => const Right(tConversation));
    // act
    final result = await usecase(const Params(number: tNumber));
    // assert
    expect(result, const Right(tConversation));
    verify(() => mockConversationRepository.getConcreteConversation(tNumber));
    verifyNoMoreInteractions(mockConversationRepository);
  });
}

import 'package:dartz/dartz.dart';
import 'package:yumicore/core/usecases/usecase.dart';
import 'package:yumicore/features/conversation/domain/entities/conversation.dart';
import 'package:yumicore/features/conversation/domain/repositories/conversation_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:yumicore/features/conversation/domain/usecases/get_random_conversation.dart';

class MockConversationRepository extends Mock
    implements ConversationRepository {}

void main() {
  late GetRandomConversation usecase;
  late MockConversationRepository mockConversationRepository;

  setUp(() {
    mockConversationRepository = MockConversationRepository();
    usecase = GetRandomConversation(mockConversationRepository);
  });

  const tConversation = Conversation(comment: '1', code: 'test');

  test('should get conversation from the repository', () async {
    // arrange
    when(() => mockConversationRepository.getRandomConversation())
        .thenAnswer((_) async => const Right(tConversation));
    // act
    final result = await usecase(NoParams());
    // assert
    expect(result, const Right(tConversation));
    verify(() => mockConversationRepository.getRandomConversation());
    verifyNoMoreInteractions(mockConversationRepository);
  });
}

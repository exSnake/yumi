import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  final String code;
  final String comment;

  const Conversation({required this.code, required this.comment});

  @override
  List<Object> get props => [code, comment];
}

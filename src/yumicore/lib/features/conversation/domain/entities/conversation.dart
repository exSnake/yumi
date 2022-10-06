import 'package:equatable/equatable.dart';

class Conversation extends Equatable {
  final String text;
  final int number;

  const Conversation({required this.text, required this.number});

  @override
  List<Object> get props => [text, number];
}

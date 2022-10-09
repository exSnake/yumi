import 'package:flutter/material.dart';
import 'package:yumicore/features/conversation/domain/entities/conversation.dart';

class ConversationDisplay extends StatelessWidget {
  final Conversation conversation;

  const ConversationDisplay({
    Key? key,
    required this.conversation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 2,
        child: Column(
          children: [
            Text(conversation.number.toString(),
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  child: Text(conversation.text,
                      style: const TextStyle(fontSize: 20),
                      textAlign: TextAlign.left),
                ),
              ),
            ),
          ],
        ));
  }
}

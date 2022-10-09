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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Text(conversation.comment,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
              ),
            ),
            Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Text(conversation.code,
                          style: const TextStyle(fontSize: 20),
                          textAlign: TextAlign.left),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text("Copia Codice"),
                  ),
                ),
              ],
            ),
          ],
        ));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/conversation_bloc.dart';

class ConversationControls extends StatefulWidget {
  const ConversationControls({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ConversationControlState();
}

class _ConversationControlState extends State<ConversationControls> {
  late String inputStr = "";
  var controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      //TextField
      TextField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: const InputDecoration(
            border: OutlineInputBorder(), hintText: 'Inserisci un commento'),
        onSubmitted: (_) {
          addConcrete();
        },
        onChanged: (value) {
          inputStr = value.toString();
        },
      ),
      const SizedBox(height: 10),
      Row(children: <Widget>[
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white)),
            onPressed: addConcrete,
            child: const Text('Cerca Funzione'),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: ElevatedButton(
            style: ButtonStyle(
                foregroundColor:
                    MaterialStateProperty.all<Color>(Colors.white)),
            onPressed: addRandom,
            child: const Text('Funzione Casuale'),
          ),
        ),
      ])
    ]);
  }

  void addConcrete() {
    controller.clear();
    BlocProvider.of<ConversationBloc>(context)
        .add(GetConversationForConcreteStringEvent(inputStr));
  }

  void addRandom() {
    BlocProvider.of<ConversationBloc>(context)
        .add(GetConversationForRandomStringEvent());
  }
}

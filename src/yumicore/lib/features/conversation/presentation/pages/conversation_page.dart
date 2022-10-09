import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yumicore/injection_container.dart';
import 'package:yumicore/features/conversation/presentation/bloc/conversation_bloc.dart';

import '../widgets/conversation_display.dart';
import '../widgets/loading_widget.dart';
import '../widgets/message_display.dart';

class ConversationPage extends StatelessWidget {
  const ConversationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yumi'),
      ),
      body: buildBody(context),
    );
  }

  BlocProvider<ConversationBloc> buildBody(BuildContext context) {
    return BlocProvider<ConversationBloc>(
        create: (_) => sl<ConversationBloc>(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(40.0),
            child: Column(children: <Widget>[
              const SizedBox(height: 10),
              BlocBuilder<ConversationBloc, ConversationState>(
                builder: (context, state) {
                  if (state is Empty) {
                    return const MessageDisplay(
                      message: 'Start Searching!!!',
                    );
                  } else if (state is Loading) {
                    return const LoadingWidget();
                  } else if (state is Loaded) {
                    return ConversationDisplay(
                        conversation: state.conversation);
                  } else if (state is Error) {
                    return MessageDisplay(
                      message: state.message,
                    );
                  }
                  return Container(
                      height: MediaQuery.of(context).size.height / 3,
                      child: Placeholder());
                },
              ),
              const SizedBox(height: 20),
              Column(children: <Widget>[
                //TextField
                const Placeholder(fallbackHeight: 40),
                const SizedBox(height: 10),
                Row(children: const <Widget>[
                  Expanded(
                      child:
                          Placeholder(fallbackHeight: 30, fallbackWidth: 100)),
                  SizedBox(width: 20),
                  Expanded(
                      child:
                          Placeholder(fallbackHeight: 30, fallbackWidth: 100))
                ])
              ]),
            ]),
          ),
        ));
  }
}

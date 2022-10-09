import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../injection_container.dart';
import '../../domain/entities/conversation.dart';
import '../bloc/conversation_bloc.dart';
import '../widgets/widgets.dart';

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
                        message: 'Benvenuto in Yumi',
                        subtitle:
                            'Genera il tuo blocco di codice o trovane uno casualmente');
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
              const ConversationControls(),
            ]),
          ),
        ));
  }
}

bool findIfNumberIsPrime(number) {
  for (int i = 2; i < number; i++) {
    if (number % i == 0) {
      return false;
    }
  }
  return true;
}

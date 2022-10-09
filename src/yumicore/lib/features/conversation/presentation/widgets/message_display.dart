import 'package:flutter/material.dart';

class MessageDisplay extends StatelessWidget {
  final String message;
  final String subtitle;

  const MessageDisplay({
    Key? key,
    required this.message,
    this.subtitle = "",
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height / 3,
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(message,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center),
                Text(subtitle,
                    style: const TextStyle(fontSize: 18),
                    textAlign: TextAlign.center)
              ],
            ),
          ),
        ));
  }
}

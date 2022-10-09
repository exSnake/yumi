import 'package:flutter/material.dart';
import 'features/conversation/presentation/pages/conversation_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

final ThemeData theme = ThemeData();

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Yumi',
      theme: theme.copyWith(
        colorScheme: theme.colorScheme.copyWith(
            primary: Colors.deepOrange.shade400, secondary: Colors.deepOrange),
      ),
      home: ConversationPage(),
    );
  }
}

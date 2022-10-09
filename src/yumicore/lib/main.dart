import 'package:flutter/material.dart';
import 'features/conversation/presentation/pages/conversation_page.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yumi',
      theme: ThemeData(
        primarySwatch: Colors.pink,
        appBarTheme: AppBarTheme(backgroundColor: Colors.deepPurple.shade700),
      ),
      home: ConversationPage(),
    );
  }
}

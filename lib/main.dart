import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_screen_clone/chatScreen.dart';
import 'package:whatsapp_screen_clone/provider/chatProvider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => ChatProvider()),
        ],
        child:
            MaterialApp(debugShowCheckedModeBanner: false, home: Chatscreen()));
  }
}

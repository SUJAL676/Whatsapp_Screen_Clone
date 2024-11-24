import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  List chats = [];

  changeChats({required List list}) {
    chats = list;
    notifyListeners();
  }

  clearchats() {
    chats.clear();
  }
}

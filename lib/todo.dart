import 'package:flutter/material.dart';

class Todo {
  Todo(this.id, this.title, this.check, this.focusNode);
  int id;
  String title;
  bool check;
  FocusNode focusNode;
}

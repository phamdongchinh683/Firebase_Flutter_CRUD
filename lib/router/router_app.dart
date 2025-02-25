import 'package:flutter/material.dart';
import 'package:flutter_crud_note/pages/class_page.dart';
import 'package:flutter_crud_note/pages/note_page.dart';
import 'package:flutter_crud_note/pages/student_page.dart';

class RouterApp {
  static const String landingPage = '/index';
  static const String noteRouter = 'notes';
  static const String studentRoute = '/login';
  static const String classRoute = '/class';

  static Map<String, WidgetBuilder> routes = {
    noteRouter: (context) => const NotePage(),
    studentRoute: (context) => const StudentPage(),
    classRoute: (context) => const ClassPage(),
  };
}

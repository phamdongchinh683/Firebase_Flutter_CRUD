import 'package:flutter/material.dart';
import 'package:flutter_crud_note/pages/class_page.dart';
import 'package:flutter_crud_note/pages/note_page.dart';
import 'package:flutter_crud_note/pages/school_page.dart';
import 'package:flutter_crud_note/pages/student_page.dart';
import 'package:flutter_crud_note/pages/teacher_page.dart';

void main() => runApp(const NavigationBarApp());

class NavigationBarApp extends StatelessWidget {
  const NavigationBarApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: const NavigationExample(),
    );
  }
}

class NavigationExample extends StatefulWidget {
  const NavigationExample({super.key});

  @override
  State<NavigationExample> createState() => _NavigationExampleState();
}

class _NavigationExampleState extends State<NavigationExample> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: (int index) {
          setState(() {
            currentPageIndex = index;
          });
        },
        indicatorColor: Colors.amber,
        selectedIndex: currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('2'),
              child: Icon(Icons.person),
            ),
            label: 'Student',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('3'),
              child: Icon(Icons.class_),
            ),
            label: 'Class',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('4'),
              child: Icon(Icons.class_),
            ),
            label: 'Teacher',
          ),
          NavigationDestination(
            icon: Badge(
              label: Text('5'),
              child: Icon(Icons.class_),
            ),
            label: 'School',
          ),
        ],
      ),
      body: <Widget>[
        NotePage(),
        StudentPage(),
        ClassPage(),
        TeacherPage(),
        SchoolPage()
      ][currentPageIndex],
    );
  }
}

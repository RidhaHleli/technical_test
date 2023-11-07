import 'package:flutter/material.dart';
import 'package:note_technical_test/providers/note_provider.dart';
import 'package:note_technical_test/providers/sorting_filtring_provider.dart';
import 'package:note_technical_test/screens/add_edit_note_screen.dart';
import 'package:note_technical_test/screens/notes_list_screens.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyNotesApp());
}

class MyNotesApp extends StatelessWidget {
  const MyNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NotesProvider()),
        ChangeNotifierProvider(create: (context) => SortingFilteringProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'My Notes App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const NotesListScreen(),
          '/addEditNote': (context) => const AddEditNoteScreen(),
        },
      ),
    );
  }
}

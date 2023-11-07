import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../providers/note_provider.dart';
import '../widgets/note_item.dart';

class NoteSearchDelegate extends SearchDelegate<Note> {
  final NotesProvider notesProvider;

  NoteSearchDelegate(this.notesProvider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    final defaultNote = Note(
      title: 'Default Title',
      description: 'Default Description',
      dueDate: DateTime.now(),
      creationDate: DateTime.now(),
    );

    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, defaultNote);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final searchResults = _getSearchResults(query);
    if (searchResults.isEmpty) {
      // If no results, you can return a message or an empty list.
      return const Center(child: Text('No results found.'));
    } else {
      return _buildSearchResults(searchResults);
    }
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final searchResults = _getSearchResults(query);
    if (searchResults.isEmpty) {
      // If no results, you can return a message or an empty list.
      return const Center(child: Text('No results found.'));
    } else {
      return _buildSearchResults(searchResults);
    }
  }

  List<Note> _getSearchResults(String query) {
    if (query.isEmpty) {
      return [];
    }
    return notesProvider.notes
        .where((note) =>
            note.title.toLowerCase().contains(query.toLowerCase()) ||
            note.description.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Widget _buildSearchResults(List<Note> results) {
    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        final note = results[index];
        return NoteItem(
          note: note,
          onDelete: () => _deleteNote(context, note),
        );
      },
    );
  }

  void _deleteNote(BuildContext context, Note note) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    notesProvider.deleteNote(
        note); // Assuming you have a deleteNote method that uses the note's id.
  }
}

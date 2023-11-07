import 'package:flutter/material.dart';
import 'package:note_technical_test/screens/search_delegate.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../providers/note_provider.dart';
import '../providers/sorting_filtring_provider.dart';
import '../widgets/note_item.dart';

class NotesListScreen extends StatelessWidget {
  const NotesListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    final sortingFilteringProvider =
        Provider.of<SortingFilteringProvider>(context);

    final filteredNotes =
        _filterAndSortNotes(notesProvider.notes, sortingFilteringProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: () {
              _showSortOptions(context, sortingFilteringProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              _showFilterOptions(context, sortingFilteringProvider);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchBar(context, notesProvider);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: filteredNotes.length,
        itemBuilder: (context, index) {
          final note = filteredNotes[index];
          return NoteItem(
            note: note,
            onDelete: () => _deleteNote(context, note),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/addEditNote');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  List<Note> _filterAndSortNotes(
      List<Note> notes, SortingFilteringProvider sortingFilteringProvider) {
    final now = DateTime.now();
    final filteredNotes = notes.where((note) {
      final isOverdue = note.dueDate.isBefore(now);
      final isDueToday = note.dueDate.year == now.year &&
          note.dueDate.month == now.month &&
          note.dueDate.day == now.day;
      return (!sortingFilteringProvider.showOverdue || isOverdue) &&
          (!sortingFilteringProvider.showDueToday || isDueToday);
    }).toList();

    if (sortingFilteringProvider.sortByDate) {
      filteredNotes.sort((a, b) => a.dueDate.compareTo(b.dueDate));
    } else {
      filteredNotes.sort((a, b) => a.title.compareTo(b.title));
    }

    return filteredNotes;
  }

  void _deleteNote(BuildContext context, Note note) {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    notesProvider.deleteNote(
        note); // Assuming you have a deleteNote method that uses the note's id.
  }

  void _showSortOptions(
      BuildContext context, SortingFilteringProvider sortingFilteringProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Sort Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Sort by Date'),
                leading: Radio(
                  value: true,
                  groupValue: sortingFilteringProvider.sortByDate,
                  onChanged: (value) {
                    sortingFilteringProvider.sortByDate = value!;
                    Navigator.of(context).pop();
                  },
                ),
              ),
              ListTile(
                title: const Text('Sort by Title'),
                leading: Radio(
                  value: false,
                  groupValue: sortingFilteringProvider.sortByDate,
                  onChanged: (value) {
                    sortingFilteringProvider.sortByDate = value!;
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showFilterOptions(
      BuildContext context, SortingFilteringProvider sortingFilteringProvider) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Options'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CheckboxListTile(
                title: const Text('Show Overdue'),
                value: sortingFilteringProvider.showOverdue,
                onChanged: (value) {
                  sortingFilteringProvider.showOverdue = value!;
                },
              ),
              CheckboxListTile(
                title: const Text('Show Due Today'),
                value: sortingFilteringProvider.showDueToday,
                onChanged: (value) {
                  sortingFilteringProvider.showDueToday = value!;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Done'),
            ),
          ],
        );
      },
    );
  }

  void _showSearchBar(BuildContext context, NotesProvider notesProvider) {
    showSearch(
      context: context,
      delegate: NoteSearchDelegate(notesProvider),
    );
  }
}

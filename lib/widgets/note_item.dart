import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/note_model.dart';
import '../screens/add_edit_note_screen.dart';

class NoteItem extends StatelessWidget {
  final Note note;
  final Function onDelete;

  const NoteItem({super.key, required this.note, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      elevation: 5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (note.imagePath != null)
              ? Container(
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10)),
                  ),
                  child: ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(10)),
                    child: Image.file(
                      File(note.imagePath!),
                      width: double.infinity,
                      height: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: ColorFiltered(
                      colorFilter: ColorFilter.mode(
                        Colors.grey.shade50, // Apply gray filter
                        BlendMode.saturation,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
          ListTile(
            title: Text(
              note.title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            subtitle: Text(
              'Due: ${DateFormat.yMd().format(note.dueDate)}',
              style: TextStyle(
                color: note.dueDate.isBefore(DateTime.now())
                    ? Colors.red
                    : Colors.black,
                fontSize: 16,
              ),
            ),
            contentPadding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEditNoteScreen(note: note),
                ),
              );
            },
            onLongPress: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Delete Note'),
                    content: const Text(
                        'Are you sure you want to delete this note?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          onDelete();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Yes',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('No'),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

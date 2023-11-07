import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/note_model.dart';
import '../providers/note_provider.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;

  const AddEditNoteScreen({super.key, this.note});

  @override
  _AddEditNoteScreenState createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  DateTime _dueDate = DateTime.now();
  String _imagePath = '';
  Note? _note;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final Note? note = ModalRoute.of(context)?.settings.arguments as Note?;
    if (note != null) {
      _note = note;
      _titleController.text = _note!.title;
      _descriptionController.text = _note!.description;
      _dueDate = _note!.dueDate;
      _imagePath = _note!.imagePath!;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveNote() {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);

    if (widget.note != null) {
      final updatedNote = Note(
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        creationDate: widget.note!.creationDate,
        imagePath: _imagePath,
      );
      notesProvider.editNote(
          notesProvider.notes.indexOf(widget.note!), updatedNote);
    } else {
      final newNote = Note(
        title: _titleController.text,
        description: _descriptionController.text,
        dueDate: _dueDate,
        creationDate: DateTime.now(),
        imagePath: _imagePath,
      );
      notesProvider.addNote(newNote);
    }
    Navigator.pop(context);
  }

  Future<void> _selectDueDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != _dueDate) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add/Edit Note'),
        backgroundColor: Colors.blue, // Set app bar color
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title field
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // Description field
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16.0),

              // Due date picker
              ListTile(
                title: Text(
                  'Due Date: ${DateFormat('yyyy-MM-dd').format(_dueDate)}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
                trailing: const Icon(Icons.date_range),
                onTap: () => _selectDueDate(),
              ),
              const SizedBox(height: 16.0),

              // Image picker with icon and title
              InkWell(
                onTap: () => _pickImage(context),
                child: const Row(
                  children: [
                    Icon(Icons.photo, color: Colors.blue), // Set icon color
                    SizedBox(width: 8.0),
                    Text(
                      'Pick Image',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue, // Set text color
                      ),
                    ),
                  ],
                  // Add onPressed handler here to pick an image.
                ),
              ),
              const SizedBox(height: 16.0),

              // Display the picked image if available
              if (_imagePath.isNotEmpty)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: FileImage(File(_imagePath)),
                      fit: BoxFit.cover,
                    ),
                    border:
                        Border.all(color: Colors.blue, width: 2), // Add border
                  ),
                ),
              const SizedBox(height: 16.0),

              // Save button
              ElevatedButton(
                onPressed: _saveNote,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                      Colors.blue), // Set button color
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imagePath = pickedFile.path;
      setState(() {
        _imagePath = imagePath;
      });
    }
  }
}

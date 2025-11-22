import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_homework/viewmodels/notes/note_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../models/note.dart';

class NoteScreen extends StatelessWidget {
  NoteScreen({super.key});

  TextEditingController textEditingController = TextEditingController();
  String? Imagepath;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            // Notes list section
            Expanded(
              child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: context.read<NotesVM>().loadallnotes(),
                builder: (ctx, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text('No notes found'));
                  }

                  final QuerySnapshot<Map<String, dynamic>> firebaseNotes = snapshot.data!;
                  final List<QueryDocumentSnapshot<Map<String, dynamic>>> notes = firebaseNotes.docs;

                  return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (ctx, index) {
                      final QueryDocumentSnapshot<Map<String, dynamic>> note = notes[index];
                      return ListTile(
                        title: Text("${note.data()["note"]}"),
                      );
                    },
                  );
                },
              ),
            ),

            // Input section
            Container(
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Flexible(
                    flex: 4,
                    child: TextFormField(
                      controller: textEditingController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter your note',
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  FloatingActionButton(
                    onPressed: () async {
                      if (textEditingController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Please enter a note")),
                        );
                        return;
                      }

                      Note n = Note(
                          note: textEditingController.text,
                          id: "${Random().nextInt(1000)}"
                      );
                      bool isAdded = await context.read<NotesVM>().addNewNotes(
                        n, image: Imagepath != null ? File(Imagepath!) : null,
                      );

                      if (isAdded) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Success")),
                        );
                        textEditingController.clear();
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Failed to add note")),
                        );
                      }
                    },
                    child: Icon(Icons.send),
                    mini: true,
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    onPressed: () async {
                      ImagePicker picker = ImagePicker();
                      XFile? image = await picker.pickImage(source: ImageSource.camera);
                      if (image != null) {
                        Imagepath = image.path;
                        context.read<NotesVM>().addFile(File(image.path));
                      }
                    },
                    icon: Icon(Icons.camera_alt),
                    iconSize: 28,
                  )
                ],
              ),
            )
          ],
        )
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreServices {
  // creating a collection named 'notes' under which
  // all the new notes will be stored.
  final CollectionReference? notes =
      FirebaseFirestore.instance.collection('notes');

  // adding a new note logic within our 'notes' collection
  // by creating 2 fields named
  // 'note' (note we enter) and 'timestamp'(time of entry)

  Future<void> addNote(String note) {
    return notes!.add(
      {'note': note, 'timestamp': Timestamp.now()},
    );
  }

  // reading data within the 'notes' collection
  // we have made earlier in the form of snapshots

  Stream<QuerySnapshot> showNotes() {
    final notesStream =
        notes!.orderBy('timestamp', descending: true).snapshots();

    return notesStream;
  }

  // update the data by accessing the particular
  // docId of the note which we want to update.

  Future<void> updateNotes(String docId, String newNote, Timestamp time) {
    return notes!.doc(docId).update({'note': newNote, 'timestamp': time});
  }

  // delete the data by accessing the particular
  // which we want to delete.

  Future<void> deleteNote(String docId) {
    return notes!.doc(docId).delete();
  }
}

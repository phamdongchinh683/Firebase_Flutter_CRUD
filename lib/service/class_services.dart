import 'package:cloud_firestore/cloud_firestore.dart';

class ClassServices {
  final CollectionReference classes =
      FirebaseFirestore.instance.collection('classes');

  Future<void> addClass(String classCode, int people) {
    return classes.add({
      'class_code': classCode,
      'people': people,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> showClasses() {
    return classes.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updateClass(
      String docId, String classCode, int people, Timestamp time) {
    return classes.doc(docId).update({
      'class_code': classCode,
      'people': people,
      'timestamp': time,
    });
  }

  Future<void> deleteClass(String docId) {
    return classes.doc(docId).delete();
  }
}

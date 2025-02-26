import 'package:cloud_firestore/cloud_firestore.dart';

class TeacherServices {
  final CollectionReference teachers =
      FirebaseFirestore.instance.collection('teachers');

  Future<void> addTeacher(
      String email, String name, String schoolId, String subject) {
    return teachers.add({
      'email': email,
      'name': name,
      'school_id': schoolId,
      'subject': subject,
      'timestamps': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> showTeachers() {
    return teachers.orderBy('timestamps', descending: true).snapshots();
  }

  Future<void> updateTeacher(String docId, String email, String name,
      String schoolId, String subject) {
    return teachers.doc(docId).update({
      'email': email,
      'name': name,
      'school_id': schoolId,
      'subject': subject,
      'timestamps': Timestamp.now(),
    });
  }

  Future<void> deleteTeacher(String docId) {
    return teachers.doc(docId).delete();
  }
}

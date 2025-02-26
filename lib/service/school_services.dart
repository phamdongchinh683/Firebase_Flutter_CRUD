import 'package:cloud_firestore/cloud_firestore.dart';

class SchoolServices {
  final CollectionReference schools =
      FirebaseFirestore.instance.collection('Schools');

  Future<void> addSchool(String address, String name, String phone) {
    return schools.add({
      'address': address,
      'name': name,
      'phone': phone,
      'timestamp': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> showSchools() {
    return schools.orderBy('timestamp', descending: true).snapshots();
  }

  Future<void> updateSchool(
      String docId, String address, String name, String phone) {
    return schools.doc(docId).update({
      'address': address,
      'name': name,
      'phone': phone,
      'timestamp': Timestamp.now(),
    });
  }

  Future<void> deleteSchool(String docId) {
    return schools.doc(docId).delete();
  }
}

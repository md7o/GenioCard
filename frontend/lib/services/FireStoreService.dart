// import 'package:cloud_firestore/cloud_firestore.dart';

// class FirestoreService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Future<List<String>> fetchQuestions() async {
//     final snapshot = await _firestore.collection("user_questions").get();
//     return snapshot.docs.map((doc) => (doc.data() as Map<String, dynamic>)["questions"] as List<String>).expand((q) => q).toList();
//   }
// }

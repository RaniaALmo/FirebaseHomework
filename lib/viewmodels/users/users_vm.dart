import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/app_user.dart';

class UserVM
{
  List<AppUser> users =[];
  FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List<AppUser>> loadUserFromFirebase() async
  {
    QuerySnapshot<Map<String,dynamic>> firebaseUser = await _db.collection("users").get();
    List<QueryDocumentSnapshot<Map<String,dynamic>>> userDocument = firebaseUser.docs;
    users = userDocument.map((item) => AppUser.fromJSON(item.data())).toList();
    return users;
  }

}
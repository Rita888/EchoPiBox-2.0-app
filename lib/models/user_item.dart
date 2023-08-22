
import 'package:cloud_firestore/cloud_firestore.dart';

class UserItem {
  String firstName="";
  String lastName="";
  String userId="";
  String email="";

  UserItem();

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["first_name"] = firstName;
    map["last_name"] = lastName;
    map["user_id"] = userId;
    map["email"] = email;
    return map;
  }

  UserItem.fromMap(Map snapshot) {
    firstName = snapshot['first_name'] as String;
    lastName = snapshot['last_name'] as String;
    userId = snapshot['user_id'] as String;
    email = snapshot['email'] as String;
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';

class RecordItem {
  String species="";
  String individuals="";
  String placeLatitude="";
  String placeLongitude="";
  String placeAddress="";
  String comments="";
  Timestamp? timeStamp;

  RecordItem();

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = <String, dynamic>{};
    map["species"] = species;
    map["individuals"] = individuals;
    map["place_latitude"] = placeLatitude;
    map["place_longitude"] = placeLongitude;
    map["place_address"] = placeAddress;
    map["comments"] = comments;
    map["timestamp"] = FieldValue.serverTimestamp();
    return map;
  }

  RecordItem.fromMap(Map snapshot) {
    species = snapshot['species'] as String;
    individuals = snapshot['individuals'] as String;
    placeLatitude = snapshot['place_latitude'] as String;
    placeLongitude = snapshot['place_longitude'] as String;
    placeAddress = snapshot['place_address'] as String;
    comments = snapshot['comments'] as String;
    if(snapshot['timestamp']!=null){
      timeStamp = snapshot['timestamp'] as Timestamp;
    }
  }
}

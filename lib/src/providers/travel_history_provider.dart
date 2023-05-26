import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farefinder/src/models/travel_history.dart';


class TravelHistoryProvider {
  late CollectionReference _ref;

  TravelHistoryProvider() {
    _ref = FirebaseFirestore.instance.collection('TravelHistory');
  }

  Future<String> create(TravelHistory travelHistory) async {
   String errorMessage;

  try {
    String id = _ref.doc().id;
    travelHistory.id = id;

    await _ref.doc(travelHistory.id).set(travelHistory.toJson());//almacena info
    return id;
  } catch (error) {
    errorMessage = error.toString();
  }

  if (errorMessage != null) {
    return Future.error(errorMessage);
  }

  throw Exception('create method completed without returning an ID');
}


  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<TravelHistory?> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
    if (document.exists) {
      TravelHistory client = TravelHistory.fromJson(data!);
      return client;
    }

    return null;
  }

  Future<void> delete(String id) {
    return _ref.doc(id).delete();
  }



  Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }
}

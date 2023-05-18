import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farefinder/src/models/travel_info.dart';

class TravelInfoProvider {
  late CollectionReference _ref;

  TravelInfoProvider() {
    _ref = FirebaseFirestore.instance.collection('TravelInfo');
  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

   Future<TravelInfo?> getById(String id) async {
      DocumentSnapshot document = await _ref.doc(id).get();
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (document.exists){
       TravelInfo travelInfo = TravelInfo.fromJson(data!);
       return travelInfo;
      }
        return null;
    }

 Future<void> create(TravelInfo travelInfo) async {
    late String errorMessage;

    try {
      return _ref.doc(travelInfo.id).set(travelInfo.toJson());
    } catch (error) {
      errorMessage = error.toString();
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

   Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }

}

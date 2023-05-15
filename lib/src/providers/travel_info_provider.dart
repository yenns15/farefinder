import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farefinder/src/models/travel_info.dart';

class TravelInfoProvider {
  late CollectionReference _ref;

  TravelInfoProvider() {
    _ref = FirebaseFirestore.instance.collection('TravelInfo');
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

}
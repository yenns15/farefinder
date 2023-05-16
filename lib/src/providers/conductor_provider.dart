import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farefinder/src/models/conductor.dart';

class ConductorProvider {
  late CollectionReference _ref;

  ConductorProvider() {
    _ref = FirebaseFirestore.instance.collection('Drivers');
  }

  Future<void> create(Conductor conductor) async {
    late String errorMessage;

    try {
      return _ref.doc(conductor.id).set(conductor.toJson());
    } catch (error) {
      errorMessage = error.toString();
    }

    if (errorMessage != null) {
      return Future.error(errorMessage);
    }
  }

  Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

  Future<Conductor?> getById(String id) async {
    DocumentSnapshot document = await _ref.doc(id).get();
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
    if (document.exists) {
      Conductor conductor = Conductor.fromJson(data!);
      return conductor;
    }
    return null;
  }
   Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }
}

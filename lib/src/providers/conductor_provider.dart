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
  }


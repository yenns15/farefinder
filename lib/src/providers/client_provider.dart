import 'package:farefinder/src/models/client.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ClientProvider {
  
  late CollectionReference _ref;

  ClientProvider() {
    _ref = FirebaseFirestore.instance.collection('Clients');
  }

    Future<void> create(Client client) async {
      late String errorMessage;

      try {
        return _ref.doc(client.id).set(client.toJson());
      } catch (error) {
        errorMessage = error.toString();
      }

      if (errorMessage != null) {
        return Future.error(errorMessage);
      }
    }
  }


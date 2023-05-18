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

    Stream<DocumentSnapshot> getByIdStream(String id) {
    return _ref.doc(id).snapshots(includeMetadataChanges: true);
  }

    Future<Client?> getById(String id) async {
      DocumentSnapshot document = await _ref.doc(id).get();
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
      if (document.exists){
       Client client = Client.fromJson(data!);
       return client;
      }
        return null;
    }
    Future<void> update(Map<String, dynamic> data, String id) {
    return _ref.doc(id).update(data);
  }
  
  }


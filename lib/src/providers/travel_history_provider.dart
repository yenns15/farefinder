import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farefinder/src/models/travel_history.dart';
import 'package:farefinder/src/providers/auth_provider.dart';


class TravelHistoryProvider {
  static late AuthProvider _authProvider;
  static late CollectionReference _ref;

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
    return Future.error(errorMessage);
}

/*
  Future<List<TravelHistory>> getByIdCliente(String idCliente) async {
    QuerySnapshot querySnapshot = await _ref
        .where('idCliente', isEqualTo: idCliente)
        .orderBy('timestamp', descending: false)
        .get();

    List<Map<String, dynamic>> allData = List<Map<String, dynamic>>.from(
        querySnapshot.docs.map((doc) => doc.data()).toList());
    List<Map<String, dynamic>> allDataCopy =
        List<Map<String, dynamic>>.from(allData); // Crear una copia de allData

    List<TravelHistory> travelHistoryList = [];

    for (Map<String, dynamic> data in allDataCopy) {
      travelHistoryList.add(TravelHistory.fromJson(data));
    }

    return travelHistoryList;
  }
*/
/*
Future<List<TravelHistory>> getByIdCliente(String idCliente) async {
  QuerySnapshot querySnapshot = await _ref
      .where('idCliente', isEqualTo: idCliente)
      .orderBy('timestamp', descending: false)
      .get();
      
   List<TravelHistory> travelHistoryList = [];

  List<Map<String, dynamic>> allData = List<Map<String, dynamic>>.from(querySnapshot.docs.map((doc) => doc.data()).toList());

  

  List<Map<String, dynamic>> allDataCopy = List<Map<String, dynamic>>.from(allData);

  for (Map<String, dynamic> data in allDataCopy) {
    travelHistoryList.add(TravelHistory.fromJson(data));
  }

  return travelHistoryList;
}
*/

/*Future<List<TravelHistory>> getByIdCliente(String idCliente) async {
  QuerySnapshot querySnapshot = await _ref
      .where('idCliente', isEqualTo: idCliente)
      .orderBy('timestamp', descending: true)
      .get();

  List<TravelHistory> travelHistoryList = querySnapshot.docs
      .map((doc) => TravelHistory.fromJson(doc.data() as Map<String, dynamic>))
      .toList();

  return travelHistoryList;
}*/


static Stream<QuerySnapshot> consulta(String idCliente) {
    _authProvider =  AuthProvider();
    Query querySnapshot =  _ref.where('idCliente',isEqualTo: _authProvider.getUser()!.uid).orderBy('timestamp',descending: true);
       

      return querySnapshot.snapshots();

}


Future<List<TravelHistory>> getByIdCliente(String idCliente) async {
    QuerySnapshot querySnapshot = await _ref
        .where('idCliente', isEqualTo: idCliente)
        .orderBy('timestamp', descending: true)
        .get();
    List<Map<String, dynamic>> allData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

        print(allData);
        
    List<TravelHistory> travelHistoryList = [];
    List<Map<String, dynamic>> allDataCopy = List.from(allData); // Crear una copia de la lista
    
    print(allDataCopy[0]);// Imprimir el contenido de la lista allDataCopy
    
    for ( Map<String,dynamic>data in allDataCopy) {
      travelHistoryList.add(TravelHistory.fromJson(json.encode(data) as Map<String, dynamic>));
      print(data);
    }

    return travelHistoryList;
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

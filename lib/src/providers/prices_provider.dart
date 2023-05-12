import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:farefinder/src/models/prices.dart';

class PricesProvider {
  CollectionReference? _ref;

  PricesProvider() {
    _ref = FirebaseFirestore.instance.collection("Prices ");
  }

  Future<Prices> getAll() async {
    DocumentSnapshot document = await _ref!.doc('info').get();
    if (!document.exists) {
      throw Exception('Document does not exist in Firestore.');
    }
    Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;
    if (data == null) {
      throw Exception('Failed to get data from Firestore.');
    }

    Prices prices = Prices.fromJson(data);
    return prices;
  }
}

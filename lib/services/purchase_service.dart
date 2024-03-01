import 'package:cloud_firestore/cloud_firestore.dart';

import '../main.dart';
import '../model/purchase_model.dart';
import 'base_service.dart';

class PurchaseService extends BaseService {
  PurchaseService() {
    ref = db.collection('purchases');
  }

  Future<void> addPurchase({
    int? goodsNo,
    int? cartonCount,
    int? perCartonCount,
    int? totalCount,
    int? price,
    int? billNo,
    String? name,
    String? note,
    DateTime? date,
  }) async {
    try {
      await ref!.add({
        "goodsNo": goodsNo,
        "cartonCount": cartonCount,
        "perCartonCount": perCartonCount,
        "totalCount": totalCount,
        "price": price,
        "billNo": billNo,
        "name": name,
        "note": note,
        "date": date,
      });
    } catch (e) {
      print('Error adding purchase: $e');
    }
  }

  Future<void> updatePurchase(String purchaseId, PurchaseModel updatedPurchase) async {
    try {
      await ref!.doc(purchaseId).update(updatedPurchase.toJson());
    } catch (e) {
      print('Error updating purchase: $e');
    }
  }

  Future<void> deletePurchase(String purchaseId) async {
    try {
      await ref!.doc(purchaseId).delete();
    } catch (e) {
      print('Error deleting purchase: $e');
    }
  }

  Future<List<PurchaseModel>> getAllPurchases() async {
    try {
      QuerySnapshot<Object?> querySnapshot = await ref!.get();

      return querySnapshot.docs.map((doc) => PurchaseModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting all purchases: $e');
      return [];
    }
  }

  Future<List<PurchaseModel>> getPurchaseByName(String purchaseName) async {
    try {
      QuerySnapshot<Object?> querySnapshot = await ref!.where("name", isEqualTo: purchaseName).get();

      return querySnapshot.docs.map((doc) => PurchaseModel.fromJson(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      print('Error getting purchases by name: $e');
      return [];
    }
  }
}

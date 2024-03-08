import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/goods_model.dart';
import '../utils/colors.dart';

class GoodsController extends GetxController {
  TextEditingController goodsNo = TextEditingController();
  TextEditingController salePrice = TextEditingController();
  TextEditingController purchasePrice = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController cartonCount = TextEditingController();
  TextEditingController perCartonCount = TextEditingController();
  TextEditingController pieceCount = TextEditingController();
  bool lineItem = true;
  bool isActive = true;

  FirebaseFirestore db = FirebaseFirestore.instance;
  var goodsList = RxList<GoodsModel>();

  @override
  void onInit() async {
    await getGoods();
    super.onInit();
  }

  void addGoods() async {
    try {
      var goods = GoodsModel(
        goodsNo: int.tryParse(goodsNo.text) ?? 0,
        salePrice: int.tryParse(salePrice.text) ?? 0,
        purchasePrice: int.tryParse(purchasePrice.text) ?? 0,
        name: name.text,
        cartonCount: int.tryParse(cartonCount.text) ?? 0,
        perCartonCount: int.tryParse(perCartonCount.text) ?? 0,
        pieceCount: int.tryParse(pieceCount.text) ?? 0,
        lineItem: lineItem,
        isActive: isActive,
      );

      var documentReference = await db.collection("goods").add(goods.toJson());
      var saleId = documentReference.id;

      await db.collection("goods").doc(saleId).update({'id': saleId});

      getGoods();

      Get.snackbar('Success', 'Goods added successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: primaryColor);

      goodsNo.clear();
      salePrice.clear();
      purchasePrice.clear();
      name.clear();
      cartonCount.clear();
      perCartonCount.clear();
      pieceCount.clear();
      lineItem = false;
      isActive = true;
      goodsNo.clear();
    } catch (e) {
      print('Error adding goods: $e');

      Get.snackbar('Error', 'Failed to add goods. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
    }
  }

  Future<void> getGoods() async {
    var goods = await db.collection("goods").get();
    goodsList.clear();
    for (var good in goods.docs) {
      goodsList.add(GoodsModel.fromJson(good.data()));
    }
    update();
    print("$goodsList >>>>>>>. Goods List");
  }

  void deleteGoods(String goodsId) async {
    try {
      await db.collection("goods").doc(goodsId).delete();
      print("Goods Deleted");

      Get.snackbar('Success', 'Goods deleted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: primaryColor);
    } catch (e) {
      print('Error deleting goods: $e');

      Get.snackbar('Error', 'Failed to delete goods. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
    }
    getGoods();
    update();
  }

  List<String?> getGoodsNames() {
    return goodsList.map((goods) => goods.name).toList();
  }

  GoodsModel? getGoodsByName(String goodsName) {
    for (var goods in goodsList) {
      if (goods.name == goodsName) {
        return goods;
      }
    }
    return null; // Return null if no matching customer found
  }

  Future<void> updateGoodsCount(
      String goodsId, int newPieceCount, int newCartonCount) async {
    try {
      var goodsData = {
        'pieceCount': newPieceCount,
        'cartonCount': newCartonCount,
      };

      await db
          .collection("goods")
          .doc(goodsId)
          .update(goodsData)
          .whenComplete(() {
        print("Goods Count Updated");
        getGoods();

        Get.snackbar('Success', 'Goods count updated successfully!',
            snackPosition: SnackPosition.BOTTOM,
            duration: const Duration(seconds: 3),
            backgroundColor: primaryColor);
      });
    } catch (e) {
      print('Error updating goods count: $e');

      Get.snackbar('Error', 'Failed to update goods count. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red);
    }
  }
}

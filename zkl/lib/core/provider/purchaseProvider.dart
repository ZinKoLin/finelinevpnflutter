import 'dart:async';

import 'package:collection/collection.dart' show IterableExtension;
import 'package:flutter/material.dart';
import 'package:flutter_inapp_purchase/flutter_inapp_purchase.dart';
import 'package:provider/provider.dart';

import 'vpnProvider.dart';

class PurchaseProvider extends ChangeNotifier {
  StreamSubscription<PurchasedItem?>? purchaseSnapshot;
  StreamSubscription<PurchaseResult?>? errorPurchaseSnapshot;
  FlutterInappPurchase get inappInstance => FlutterInappPurchase.instance;

  List<IAPItem>? _subscriptionProducts;
  bool _availableToPurchase = false;

  List<IAPItem>? get subscriptionProducts => _subscriptionProducts;

  set subscriptionProducts(List<IAPItem>? products) {
    _subscriptionProducts = products;
    notifyListeners();
  }

  bool get availableToPurchase => _availableToPurchase;

  set availableToPurchase(bool value) {
    _availableToPurchase = value;
    notifyListeners();
  }

  static Future initPurchase(BuildContext context) async {
    return PurchaseProvider.instance(context).init(context);
  }

  Future init(BuildContext context) async {
    await inappInstance.initialize();
    await fetchProducts();
    await refreshProStatus(context);
    purchaseSnapshot = FlutterInappPurchase.purchaseUpdated.listen((event) {
      _verifyPurchase(context, event!);
    });
  }

  @override
  void dispose() {
    purchaseSnapshot?.cancel();
    errorPurchaseSnapshot?.cancel();
    inappInstance.finalize();
    super.dispose();
  }

  Future<void> _verifyPurchase(BuildContext context, PurchasedItem detail) async {
    VpnProvider vpnProvider = VpnProvider.instance(context);
    DateTime? purchaseTime = detail.transactionDate;

    switch (detail.productId!.toLowerCase()) {
      case "one_week_subs":
        purchaseTime = purchaseTime!.add(Duration(days: 7));
        break;
      case "one_month_subs":
        purchaseTime = purchaseTime!.add(Duration(days: 30));
        break;
      case "one_year_subs":
        purchaseTime = purchaseTime!.add(Duration(days: 365));
        break;
      case "three_days_subs":
        purchaseTime = purchaseTime!.add(Duration(days: 3));
        break;
      default:
        return;
    }
    if (DateTime.now().isBefore(purchaseTime)) vpnProvider.proLimitDate = purchaseTime;
    try {
      await inappInstance.finishTransaction(detail);
    } catch (e) {}
  }

  Future<List<IAPItem>> fetchProducts() async {
    var resp = await inappInstance.getSubscriptions([
      "one_week_subs",
      "one_month_subs",
      "one_year_subs",
      "three_days_subs",
    ]);
    subscriptionProducts = resp;
    return resp;
  }

  Future<List<PurchasedItem>?> getPastPurchase() async {
    var resp = await inappInstance.getAvailablePurchases();
    return resp;
  }

  Future<PurchasedItem?> hasPurchased(String id) async {
    return (await getPastPurchase())?.firstWhereOrNull((element) => element.productId == id);
  }

  Future subscribe(String id) async {
    await inappInstance.requestSubscription(id);
  }

  Future refreshProStatus(BuildContext context) async {
    var resp = await inappInstance.getPurchaseHistory();
    if (resp != null && resp.length > 0)
      resp.forEach((element) {
        _verifyPurchase(context, element);
      });
  }

  static PurchaseProvider instance(BuildContext context) => Provider.of(context, listen: false);
}

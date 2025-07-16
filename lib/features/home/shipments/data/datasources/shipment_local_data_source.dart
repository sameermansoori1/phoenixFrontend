import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/shipment_model.dart';

class ShipmentLocalDataSource {
  static const _cacheKey = 'cached_shipments';

  Future<void> cacheShipments(List<ShipmentModel> shipments) async {
    final prefs = await SharedPreferences.getInstance();
    final shipmentListJson =
        jsonEncode(shipments.map((s) => s.toJson()).toList());
    await prefs.setString(_cacheKey, shipmentListJson);
  }

  Future<List<ShipmentModel>> getCachedShipments() async {
    final prefs = await SharedPreferences.getInstance();
    final shipmentListJson = prefs.getString(_cacheKey);
    if (shipmentListJson == null) return [];
    final List<dynamic> decoded = jsonDecode(shipmentListJson);
    return decoded.map((json) => ShipmentModel.fromJson(json)).toList();
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }
}

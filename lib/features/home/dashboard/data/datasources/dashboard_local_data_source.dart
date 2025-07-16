import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/dashboard_response_model.dart';

class DashboardLocalDataSource {
  static const _cacheKey = 'cached_dashboard_info';

  Future<void> cacheDashboardInfo(DashboardResponseModel model) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, jsonEncode(model.toJson()));
  }

  Future<DashboardResponseModel?> getCachedDashboardInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_cacheKey);
    if (jsonStr == null) return null;
    return DashboardResponseModel.fromJson(jsonDecode(jsonStr));
  }

  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
  }

  // Fallback mock data
  Future<DashboardResponseModel> getDashboardInfo() async {
    return DashboardResponseModel(
      fullName: 'Fallback User',
      patientId: 'P000000',
      currentPlan: 'Monthly',
      nextDeliveryDate: DateTime.now().add(Duration(days: 30)),
      remainingMedication: 10,
      status: 'active',
    );
  }
}

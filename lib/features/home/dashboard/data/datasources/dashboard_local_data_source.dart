import '../models/dashboard_response_model.dart';

class DashboardLocalDataSource {
  Future<DashboardResponseModel> getDashboardInfo() async {
    // Return mock/fallback data
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

class DashboardResponseModel {
  final String fullName;
  final String patientId;
  final String currentPlan;
  final DateTime nextDeliveryDate;
  final int remainingMedication;
  final String status;

  DashboardResponseModel({
    required this.fullName,
    required this.patientId,
    required this.currentPlan,
    required this.nextDeliveryDate,
    required this.remainingMedication,
    required this.status,
  });

  factory DashboardResponseModel.fromJson(Map<String, dynamic> json) {
    return DashboardResponseModel(
      fullName: json['fullName'] as String,
      patientId: json['patientId'] as String,
      currentPlan: json['currentPlan'] as String,
      nextDeliveryDate: DateTime.parse(json['nextDeliveryDate'] as String),
      remainingMedication: json['remainingMedication'] as int,
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'patientId': patientId,
      'currentPlan': currentPlan,
      'nextDeliveryDate': nextDeliveryDate.toIso8601String(),
      'remainingMedication': remainingMedication,
      'status': status,
    };
  }
}

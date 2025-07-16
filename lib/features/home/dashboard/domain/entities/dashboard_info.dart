class DashboardInfo {
  final String fullName;
  final String patientId;
  final String currentPlan;
  final DateTime nextDeliveryDate;
  final int remainingMedication;
  final String status;

  DashboardInfo({
    required this.fullName,
    required this.patientId,
    required this.currentPlan,
    required this.nextDeliveryDate,
    required this.remainingMedication,
    required this.status,
  });
}

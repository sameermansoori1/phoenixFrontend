class Shipment {
  final String id;
  final String userId;
  final DateTime date;
  final String status;
  final int quantity;

  Shipment({
    required this.id,
    required this.userId,
    required this.date,
    required this.status,
    required this.quantity,
  });
}

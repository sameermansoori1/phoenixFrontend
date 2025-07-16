class ShipmentModel {
  final String id;
  final String userId;
  final DateTime date;
  final String status;
  final int quantity;

  ShipmentModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.status,
    required this.quantity,
  });

  factory ShipmentModel.fromJson(Map<String, dynamic> json) {
    return ShipmentModel(
      id: json['_id'],
      userId: json['userId'],
      date: DateTime.parse(json['date']),
      status: json['status'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'status': status,
      'quantity': quantity,
    };
  }
}

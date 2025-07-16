import '../entities/shipment.dart';

abstract class ShipmentRepository {
  Future<List<Shipment>> getShipments();
}

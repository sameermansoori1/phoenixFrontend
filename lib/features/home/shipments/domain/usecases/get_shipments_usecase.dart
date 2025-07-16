import '../entities/shipment.dart';
import '../repositories/shipment_repository.dart';

class GetShipmentsUseCase {
  final ShipmentRepository repository;
  GetShipmentsUseCase(this.repository);

  Future<List<Shipment>> call() => repository.getShipments();
}

import '../../domain/entities/shipment.dart';
import '../../domain/repositories/shipment_repository.dart';
import '../datasources/shipment_remote_data_source.dart';

class ShipmentRepositoryImpl implements ShipmentRepository {
  final ShipmentRemoteDataSource remoteDataSource;
  ShipmentRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Shipment>> getShipments() async {
    final models = await remoteDataSource.getShipments();
    return models
        .map((m) => Shipment(
              id: m.id,
              userId: m.userId,
              date: m.date,
              status: m.status,
              quantity: m.quantity,
            ))
        .toList();
  }
}

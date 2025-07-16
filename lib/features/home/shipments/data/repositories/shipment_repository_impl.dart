import '../../domain/entities/shipment.dart';
import '../../domain/repositories/shipment_repository.dart';
import '../datasources/shipment_remote_data_source.dart';
import '../datasources/shipment_local_data_source.dart';

class ShipmentRepositoryImpl implements ShipmentRepository {
  final ShipmentRemoteDataSource remoteDataSource;
  final ShipmentLocalDataSource localDataSource;
  ShipmentRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<List<Shipment>> getShipments() async {
    try {
      final models = await remoteDataSource.getShipments(
        onFetched: (models) => localDataSource.cacheShipments(models),
      );
      return models
          .map((m) => Shipment(
                id: m.id,
                userId: m.userId,
                date: m.date,
                status: m.status,
                quantity: m.quantity,
              ))
          .toList();
    } catch (e) {
      // Fallback to local cache
      final cached = await localDataSource.getCachedShipments();
      return cached
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
}

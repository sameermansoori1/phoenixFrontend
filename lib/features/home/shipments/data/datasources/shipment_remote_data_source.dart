import 'package:phoenix_app/core/utils/network_client.dart';
import 'package:phoenix_app/core/utils/secure_storage.dart';
import '../models/shipment_model.dart';
import 'package:phoenix_app/core/constants/endpoints.dart';

class ShipmentRemoteDataSource {
  final NetworkClient networkClient;
  ShipmentRemoteDataSource({required this.networkClient});

  Future<List<ShipmentModel>> getShipments() async {
    final token = await SecureStorage.read('auth_token');
    final response = await networkClient.get(
      Endpoints.shipment,
      headers: {'Authorization': 'Bearer $token'},
    );
    return (response.data as List)
        .map((json) => ShipmentModel.fromJson(json))
        .toList();
  }
}

import 'package:phoenix_app/core/utils/network_client.dart';
import 'package:phoenix_app/core/utils/secure_storage.dart';
import 'package:phoenix_app/core/constants/endpoints.dart';
import '../models/dashboard_response_model.dart';

class DashboardRemoteDataSource {
  final NetworkClient networkClient;

  DashboardRemoteDataSource({required this.networkClient});

  Future<DashboardResponseModel> getDashboardInfo(
      {void Function(DashboardResponseModel)? onFetched}) async {
    final token = await SecureStorage.read('auth_token');
    final response = await networkClient.get(
      Endpoints.dashboard,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    final model = DashboardResponseModel.fromJson(response.data);
    if (onFetched != null) onFetched(model);
    return model;
  }
}

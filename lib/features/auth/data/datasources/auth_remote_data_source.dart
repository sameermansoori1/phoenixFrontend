import 'package:phoenix_app/core/utils/network_client.dart';
import 'package:phoenix_app/core/constants/endpoints.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

class AuthRemoteDataSource {
  final NetworkClient networkClient;

  AuthRemoteDataSource({required this.networkClient});

  Future<LoginResponseModel> login(LoginRequestModel request) async {
    final response = await networkClient.post(
      Endpoints.login,
      data: request.toJson(),
    );
    return LoginResponseModel.fromJson(response.data);
  }
}

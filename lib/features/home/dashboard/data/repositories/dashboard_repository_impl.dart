import 'package:phoenix_app/features/home/dashboard/domain/entities/dashboard_info.dart';
import 'package:phoenix_app/features/home/dashboard/domain/repositories/dashboard_repository.dart';

import '../datasources/dashboard_remote_data_source.dart';
import '../datasources/dashboard_local_data_source.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardRemoteDataSource remoteDataSource;
  final DashboardLocalDataSource localDataSource;

  DashboardRepositoryImpl(
      {required this.remoteDataSource, required this.localDataSource});

  @override
  Future<DashboardInfo> getDashboardInfo() async {
    try {
      final response = await remoteDataSource.getDashboardInfo();
      return DashboardInfo(
        fullName: response.fullName,
        patientId: response.patientId,
        currentPlan: response.currentPlan,
        nextDeliveryDate: response.nextDeliveryDate,
        remainingMedication: response.remainingMedication,
        status: response.status,
      );
    } catch (e) {
      // Fallback to local data
      final response = await localDataSource.getDashboardInfo();
      return DashboardInfo(
        fullName: response.fullName,
        patientId: response.patientId,
        currentPlan: response.currentPlan,
        nextDeliveryDate: response.nextDeliveryDate,
        remainingMedication: response.remainingMedication,
        status: response.status,
      );
    }
  }
}

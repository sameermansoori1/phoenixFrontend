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
      final response = await remoteDataSource.getDashboardInfo(
        onFetched: (model) => localDataSource.cacheDashboardInfo(model),
      );
      return DashboardInfo(
        fullName: response.fullName,
        patientId: response.patientId,
        currentPlan: response.currentPlan,
        nextDeliveryDate: response.nextDeliveryDate,
        remainingMedication: response.remainingMedication,
        status: response.status,
      );
    } catch (e) {
      // Fallback to local cache
      final cached = await localDataSource.getCachedDashboardInfo();
      if (cached != null) {
        return DashboardInfo(
          fullName: cached.fullName,
          patientId: cached.patientId,
          currentPlan: cached.currentPlan,
          nextDeliveryDate: cached.nextDeliveryDate,
          remainingMedication: cached.remainingMedication,
          status: cached.status,
        );
      }
      // Fallback to mock data if no cache
      final fallback = await localDataSource.getDashboardInfo();
      return DashboardInfo(
        fullName: fallback.fullName,
        patientId: fallback.patientId,
        currentPlan: fallback.currentPlan,
        nextDeliveryDate: fallback.nextDeliveryDate,
        remainingMedication: fallback.remainingMedication,
        status: fallback.status,
      );
    }
  }
}

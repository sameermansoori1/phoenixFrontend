import '../entities/dashboard_info.dart';

abstract class DashboardRepository {
  Future<DashboardInfo> getDashboardInfo();
}

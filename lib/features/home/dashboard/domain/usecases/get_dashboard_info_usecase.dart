import '../entities/dashboard_info.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardInfoUseCase {
  final DashboardRepository repository;

  GetDashboardInfoUseCase(this.repository);

  Future<DashboardInfo> call() {
    return repository.getDashboardInfo();
  }
}

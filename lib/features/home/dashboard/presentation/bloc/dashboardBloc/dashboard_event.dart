// lib/features/dashboard/presentation/bloc/dashboard_event.dart
import 'package:equatable/equatable.dart';

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object> get props => [];
}

class LoadDashboardData extends DashboardEvent {
  const LoadDashboardData();
}

class RefreshDashboardData extends DashboardEvent {
  const RefreshDashboardData();
}

class UpdateMedicationStatus extends DashboardEvent {
  final String medicationId;
  final String newStatus;

  const UpdateMedicationStatus({
    required this.medicationId,
    required this.newStatus,
  });

  @override
  List<Object> get props => [medicationId, newStatus];
}

class FetchDashboardInfo extends DashboardEvent {
  const FetchDashboardInfo();
}

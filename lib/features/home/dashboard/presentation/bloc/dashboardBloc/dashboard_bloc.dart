// lib/features/dashboard/presentation/bloc/dashboard_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dashboard_event.dart';
import 'dashboard_state.dart';
import 'package:phoenix_app/features/home/dashboard/domain/usecases/get_dashboard_info_usecase.dart';
import 'package:phoenix_app/features/home/dashboard/domain/entities/dashboard_info.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final GetDashboardInfoUseCase getDashboardInfoUseCase;
  DashboardBloc({required this.getDashboardInfoUseCase})
      : super(DashboardInitial()) {
    on<FetchDashboardInfo>(_onFetchDashboardInfo);
    on<LoadDashboardData>(_onLoadDashboardData);
    on<RefreshDashboardData>(_onRefreshDashboardData);
    on<UpdateMedicationStatus>(_onUpdateMedicationStatus);
  }

  Future<void> _onFetchDashboardInfo(
    FetchDashboardInfo event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());
    try {
      final DashboardInfo info = await getDashboardInfoUseCase();
      emit(DashboardLoaded(
        patientInfo: PatientInfo(
          name: info.fullName,
          patientId: info.patientId,
          currentPlan: info.currentPlan,
          status: info.status,
        ),
        deliveryInfo: DeliveryInfo(
          nextDeliveryDate: info.nextDeliveryDate,
          daysRemaining:
              info.nextDeliveryDate.difference(DateTime.now()).inDays,
        ),
        medicationInfo: MedicationInfo(
          remainingPercentage: info.remainingMedication,
          daysLeft: info.remainingMedication,
        ),
        appointments: [
          Appointment(
            id: '1',
            doctorName: 'Dr. John Smith',
            specialty: 'Cardiologist',
            date: DateTime(2023, 7, 15),
            time: '9:00 AM',
          ),
          Appointment(
            id: '2',
            doctorName: 'Dr. Jane Doe',
            specialty: 'Endocrinologist',
            date: DateTime(2023, 7, 20),
            time: '11:30 AM',
          ),
        ],
        medications: const [],
      ));
    } catch (e) {
      emit(DashboardError(message: 'Failed to load dashboard data'));
    }
  }

  Future<void> _onLoadDashboardData(
    LoadDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    emit(DashboardLoading());

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));

      // Mock data - replace with actual API calls
      final patientInfo = PatientInfo(
        name: 'Sarah Johnson',
        patientId: 'PAT-78945',
        currentPlan: 'Premium Care',
        status: 'Active',
      );

      final deliveryInfo = DeliveryInfo(
        nextDeliveryDate: DateTime(2023, 7, 22),
        daysRemaining: 7,
      );

      final medicationInfo = MedicationInfo(
        remainingPercentage: 65,
        daysLeft: 13,
      );

      final appointments = [
        Appointment(
          id: '1',
          doctorName: 'Dr. Robert Williams',
          specialty: 'Cardiologist',
          date: DateTime(2023, 7, 18),
          time: '10:30 AM',
        ),
        Appointment(
          id: '2',
          doctorName: 'Dr. Emily Chen',
          specialty: 'General Physician',
          date: DateTime(2023, 7, 25),
          time: '2:00 PM',
        ),
      ];

      final medications = [
        Medication(
          id: '1',
          name: 'Lisinopril',
          dosage: '10mg',
          frequency: 'Once daily',
          status: 'Refill available',
        ),
        Medication(
          id: '2',
          name: 'Metformin',
          dosage: '500mg',
          frequency: 'Twice daily',
          status: 'Low supply',
        ),
      ];

      emit(DashboardLoaded(
        patientInfo: patientInfo,
        deliveryInfo: deliveryInfo,
        medicationInfo: medicationInfo,
        appointments: appointments,
        medications: medications,
      ));
    } catch (e) {
      emit(DashboardError(message: 'Failed to load dashboard data'));
    }
  }

  Future<void> _onRefreshDashboardData(
    RefreshDashboardData event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      // Show loading but keep existing data
      final currentState = state as DashboardLoaded;
      emit(DashboardLoading());

      try {
        // Simulate refresh delay
        await Future.delayed(const Duration(milliseconds: 800));

        // Re-emit the same data (in real app, this would be fresh data)
        emit(currentState);
      } catch (e) {
        emit(DashboardError(message: 'Failed to refresh dashboard data'));
      }
    } else {
      add(const LoadDashboardData());
    }
  }

  Future<void> _onUpdateMedicationStatus(
    UpdateMedicationStatus event,
    Emitter<DashboardState> emit,
  ) async {
    if (state is DashboardLoaded) {
      final currentState = state as DashboardLoaded;

      try {
        // Update medication status
        final updatedMedications = currentState.medications.map((medication) {
          if (medication.id == event.medicationId) {
            return Medication(
              id: medication.id,
              name: medication.name,
              dosage: medication.dosage,
              frequency: medication.frequency,
              status: event.newStatus,
            );
          }
          return medication;
        }).toList();

        emit(currentState.copyWith(medications: updatedMedications));
      } catch (e) {
        emit(DashboardError(message: 'Failed to update medication status'));
      }
    }
  }
}

// lib/features/dashboard/presentation/bloc/dashboard_state.dart
import 'package:equatable/equatable.dart';
import 'package:phoenix_app/features/home/dashboard/domain/entities/dashboard_info.dart';

class PatientInfo extends Equatable {
  final String name;
  final String patientId;
  final String currentPlan;
  final String status;

  const PatientInfo({
    required this.name,
    required this.patientId,
    required this.currentPlan,
    required this.status,
  });

  @override
  List<Object> get props => [name, patientId, currentPlan, status];
}

class DeliveryInfo extends Equatable {
  final DateTime nextDeliveryDate;
  final int daysRemaining;

  const DeliveryInfo({
    required this.nextDeliveryDate,
    required this.daysRemaining,
  });

  @override
  List<Object> get props => [nextDeliveryDate, daysRemaining];
}

class MedicationInfo extends Equatable {
  final int remainingPercentage;
  final int daysLeft;

  const MedicationInfo({
    required this.remainingPercentage,
    required this.daysLeft,
  });

  @override
  List<Object> get props => [remainingPercentage, daysLeft];
}

class Appointment extends Equatable {
  final String doctorName;
  final String specialty;
  final DateTime date;
  final String time;
  final String id;

  const Appointment({
    required this.doctorName,
    required this.specialty,
    required this.date,
    required this.time,
    required this.id,
  });

  @override
  List<Object> get props => [doctorName, specialty, date, time, id];
}

class Medication extends Equatable {
  final String id;
  final String name;
  final String dosage;
  final String frequency;
  final String status;

  const Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.frequency,
    required this.status,
  });

  @override
  List<Object> get props => [id, name, dosage, frequency, status];
}

abstract class DashboardState extends Equatable {
  const DashboardState();

  @override
  List<Object> get props => [];
}

class DashboardInitial extends DashboardState {}

class DashboardLoading extends DashboardState {}

class DashboardLoaded extends DashboardState {
  final PatientInfo patientInfo;
  final DeliveryInfo deliveryInfo;
  final MedicationInfo medicationInfo;
  final List<Appointment> appointments;
  final List<Medication> medications;

  const DashboardLoaded({
    required this.patientInfo,
    required this.deliveryInfo,
    required this.medicationInfo,
    required this.appointments,
    required this.medications,
  });

  @override
  List<Object> get props => [
        patientInfo,
        deliveryInfo,
        medicationInfo,
        appointments,
        medications,
      ];

  DashboardLoaded copyWith({
    PatientInfo? patientInfo,
    DeliveryInfo? deliveryInfo,
    MedicationInfo? medicationInfo,
    List<Appointment>? appointments,
    List<Medication>? medications,
  }) {
    return DashboardLoaded(
      patientInfo: patientInfo ?? this.patientInfo,
      deliveryInfo: deliveryInfo ?? this.deliveryInfo,
      medicationInfo: medicationInfo ?? this.medicationInfo,
      appointments: appointments ?? this.appointments,
      medications: medications ?? this.medications,
    );
  }

  DashboardInfo get info => DashboardInfo(
        fullName: patientInfo.name,
        patientId: patientInfo.patientId,
        currentPlan: patientInfo.currentPlan,
        nextDeliveryDate: deliveryInfo.nextDeliveryDate,
        remainingMedication: medicationInfo.remainingPercentage,
        status: patientInfo.status,
      );
}

class DashboardError extends DashboardState {
  final String message;

  const DashboardError({required this.message});

  @override
  List<Object> get props => [message];
}

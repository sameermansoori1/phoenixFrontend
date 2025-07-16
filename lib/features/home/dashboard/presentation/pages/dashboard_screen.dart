// lib/features/dashboard/presentation/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:phoenix_app/core/theme/app_colors.dart';
import 'package:phoenix_app/core/theme/app_text_styles.dart';
import 'package:phoenix_app/core/utils/network_client.dart';
import 'package:phoenix_app/features/home/dashboard/data/datasources/dashboard_local_data_source.dart';
import 'package:phoenix_app/features/home/dashboard/data/datasources/dashboard_remote_data_source.dart';
import 'package:phoenix_app/features/home/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:phoenix_app/features/home/dashboard/domain/usecases/get_dashboard_info_usecase.dart';
import 'package:phoenix_app/features/home/dashboard/presentation/bloc/dashboardBloc/dashboard_bloc.dart';
import 'package:phoenix_app/features/home/dashboard/presentation/bloc/dashboardBloc/dashboard_event.dart';
import 'package:phoenix_app/features/home/dashboard/presentation/widgets/dashboard_widgets.dart';
import 'package:phoenix_app/features/home/dashboard/presentation/bloc/dashboardBloc/dashboard_state.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  Widget build(BuildContext context) {
    final networkClient = NetworkClient();
    final remoteDataSource =
        DashboardRemoteDataSource(networkClient: networkClient);
    final localDataSource = DashboardLocalDataSource();
    final repository = DashboardRepositoryImpl(
      remoteDataSource: remoteDataSource,
      localDataSource: localDataSource,
    );
    final getDashboardInfoUseCase = GetDashboardInfoUseCase(repository);

    return BlocProvider<DashboardBloc>(
      create: (_) =>
          DashboardBloc(getDashboardInfoUseCase: getDashboardInfoUseCase)
            ..add(FetchDashboardInfo()),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(80),
          child: Builder(
            builder: (context) {
              final state = context.watch<DashboardBloc>().state;
              String userName = '';
              String date = DateFormat('EEEE, MMMM dd').format(DateTime.now());
              if (state is DashboardLoaded) {
                userName = state.info.fullName.split(' ').first;
              }
              return AppBar(
                backgroundColor: AppColors.surface,
                elevation: 0,
                flexibleSpace: SafeArea(
                  child: Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                userName.isNotEmpty
                                    ? 'Welcome, $userName'
                                    : 'Welcome',
                                style: AppTextStyles.textTheme.headlineMedium
                                    ?.copyWith(
                                  color: AppColors.background,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                date,
                                style: AppTextStyles.textTheme.bodyMedium
                                    ?.copyWith(
                                  color: AppColors.background
                                      .withValues(alpha: 0.8),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.background.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.person,
                            color: AppColors.surface,
                            size: 32,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        backgroundColor: AppColors.bgContainer,
        body: SafeArea(
          child: BlocBuilder<DashboardBloc, DashboardState>(
            builder: (context, state) {
              if (state is DashboardInitial || state is DashboardLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                );
              }

              if (state is DashboardError) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 64,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Error',
                        style: AppTextStyles.textTheme.headlineMedium?.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.message,
                        style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<DashboardBloc>()
                              .add(FetchDashboardInfo());
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.surface,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Retry',
                          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                            color: AppColors.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              if (state is DashboardLoaded) {
                final info = state.info;
                // Map API data to widget types
                final patientInfo = PatientInfo(
                  name: info.fullName,
                  patientId: info.patientId,
                  currentPlan: info.currentPlan,
                  status: info.status,
                );
                final deliveryInfo = DeliveryInfo(
                  nextDeliveryDate: info.nextDeliveryDate,
                  daysRemaining:
                      info.nextDeliveryDate.difference(DateTime.now()).inDays,
                );
                final medicationInfo = MedicationInfo(
                  remainingPercentage: info.remainingMedication,
                  daysLeft: info.remainingMedication,
                );
                final appointments = <Appointment>[];
                final medications = <Medication>[];
                return RefreshIndicator(
                  onRefresh: () async {
                    context.read<DashboardBloc>().add(FetchDashboardInfo());
                  },
                  color: AppColors.primary,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header is now in AppBar
                        const SizedBox(height: 24),

                        // Patient Information
                        PatientInfoCard(
                          patientInfo: patientInfo,
                        ),
                        const SizedBox(height: 24),

                        // Delivery & Medication Info
                        DeliveryMedicationCard(
                          deliveryInfo: deliveryInfo,
                          medicationInfo: medicationInfo,
                        ),
                        const SizedBox(height: 24),

                        // Upcoming Appointments
                        SectionHeader(
                          title: 'Upcoming Appointments',
                          actionText: 'View All',
                          onActionTap: () {
                            _navigateToAppointments(context);
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildAppointmentsList(appointments),
                        const SizedBox(height: 24),

                        // Your Medications
                        SectionHeader(
                          title: 'Your Medications',
                          actionText: 'View All',
                          onActionTap: () {
                            _navigateToMedications(context);
                          },
                        ),
                        const SizedBox(height: 16),
                        _buildMedicationsList(medications),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  void _navigateToAppointments(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigating to appointments...',
          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
            color: AppColors.surface,
          ),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _navigateToMedications(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Navigating to medications...',
          style: AppTextStyles.textTheme.bodyMedium?.copyWith(
            color: AppColors.surface,
          ),
        ),
        backgroundColor: AppColors.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  void _showAppointmentDetails(BuildContext context, Appointment appointment) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AppointmentCard(appointment: appointment),
    );
  }

  void _showMedicationDetails(BuildContext context, Medication medication) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MedicationCard(medication: medication),
    );
  }

  // Add back the _buildAppointmentsList and _buildMedicationsList methods
  Widget _buildAppointmentsList(List<Appointment> appointments) {
    if (appointments.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(
              Icons.event_available,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              'No upcoming appointments',
              style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: appointments.map((appointment) {
        return AppointmentCard(
          appointment: appointment,
          onTap: () {
            _showAppointmentDetails(context, appointment);
          },
        );
      }).toList(),
    );
  }

  Widget _buildMedicationsList(List<Medication> medications) {
    if (medications.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Icon(
              Icons.medication,
              size: 48,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: 12),
            Text(
              'No medications found',
              style: AppTextStyles.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: medications.map((medication) {
        return MedicationCard(
          medication: medication,
          onTap: () {
            _showMedicationDetails(context, medication);
          },
        );
      }).toList(),
    );
  }
}

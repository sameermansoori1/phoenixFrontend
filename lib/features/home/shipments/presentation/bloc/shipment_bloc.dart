import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shipment.dart';
import '../../domain/usecases/get_shipments_usecase.dart';
import '../../data/repositories/shipment_repository_impl.dart';
import '../../data/datasources/shipment_local_data_source.dart';

abstract class ShipmentEvent {}

class FetchShipments extends ShipmentEvent {}

class FilterShipments extends ShipmentEvent {
  final String status;
  FilterShipments(this.status);
}

abstract class ShipmentState {}

class ShipmentInitial extends ShipmentState {}

class ShipmentLoading extends ShipmentState {}

class ShipmentLoaded extends ShipmentState {
  final List<Shipment> shipments;
  ShipmentLoaded(this.shipments);
}

class ShipmentError extends ShipmentState {
  final String message;
  ShipmentError(this.message);
}

class ShipmentBloc extends Bloc<ShipmentEvent, ShipmentState> {
  final GetShipmentsUseCase getShipmentsUseCase;
  List<Shipment> _allShipments = [];
  ShipmentBloc({required this.getShipmentsUseCase}) : super(ShipmentInitial()) {
    on<FetchShipments>((event, emit) async {
      // 1. Try to load cached data and show it immediately
      ShipmentLocalDataSource? localDataSource;
      if (getShipmentsUseCase.repository is ShipmentRepositoryImpl) {
        localDataSource =
            (getShipmentsUseCase.repository as ShipmentRepositoryImpl)
                .localDataSource;
      }
      if (localDataSource != null) {
        final cached = await localDataSource.getCachedShipments();
        if (cached.isNotEmpty) {
          final shipments = cached
              .map((m) => Shipment(
                    id: m.id,
                    userId: m.userId,
                    date: m.date,
                    status: m.status,
                    quantity: m.quantity,
                  ))
              .toList();
          _allShipments = shipments;
          emit(ShipmentLoaded(shipments));
        } else {
          emit(ShipmentLoading());
        }
      } else {
        emit(ShipmentLoading());
      }

      // 2. Try to fetch from API
      try {
        final shipments = await getShipmentsUseCase();
        _allShipments = shipments;
        emit(ShipmentLoaded(shipments));
      } catch (e) {
        if (state is! ShipmentLoaded) {
          emit(ShipmentError('Failed to load shipments'));
        }
      }
    });
    on<FilterShipments>((event, emit) {
      if (state is ShipmentLoaded) {
        final filtered = event.status == 'All'
            ? _allShipments
            : _allShipments
                .where((s) =>
                    s.status.trim().toLowerCase() ==
                    event.status.trim().toLowerCase())
                .toList();
        emit(ShipmentLoaded(filtered));
      }
    });
  }
}

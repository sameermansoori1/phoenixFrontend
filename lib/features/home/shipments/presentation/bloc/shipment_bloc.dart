import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/shipment.dart';
import '../../domain/usecases/get_shipments_usecase.dart';

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
      emit(ShipmentLoading());
      try {
        final shipments = await getShipmentsUseCase();
        _allShipments = shipments;
        emit(ShipmentLoaded(shipments));
      } catch (e) {
        emit(ShipmentError('Failed to load shipments'));
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

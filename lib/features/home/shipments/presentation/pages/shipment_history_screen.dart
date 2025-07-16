import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/shipment_remote_data_source.dart';
import '../../data/repositories/shipment_repository_impl.dart';
import '../../domain/usecases/get_shipments_usecase.dart';
import '../../presentation/bloc/shipment_bloc.dart';
import 'package:phoenix_app/core/utils/network_client.dart';
import '../widgets/shipment_card.dart';

class ShipmentHistoryScreen extends StatelessWidget {
  const ShipmentHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final networkClient = NetworkClient();
    final remoteDataSource =
        ShipmentRemoteDataSource(networkClient: networkClient);
    final repository =
        ShipmentRepositoryImpl(remoteDataSource: remoteDataSource);
    final getShipmentsUseCase = GetShipmentsUseCase(repository);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text('Shipment History',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Showing all shipments',
                    style: TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      final blocContext = context;
                      showModalBottomSheet(
                        context: context,
                        shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(16)),
                        ),
                        builder: (context) {
                          return SafeArea(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.list),
                                  title: const Text('All'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    blocContext
                                        .read<ShipmentBloc>()
                                        .add(FilterShipments('All'));
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.check_circle,
                                      color: Colors.green),
                                  title: const Text('Delivered'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    blocContext
                                        .read<ShipmentBloc>()
                                        .add(FilterShipments('Delivered'));
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.local_shipping,
                                      color: Colors.orange),
                                  title: const Text('Pending'),
                                  onTap: () {
                                    Navigator.pop(context);
                                    blocContext
                                        .read<ShipmentBloc>()
                                        .add(FilterShipments('Pending'));
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Row(
                      children: const [
                        Icon(Icons.filter_alt_outlined,
                            color: Colors.blue, size: 22),
                        SizedBox(width: 4),
                        Text('Filter',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.w500)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ShipmentBloc, ShipmentState>(
                builder: (context, state) {
                  if (state is ShipmentLoading || state is ShipmentInitial) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ShipmentError) {
                    return Center(child: Text(state.message));
                  } else if (state is ShipmentLoaded) {
                    final shipments = state.shipments;
                    if (shipments.isEmpty) {
                      return const Center(child: Text('No shipments found.'));
                    }
                    return ListView.separated(
                      key: ValueKey(shipments.length),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: shipments.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        return ShipmentCard(shipment: shipments[index]);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

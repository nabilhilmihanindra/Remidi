import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../app_routes.dart';
import '../state/deteksi_bloc.dart';
import '../state/deteksi_event.dart';
import '../state/deteksi_state.dart';
import '../widgets/deteksi_card.dart';
import '../widgets/stat_card.dart';

class HalamanDeteksi extends StatelessWidget {
  const HalamanDeteksi({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<DeteksiBloc, DeteksiState>(
      builder: (context, state) {
        final listData = state.dataTerfilter;

        return Scaffold(
          floatingActionButton: FloatingActionButton.extended(
            onPressed: () {
              Navigator.pushNamed(context, AppRoutes.inputDeteksi);
            },
            icon: const Icon(Icons.add),
            label: const Text('Deteksi Baru'),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Riwayat Deteksi & Filter Petak
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Riwayat Deteksi',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 12),
                    // Pilihan filter petak dengan SegmentedButton
                    SizedBox(
                      width: double.infinity,
                      child: SegmentedButton<String>(
                        segments: const [
                          ButtonSegment<String>(
                            value: 'Semua',
                            label: Text('Semua'),
                          ),
                          ButtonSegment<String>(
                            value: 'Petak 1',
                            label: Text('Petak 1'),
                          ),
                          ButtonSegment<String>(
                            value: 'Petak 2',
                            label: Text('Petak 2'),
                          ),
                        ],
                        selected: {state.filterPetak},
                        onSelectionChanged: (newSelection) {
                          context
                              .read<DeteksiBloc>()
                              .add(FilterPetakEvent(newSelection.first));
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // Tiga kartu statistik: Total, Sehat, Perlu Tindakan
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Row(
                  children: [
                    Expanded(
                      child: StatCard(
                        title: 'Total',
                        value: '${state.totalSemua}',
                      ),
                    ),
                    Expanded(
                      child: StatCard(
                        title: 'Sehat',
                        value: '${state.totalSehat}',
                        valueColor: Colors.green.shade600,
                      ),
                    ),
                    Expanded(
                      child: StatCard(
                        title: 'Perlu Tindakan',
                        value: '${state.totalPerluTindakan}',
                        valueColor: Colors.red.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Daftar Riwayat Deteksi / Pesan Belum Ada Data
              Expanded(
                child: listData.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.inbox_outlined,
                              size: 48,
                              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Belum ada data',
                              style: TextStyle(
                                fontSize: 15,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.only(bottom: 80, top: 4),
                        itemCount: listData.length,
                        itemBuilder: (context, index) {
                          final item = listData[index];
                          return DeteksiCard(
                            data: item,
                            onDelete: () {
                              context
                                  .read<DeteksiBloc>()
                                  .add(HapusDeteksiEvent(item.id));
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Data deteksi berhasil dihapus'),
                                  duration: Duration(seconds: 1),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

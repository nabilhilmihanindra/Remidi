import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state/deteksi_bloc.dart';
import '../state/deteksi_event.dart';
import '../state/deteksi_state.dart';

class HalamanPengaturan extends StatelessWidget {
  const HalamanPengaturan({super.key});

  void _tampilkanDialogHapusSemua(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Hapus Semua Data?'),
          content: const Text('Semua riwayat deteksi akan dihapus.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
              onPressed: () {
                context.read<DeteksiBloc>().add(const HapusSemuaDataEvent());
                Navigator.of(dialogContext).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Semua data berhasil dihapus'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return BlocBuilder<DeteksiBloc, DeteksiState>(
      builder: (context, state) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Switch Mode Gelap
              Card(
                elevation: 0.5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: SwitchListTile(
                  title: Text(
                    'Mode Gelap',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  subtitle: Text(
                    state.isDarkMode
                        ? 'Tema gelap aktif'
                        : 'Tema terang aktif',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  secondary: Icon(
                    state.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: colorScheme.primary,
                  ),
                  value: state.isDarkMode,
                  onChanged: (bool value) {
                    context.read<DeteksiBloc>().add(ToggleTemaEvent(value));
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Muat Data Simulasi
              SizedBox(
                height: 48,
                child: FilledButton.tonal(
                  onPressed: () {
                    context
                        .read<DeteksiBloc>()
                        .add(const MuatDataSimulasiEvent());
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('10 data simulasi berhasil dimuat'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.science_outlined, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Muat Data Simulasi',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Tombol Hapus Semua Data
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: colorScheme.error,
                    side: BorderSide(
                      color: colorScheme.error.withValues(alpha: 0.5),
                    ),
                  ),
                  onPressed: () {
                    _tampilkanDialogHapusSemua(context);
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.delete_forever, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Hapus Semua Data',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

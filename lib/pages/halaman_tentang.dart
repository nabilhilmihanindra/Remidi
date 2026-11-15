import 'package:flutter/material.dart';
import '../models/hasil_deteksi.dart';

class HalamanTentang extends StatelessWidget {
  const HalamanTentang({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tentang Aplikasi'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Bagian Tujuan Aplikasi
          Card(
            elevation: 1,
            color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info_outline, color: colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Tujuan Aplikasi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'AgriVision CNN dirancang untuk membantu kelompok tani mendokumentasikan hasil pengamatan penyakit dan hama pada tanaman padi di Petak 1 dan Petak 2. Menggunakan model EfficientNet-B0, aplikasi menyediakan pencatatan riwayat terstruktur, kalkulasi status risiko secara otomatis, dan grafik statistik untuk pengambilan keputusan penanganan yang lebih efektif.',
                    style: TextStyle(
                      fontSize: 13.5,
                      height: 1.45,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Header Daftar Kelas
          Text(
            'Daftar 5 Kelas Deteksi',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Model EfficientNet-B0 dilatih untuk mengenali 5 kategori berikut:',
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),

          // Daftar 5 Kelas menggunakan ListView items
          ...daftarKelas.map((kelas) {
            final isSehat = kelas == 'Normal / Sehat';
            return Card(
              margin: const EdgeInsets.only(bottom: 10),
              elevation: 0.5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: isSehat
                      ? Colors.green.withValues(alpha: 0.15)
                      : colorScheme.errorContainer.withValues(alpha: 0.4),
                  child: Icon(
                    isSehat ? Icons.eco : Icons.bug_report,
                    color: isSehat ? Colors.green.shade700 : colorScheme.error,
                  ),
                ),
                title: Text(
                  kelas,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14.5,
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    isSehat
                        ? 'Kondisi tanaman sehat tanpa gejala serangan hama/patogen.'
                        : 'Kategori penyakit/hama berpotensi menurunkan produktivitas panen.',
                    style: TextStyle(
                      fontSize: 12,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/hasil_deteksi.dart';

class DeteksiCard extends StatelessWidget {
  final HasilDeteksi data;
  final VoidCallback? onDelete;

  const DeteksiCard({
    super.key,
    required this.data,
    this.onDelete,
  });

  /// Menentukan warna berdasarkan status dengan switch
  Color _getStatusColor(String status, ColorScheme colorScheme) {
    switch (status) {
      case 'Sehat':
        return Colors.green.shade600;
      case 'Tidak Pasti':
        return Colors.amber.shade800;
      case 'Perlu Tindakan':
        return Colors.red.shade600;
      default:
        return colorScheme.primary;
    }
  }

  /// Menentukan ikon berdasarkan status dengan switch
  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'Sehat':
        return Icons.check_circle_outline;
      case 'Tidak Pasti':
        return Icons.help_outline;
      case 'Perlu Tindakan':
        return Icons.warning_amber_rounded;
      default:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final statusColor = _getStatusColor(data.status, colorScheme);
    final statusIcon = _getStatusIcon(data.status);
    final formattedTime =
        DateFormat('dd/MM/yyyy HH:mm').format(data.waktu);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 1.5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: colorScheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Baris atas: Ikon status, Petak & Kelas, dan Tombol Hapus
            Row(
              children: [
                Icon(statusIcon, color: statusColor, size: 22),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    '${data.petak} - ${data.kelas}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (onDelete != null)
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline,
                      color: colorScheme.error,
                      size: 20,
                    ),
                    tooltip: 'Hapus Deteksi',
                    onPressed: onDelete,
                    visualDensity: VisualDensity.compact,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
              ],
            ),
            const SizedBox(height: 6),

            // Teks Status
            Text(
              data.status,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: statusColor,
              ),
            ),
            const SizedBox(height: 8),

            // Skor deteksi dan LinearProgressIndicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Skor: ${data.skor.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 13,
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: (data.skor / 100.0).clamp(0.0, 1.0),
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(statusColor),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 10),

            // Rekomendasi
            Text(
              data.rekomendasi,
              style: TextStyle(
                fontSize: 12.5,
                color: colorScheme.onSurface,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 8),

            // Petugas dan Waktu
            Text(
              '${data.namaPetugas} • $formattedTime',
              style: TextStyle(
                fontSize: 11.5,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:math';

/// Rekomendasi penanganan per kelas sesuai Tabel B
const Map<String, String> rekomendasiPerKelas = {
  'Hawar daun bakteri':
      'Kurangi pupuk urea, buang air berlebih, bersihkan jerami yang sakit.',
  'Penyakit blas (jamur)':
      'Jaga sawah tetap tergenang, semprot obat jamur saat padi keluar malai.',
  'Bercak coklat': 'Tambah pupuk kalium, jaga sawah tetap tergenang.',
  'Normal / Sehat': 'Tanaman sehat. Lanjutkan pemantauan rutin.',
  'Penyakit tungro (virus)':
      'Cabut rumpun yang sakit, musim depan pakai varietas tahan.',
};

/// 5 kelas deteksi EfficientNet-B0
const List<String> daftarKelas = [
  'Hawar daun bakteri',
  'Penyakit blas (jamur)',
  'Bercak coklat',
  'Normal / Sehat',
  'Penyakit tungro (virus)',
];

/// Daftar petak sawah
const List<String> daftarPetak = [
  'Petak 1',
  'Petak 2',
];

/// Model data hasil deteksi CNN
class HasilDeteksi {
  final String id;
  final String petak;
  final String kelas;
  final double skor;
  final String namaPetugas;
  final DateTime waktu;

  HasilDeteksi({
    String? id,
    required this.petak,
    required this.kelas,
    required this.skor,
    required this.namaPetugas,
    required this.waktu,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString();

  /// Penentuan status deteksi berdasarkan Tabel A
  String get status {
    if (kelas == 'Normal / Sehat') {
      return 'Sehat';
    }
    if (skor < 50) {
      return 'Tidak Pasti';
    }
    return 'Perlu Tindakan';
  }

  /// Penentuan rekomendasi berdasarkan Tabel A & Tabel B
  String get rekomendasi {
    if (kelas == 'Normal / Sehat') {
      return 'Lanjutkan pemantauan rutin';
    }
    if (skor < 50) {
      return 'Cek ulang oleh petugas';
    }
    final saran = rekomendasiPerKelas[kelas] ?? '-';
    return 'Segera tangani: $saran';
  }
}

/// Fungsi untuk membuat 10 data simulasi deteksi secara acak
List<HasilDeteksi> buatDataSimulasi() {
  final random = Random();
  final listPetugas = [
    'Budi Santoso',
    'Siti Aminah',
    'Ahmad Fauzi',
    'Joko Susilo',
    'Dewi Lestari',
  ];

  final List<HasilDeteksi> data = [];
  final now = DateTime.now();

  for (int i = 0; i < 10; i++) {
    final petak = daftarPetak[random.nextInt(daftarPetak.length)];
    final kelas = daftarKelas[random.nextInt(daftarKelas.length)];
    // Skor berupa angka bulat 30–99
    final skor = (30 + random.nextInt(70)).toDouble();
    final namaPetugas = listPetugas[random.nextInt(listPetugas.length)];
    // Waktu mundur acak dalam 24 jam terakhir
    final waktu = now.subtract(Duration(minutes: (i + 1) * 35));

    data.add(
      HasilDeteksi(
        id: 'sim_${i}_${DateTime.now().microsecondsSinceEpoch}',
        petak: petak,
        kelas: kelas,
        skor: skor,
        namaPetugas: namaPetugas,
        waktu: waktu,
      ),
    );
  }

  return data;
}

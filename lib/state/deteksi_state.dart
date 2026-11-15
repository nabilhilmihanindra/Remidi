import '../models/hasil_deteksi.dart';

class DeteksiState {
  final List<HasilDeteksi> semuaData;
  final String filterPetak;
  final bool isDarkMode;

  const DeteksiState({
    this.semuaData = const [],
    this.filterPetak = 'Semua',
    this.isDarkMode = false,
  });

  /// Daftar data sesuai pilihan filter petak
  List<HasilDeteksi> get dataTerfilter {
    if (filterPetak == 'Semua') {
      return List.unmodifiable(semuaData);
    }
    return List.unmodifiable(
      semuaData.where((item) => item.petak == filterPetak),
    );
  }

  /// Statistik total data
  int get totalSemua => semuaData.length;

  /// Statistik total status 'Sehat'
  int get totalSehat =>
      semuaData.where((item) => item.status == 'Sehat').length;

  /// Statistik total status 'Perlu Tindakan'
  int get totalPerluTindakan =>
      semuaData.where((item) => item.status == 'Perlu Tindakan').length;

  /// Statistik total status 'Tidak Pasti'
  int get totalTidakPasti =>
      semuaData.where((item) => item.status == 'Tidak Pasti').length;

  /// Menghitung jumlah kemunculan per kelas (untuk BarChart)
  int hitungPerKelas(String kelas) {
    return semuaData.where((item) => item.kelas == kelas).length;
  }

  DeteksiState copyWith({
    List<HasilDeteksi>? semuaData,
    String? filterPetak,
    bool? isDarkMode,
  }) {
    return DeteksiState(
      semuaData: semuaData ?? this.semuaData,
      filterPetak: filterPetak ?? this.filterPetak,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}

import '../models/hasil_deteksi.dart';

abstract class DeteksiEvent {
  const DeteksiEvent();
}

/// Event untuk menambahkan data hasil deteksi baru
class TambahDeteksiEvent extends DeteksiEvent {
  final HasilDeteksi data;
  const TambahDeteksiEvent(this.data);
}

/// Event untuk menghapus data hasil deteksi berdasarkan ID
class HapusDeteksiEvent extends DeteksiEvent {
  final String id;
  const HapusDeteksiEvent(this.id);
}

/// Event untuk memfilter data berdasarkan petak ('Semua', 'Petak 1', 'Petak 2')
class FilterPetakEvent extends DeteksiEvent {
  final String petak;
  const FilterPetakEvent(this.petak);
}

/// Event untuk memuat 10 data simulasi acak
class MuatDataSimulasiEvent extends DeteksiEvent {
  const MuatDataSimulasiEvent();
}

/// Event untuk menghapus seluruh data deteksi
class HapusSemuaDataEvent extends DeteksiEvent {
  const HapusSemuaDataEvent();
}

/// Event untuk mengubah mode tema terang/gelap
class ToggleTemaEvent extends DeteksiEvent {
  final bool isDarkMode;
  const ToggleTemaEvent(this.isDarkMode);
}

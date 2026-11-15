import 'package:flutter_test/flutter_test.dart';
import 'package:agrivision_cnn_707012400054_remidi/models/hasil_deteksi.dart';
import 'package:agrivision_cnn_707012400054_remidi/state/deteksi_bloc.dart';
import 'package:agrivision_cnn_707012400054_remidi/state/deteksi_event.dart';

void main() {
  group('HasilDeteksi Model & Penentuan Status (Tabel A & B)', () {
    test('Normal / Sehat selalu Sehat berapapun skornya', () {
      final data1 = HasilDeteksi(
        petak: 'Petak 1',
        kelas: 'Normal / Sehat',
        skor: 25.0,
        namaPetugas: 'Budi',
        waktu: DateTime.now(),
      );
      expect(data1.status, 'Sehat');
      expect(data1.rekomendasi, 'Lanjutkan pemantauan rutin');

      final data2 = HasilDeteksi(
        petak: 'Petak 2',
        kelas: 'Normal / Sehat',
        skor: 95.0,
        namaPetugas: 'Siti',
        waktu: DateTime.now(),
      );
      expect(data2.status, 'Sehat');
      expect(data2.rekomendasi, 'Lanjutkan pemantauan rutin');
    });

    test('Penyakit dengan skor < 50% berstatus Tidak Pasti', () {
      final data = HasilDeteksi(
        petak: 'Petak 1',
        kelas: 'Hawar daun bakteri',
        skor: 45.0,
        namaPetugas: 'Ahmad',
        waktu: DateTime.now(),
      );
      expect(data.status, 'Tidak Pasti');
      expect(data.rekomendasi, 'Cek ulang oleh petugas');
    });

    test('Penyakit dengan skor >= 50% berstatus Perlu Tindakan dengan rekomendasi penanganan', () {
      final data = HasilDeteksi(
        petak: 'Petak 2',
        kelas: 'Bercak coklat',
        skor: 85.0,
        namaPetugas: 'Joko',
        waktu: DateTime.now(),
      );
      expect(data.status, 'Perlu Tindakan');
      expect(data.rekomendasi,
          'Segera tangani: Tambah pupuk kalium, jaga sawah tetap tergenang.');
    });

    test('Fungsi buatDataSimulasi() menghasilkan 10 data dengan skor 30-99', () {
      final simulasi = buatDataSimulasi();
      expect(simulasi.length, 10);
      for (final item in simulasi) {
        expect(daftarPetak.contains(item.petak), isTrue);
        expect(daftarKelas.contains(item.kelas), isTrue);
        expect(item.skor >= 30 && item.skor <= 99, isTrue);
      }
    });
  });

  group('DeteksiBloc State Management Test', () {
    late DeteksiBloc bloc;

    setUp(() {
      bloc = DeteksiBloc();
    });

    tearDown(() {
      bloc.close();
    });

    test('Initial state kosong dan filter Semua', () {
      expect(bloc.state.semuaData, isEmpty);
      expect(bloc.state.filterPetak, 'Semua');
      expect(bloc.state.isDarkMode, isFalse);
    });

    test('Tambah dan Hapus Deteksi', () async {
      final data = HasilDeteksi(
        id: 'test_1',
        petak: 'Petak 1',
        kelas: 'Penyakit blas (jamur)',
        skor: 75.0,
        namaPetugas: 'Budi',
        waktu: DateTime.now(),
      );

      bloc.add(TambahDeteksiEvent(data));
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.semuaData.length, 1);
      expect(bloc.state.totalPerluTindakan, 1);

      bloc.add(const HapusDeteksiEvent('test_1'));
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.semuaData, isEmpty);
    });

    test('Filter Petak berfungsi dengan benar', () async {
      final data1 = HasilDeteksi(
        petak: 'Petak 1',
        kelas: 'Normal / Sehat',
        skor: 90.0,
        namaPetugas: 'Budi',
        waktu: DateTime.now(),
      );
      final data2 = HasilDeteksi(
        petak: 'Petak 2',
        kelas: 'Penyakit tungro (virus)',
        skor: 80.0,
        namaPetugas: 'Siti',
        waktu: DateTime.now(),
      );

      bloc.add(TambahDeteksiEvent(data1));
      bloc.add(TambahDeteksiEvent(data2));
      await Future.delayed(const Duration(milliseconds: 50));

      expect(bloc.state.dataTerfilter.length, 2);

      bloc.add(const FilterPetakEvent('Petak 1'));
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.dataTerfilter.length, 1);
      expect(bloc.state.dataTerfilter.first.petak, 'Petak 1');

      bloc.add(const FilterPetakEvent('Petak 2'));
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.dataTerfilter.length, 1);
      expect(bloc.state.dataTerfilter.first.petak, 'Petak 2');
    });

    test('Muat Simulasi dan Hapus Semua Data', () async {
      bloc.add(const MuatDataSimulasiEvent());
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.totalSemua, 10);

      bloc.add(const HapusSemuaDataEvent());
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.totalSemua, 0);
    });

    test('Toggle Mode Gelap', () async {
      expect(bloc.state.isDarkMode, isFalse);
      bloc.add(const ToggleTemaEvent(true));
      await Future.delayed(const Duration(milliseconds: 50));
      expect(bloc.state.isDarkMode, isTrue);
    });
  });
}

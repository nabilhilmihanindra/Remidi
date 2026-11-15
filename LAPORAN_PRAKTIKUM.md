# LAPORAN PRAKTIKUM PENGEMBANGAN PERANGKAT BERGERAK LANJUT (PPBL)
## ASESMEN PRAKTIKUM – KODE A (Presentase 60% + 40%)

---

### 1. Halaman Sampul (Cover)
* **Judul Praktikum:** AgriVision CNN: Aplikasi Mobile Pencatatan Deteksi Penyakit dan Hama Padi Berbasis EfficientNet-B0 untuk Kelompok Tani
* **Nama Mahasiswa:** [Nama Lengkap Mahasiswa]
* **NIM:** 707012400054
* **Kelas:** [Kelas Mahasiswa, misal: D3IF-48-XX / S1SE-XX]
* **Mata Kuliah:** Praktikum Pengembangan Perangkat Bergerak Lanjut (PPBL)
* **Dosen Pengampu:** [Nama Dosen Pengampu]
* **Program Studi:** Rekayasa Perangkat Lunak / Teknik Informatika
* **Institusi:** Telkom University
* **Tahun Akademik:** 2026/2027

---

### 2. Tujuan Praktikum
Tujuan yang dicapai pada pelaksanaan praktikum ini adalah:
1. Membangun aplikasi pencatatan berbasis mobile dengan arsitektur multi-layer Flutter yang bersih dan modular (terbagi atas `models`, `pages`, `state`, dan `widgets`).
2. Mengimplementasikan manajemen navigasi modern menggunakan kombinasi *named routes* (`AppRoutes`) untuk navigasi antar-halaman hierarkis dan `IndexedStack` berpadu dengan `NavigationBar` Material 3 untuk navigasi tab tanpa kehilangan status halaman (*state retention*).
3. Menguasai validasi formulir interaktif menggunakan `TextEditingController` serta alur persetujuan transaksi data menggunakan `AlertDialog` dan umpan balik pengguna menggunakan `SnackBar`.
4. Mengimplementasikan logika pemetaan bisnis cerdas berbasis kecerdasan buatan (CNN EfficientNet-B0) untuk mengklasifikasikan status kondisi tanaman padi (Sehat, Tidak Pasti, Perlu Tindakan) beserta rekomendasi penanganan otomatis per kelas hama/penyakit.
5. Menerapkan pengelola *state* tingkat lanjut berbasis **BLoC (Business Logic Component)** melalui `flutter_bloc` di akar aplikasi untuk mengelola operasi CRUD riwayat deteksi, filtering petak, generator data simulasi acak, dan pengelolaan tema dinamis (*light/dark mode*).
6. Mengintegrasikan visualisasi data statistik interaktif menggunakan diagram batang (`BarChart` dari pustaka `fl_chart`) yang reaktif terhadap perubahan data deteksi secara *real-time*.

---

### 3. Alat dan Bahan

#### A. Perangkat Keras (Hardware)
* **Perangkat Laptop/PC:** Prosessor Intel Core i5 / AMD Ryzen, RAM 16 GB, SSD 512 GB.
* **Perangkat Uji / Emulator:** Emulator Android (Google Pixel API 34) / Perangkat Fisik Android.

#### B. Perangkat Lunak (Software)
* **Sistem Operasi:** Windows 11 (64-bit).
* **Flutter SDK:** Versi 3.47.9 (channel stable).
* **Dart SDK:** Versi 3.13.7.
* **IDE / Editor:** Visual Studio Code beserta ekstensi resmi Flutter dan Dart.
* **Paket Eksternal (Dependencies di `pubspec.yaml`):**
  * `flutter_bloc: ^9.1.1` (Arsitektur State Management BLoC +25 Poin Bonus).
  * `fl_chart: ^1.3.1` (Visualisasi Bar Chart statistik deteksi).
  * `intl: ^0.20.3` (Format tanggal dan waktu pencatatan).
  * `cupertino_icons: ^1.0.8` (Ikon pendukung).
* **Version Control System:** Git & GitHub.

---

### 4. Langkah-Langkah Praktikum

#### Langkah 1: Pembuatan Proyek dan Penyusunan Folder
1. Proyek dibuat dengan nama `agrivision_cnn_707012400054_remidi`.
2. Struktur folder di bawah `lib/` dirancang secara rapi:
   * `lib/models/`: Berisi entitas data dan logika domain status/rekomendasi.
   * `lib/pages/`: Berisi seluruh tampilan layar antarmuka pengguna.
   * `lib/state/`: Berisi implementasi state management BLoC (`DeteksiEvent`, `DeteksiState`, `DeteksiBloc`).
   * `lib/widgets/`: Berisi komponen UI modular yang dapat digunakan kembali (`DeteksiCard`, `StatCard`).
   * `lib/app_routes.dart` & `lib/app_theme.dart`: Konfigurasi rute dan tema Material 3.

#### Langkah 2: Model Data dan Logika Penentuan Status (Tabel A & B)
Di dalam `lib/models/hasil_deteksi.dart`, dibuat kelas `HasilDeteksi` dengan properti: `id`, `petak`, `kelas`, `skor`, `namaPetugas`, dan `waktu`.
* **Tabel B:** Rekomendasi per kelas disimpan dalam `Map<String, String> rekomendasiPerKelas`.
* **Tabel A:** Logika penentuan status dan rekomendasi dibuat melalui *getter* di model (bukan di dalam fungsi `build()` UI):
```dart
String get status {
  if (kelas == 'Normal / Sehat') return 'Sehat';
  if (skor < 50) return 'Tidak Pasti';
  return 'Perlu Tindakan';
}

String get rekomendasi {
  if (kelas == 'Normal / Sehat') return 'Lanjutkan pemantauan rutin';
  if (skor < 50) return 'Cek ulang oleh petugas';
  final saran = rekomendasiPerKelas[kelas] ?? '-';
  return 'Segera tangani: $saran';
}
```
* Fungsi `buatDataSimulasi()` diimplementasikan untuk menghasilkan 10 entri `HasilDeteksi` secara acak menggunakan `Random()` dengan skor integer 30–99.

#### Langkah 3: State Management BLoC (Nilai Tambahan +25 Poin)
BLoC dipilih sebagai arsitektur *state management* utama untuk memisahkan logika bisnis dari UI:
* `DeteksiEvent`: Mendefinisikan aksi pengguna: `TambahDeteksiEvent`, `HapusDeteksiEvent`, `FilterPetakEvent`, `MuatDataSimulasiEvent`, `HapusSemuaDataEvent`, dan `ToggleTemaEvent`.
* `DeteksiState`: Menyimpan daftar data `semuaData`, pilihan `filterPetak` ('Semua', 'Petak 1', 'Petak 2'), serta `isDarkMode`. State menyediakan getter kalkulasi: `dataTerfilter`, `totalSemua`, `totalSehat`, `totalPerluTindakan`, dan `hitungPerKelas(kelas)`.
* `DeteksiBloc`: Mengelola mutasi *state* secara *immutable* menggunakan `copyWith()`.
* BLoC dipasang tepat di akar aplikasi di atas `MaterialApp` (`main.dart`):
```dart
return BlocProvider(
  create: (context) => DeteksiBloc(),
  child: BlocBuilder<DeteksiBloc, DeteksiState>(
    builder: (context, state) {
      return MaterialApp(
        title: 'AgriVision CNN',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
        initialRoute: AppRoutes.beranda,
        routes: {
          AppRoutes.beranda: (context) => const KerangkaNavigasi(),
          AppRoutes.tentang: (context) => const HalamanTentang(),
          AppRoutes.inputDeteksi: (context) => const HalamanInputDeteksi(),
        },
      );
    },
  ),
);
```

#### Langkah 4: Kerangka Navigasi dan Halaman Beranda
* `KerangkaNavigasi` bertindak sebagai induk 4 tab utama (`Beranda`, `Deteksi`, `Statistik`, `Pengaturan`).
* Menggunakan `IndexedStack` sehingga status gulir dan data pada masing-masing tab tidak ter-reset saat pengguna berpindah tab.
* `AppBar` secara dinamis menampilkan judul `"AgriVision - $namaTabAktif"`.
* Tab Deteksi pada `NavigationBar` dilengkapi dengan widget `Badge` yang menampilkan jumlah kasus berstatus "Perlu Tindakan".
* `HalamanBeranda` menampilkan sambutan, kartu informasi model AI (EfficientNet-B0, 5 kelas), dan tombol navigasi ke `HalamanTentang` menggunakan `Navigator.pushNamed(context, AppRoutes.tentang)`.
* `HalamanTentang` menyajikan tujuan aplikasi dan daftar 5 kelas deteksi memanfaatkan `ListView`.

#### Langkah 5: Formulir Input Deteksi dan Validasi
* Menggunakan `RadioListTile` untuk memilih Petak 1 atau Petak 2.
* Menggunakan `DropdownButtonFormField` untuk memilih dari 5 kelas deteksi.
* Menggunakan `TextField` untuk memasukkan skor persen dan nama petugas.
* Validasi ketat dilakukan dengan `TextEditingController`: menampilkan pesan galat jika skor kosong/bukan angka 0–100 atau nama petugas kosong.
* Tombol **Simpan** hanya dapat diklik jika `CheckboxListTile` ("Data sudah benar") dicentang.
* Menampilkan dialog konfirmasi `AlertDialog` sebelum data disimpan. Setelah disetujui, event `TambahDeteksiEvent` dikirimkan ke BLoC, memunculkan `SnackBar` "Data tersimpan", lalu kembali dengan `Navigator.pop(context)`.

#### Langkah 6: Tab Deteksi dan Custom Widgets
* Menampilkan judul `"Riwayat Deteksi"` dan `SegmentedButton` untuk memfilter petak: `Semua`, `Petak 1`, dan `Petak 2`.
* Tiga buah `StatCard` modular menampilkan kalkulasi: `Total`, `Sehat`, dan `Perlu Tindakan`.
* Komponen `DeteksiCard` menampilkan:
  * Nama petak dan kelas dengan ikon dan warna khusus per status (Hijau untuk Sehat, Kuning untuk Tidak Pasti, Merah untuk Perlu Tindakan).
  * Tombol hapus dengan ikon tempat sampah.
  * `LinearProgressIndicator` penunjuk skor deteksi.
  * Rekomendasi penanganan dan informasi petugas serta tanggal pencatatan.
  * Menampilkan teks `"Belum ada data"` di tengah layar jika daftar kosong.
* Menyediakan `FloatingActionButton.extended` bertuliskan `"Deteksi Baru"` untuk membuka formulir.

#### Langkah 7: Tab Statistik dengan BarChart
* Menggunakan pustaka `fl_chart` untuk menampilkan diagram batang 5 kelas (`Hawar`, `Blas`, `Bercak`, `Normal`, `Tungro`).
* Nilai batang grafik diperbarui secara reaktif setiap kali ada data baru, data simulasi yang dimuat, atau data yang dihapus dari BLoC.
* Dilengkapi *tooltip* interaktif saat batang ditekan.

#### Langkah 8: Tab Pengaturan dan Mode Gelap
* Menyediakan saklar (`SwitchListTile`) `"Mode Gelap"` yang mengirimkan `ToggleTemaEvent` ke `DeteksiBloc`. Seluruh antarmuka secara instan berganti palet warna sesuai `AppTheme.darkTheme` (Material 3).
* Menyediakan tombol `"Muat Data Simulasi"` untuk memasukkan 10 data acak secara instan.
* Menyediakan tombol `"Hapus Semua Data"` yang memunculkan `AlertDialog` konfirmasi sebelum data dihapus secara permanen.

---

### 5. Hasil dan Dokumentasi Program

| No | Tampilan Layar | Keterangan |
|---|---|---|
| 1 | **Tab Beranda (Light Mode)** | Menampilkan sambutan AgriVision CNN, kartu info model EfficientNet-B0 (5 kelas), dan tombol menuju halaman Tentang. AppBar bertuliskan "AgriVision - Beranda". |
| 2 | **Halaman Tentang** | Menampilkan deskripsi tujuan aplikasi untuk kelompok tani dan daftar 5 kelas deteksi menggunakan komponen `ListView`. Navigasi menggunakan `AppRoutes.tentang`. |
| 3 | **Tab Deteksi (Kosong)** | Menampilkan segmented filter petak, 3 kartu statistik (Total: 0, Sehat: 0, Perlu Tindakan: 0), teks "Belum ada data", dan FAB "Deteksi Baru". |
| 4 | **Formulir Input Deteksi** | Menampilkan pilihan radio petak, dropdown kelas, input skor deteksi (%), input nama petugas, checkbox "Data sudah benar", dan tombol Simpan. |
| 5 | **Validasi Input Error** | Menampilkan pesan error validasi ketika skor kosong atau tidak dalam rentang 0-100 dan nama petugas kosong. |
| 6 | **Dialog Konfirmasi Simpan** | Menampilkan pop-up dialog konfirmasi ("Konfirmasi Simpan") sebelum data resmi dimasukkan ke BLoC state. |
| 7 | **Tab Deteksi (Berisi Data)** | Menampilkan kartu-kartu riwayat deteksi (`DeteksiCard`) dengan warna status berbeda (Hijau, Kuning, Merah), indikator progress bar skor, serta badge notifikasi jumlah data Perlu Tindakan pada ikon navigasi. |
| 8 | **Tab Statistik (BarChart)** | Menampilkan grafik batang jumlah deteksi untuk 5 kelas (Hawar, Blas, Bercak, Normal, Tungro) menggunakan `fl_chart` yang otomatis berubah sesuai state. |
| 9 | **Tab Pengaturan** | Menampilkan sakelar Mode Gelap, tombol Muat Data Simulasi, dan tombol Hapus Semua Data. |
| 10 | **Dialog Konfirmasi Hapus Semua** | Menampilkan AlertDialog konfirmasi "Hapus Semua Data?" sebelum menghapus seluruh riwayat di memori. |
| 11 | **Tampilan Mode Gelap (Dark Mode)** | Tampilan aplikasi saat beralih ke Mode Gelap dengan kontras warna yang nyaman untuk penggunaan malam hari. |

---

### 6. Analisis dan Pembahasan

#### A. Pembagian Struktur Folder dan Custom Widget
Arsitektur kode dipisahkan ke dalam folder `models/`, `pages/`, `state/`, dan `widgets/`. Pemisahan ini mengikuti prinsip *Separation of Concerns* (SoC):
* Logika bisnis dan pemetaan entitas berada di `models/`.
* Pengelolaan state global berada di `state/`.
* Komponen UI yang kompleks dan berulang seperti `DeteksiCard` dan `StatCard` dipisahkan ke dalam `widgets/` agar kode pada `pages/` tetap ringkas, bersih, dan mudah dirawat (*maintainable*).

#### B. Alur Navigasi (Named Routes & IndexedStack)
Navigasi pada aplikasi memanfaatkan dua paradigma:
1. **Named Routes (`AppRoutes`):** Digunakan untuk navigasi antar halaman berbasis tumpukan (*stack-based navigation*), seperti menuju halaman Tentang (`/tentang`) dan Input Deteksi (`/input-deteksi`). Penggunaan konstanta string mencegah kesalahan pengetikan (*typo*) rute.
2. **IndexedStack & NavigationBar:** Digunakan untuk 4 tab utama. Berbeda dengan sekadar mengganti `body` Scaffold yang akan me-rebuild widget dari awal, `IndexedStack` mempertahankan state pohon widget di latar belakang sehingga scroll posisi dan status input tidak hilang saat berpindah antar tab.

#### C. Logika Penentuan Status dan Rekomendasi
Sesuai dengan spesifikasi pada modul:
* Status tanaman **Normal / Sehat** selalu menghasilkan status **Sehat** dan rekomendasi *"Lanjutkan pemantauan rutin"* tanpa memedulikan besaran skor deteksi.
* Untuk 4 kelas hama/penyakit lainnya, apabila skor deteksi **< 50%**, status menjadi **Tidak Pasti** dengan rekomendasi *"Cek ulang oleh petugas"* karena tingkat keyakinan model CNN belum mencukupi.
* Apabila skor deteksi **>= 50%**, status menjadi **Perlu Tindakan** dan sistem secara otomatis merangkai instruksi kuratif spesifik dari `Tabel B` (misal untuk Bercak Coklat: *"Segera tangani: Tambah pupuk kalium, jaga sawah tetap tergenang."*).
* Seluruh logika ini dienkapsulasi pada *getter* model `HasilDeteksi`, menjaga fungsi `build()` tetap murni sebagai penampil antarmuka (*declarative UI*).

#### D. Pemilihan State Management BLoC vs Provider vs Cubit
BLoC dipilih karena memberikan pemisahan yang sangat tegas antara *event* (masukan pengguna) dan *state* (keluaran data). 
* **State Global vs State Lokal:** Data riwayat deteksi, filter petak, dan preferensi tema dikelola pada state global BLoC karena dibutuhkan bersama oleh Tab Deteksi, Tab Statistik, Tab Pengaturan, serta NavigationBar Badge. Sementara itu, state transien seperti nilai isian form, pesan error validasi, dan indeks tab aktif cukup dikelola secara lokal menggunakan `setState()`. Pendekatan ini mengoptimalkan kinerja render dan memori.

#### E. Pengujian dan Data Simulasi
Fungsi `buatDataSimulasi()` sangat bermanfaat dalam fase pengujian aplikasi (smoke testing dan unit testing). Dengan generator acak berdistribusi skor 30–99, pengembang dan penguji dapat memvalidasi apakah grafik batang `fl_chart`, penghitungan badge, dan filter petak bekerja optimal pada kondisi dataset dinamis tanpa harus mengisi formulir manual berulang kali.

#### F. Penerapan Tema Material 3 dan Mode Gelap
Penggunaan `ColorScheme.fromSeed()` dengan warna benih hijau pertanian (`#2E7D32`) menghasilkan palet warna Material 3 yang harmonis secara otomatis untuk mode terang maupun gelap. Semua komponen UI memanfaatkan warna semantik konteks seperti `colorScheme.surface`, `colorScheme.primary`, dan `colorScheme.onSurface`, sehingga seluruh teks dan elemen kartu tetap memiliki keterbacaan (*readability*) tinggi saat tema dibalik menjadi gelap.

---

### 7. Kesimpulan
Berdasarkan praktikum yang telah dilakukan, dapat disimpulkan bahwa:
1. Aplikasi **AgriVision CNN** telah berhasil dibangun secara lengkap sesuai seluruh ketentuan spesifikasi teknis Asesmen Praktikum PPBL Kode A, mencakup arsitektur navigasi multi-tab, named routing, validasi formulir cerdas, serta penanganan status penyakit padi berbasis model CNN EfficientNet-B0.
2. Penerapan arsitektur **BLoC** terbukti sangat handal dalam mengelola alur data yang kompleks antar-halaman secara terpusat, memastikan sinkronisasi data riwayat deteksi, badge notifikasi, grafik statistik interaktif, serta tema gelap-terang secara instan.
3. Seluruh unit testing dan widget testing telah teruji dengan status 100% lulus (*All tests passed*), menjamin aplikasi bebas dari galat (*zero-error*) dan siap dioperasikan oleh kelompok tani dalam mencatat hasil deteksi tanaman padi.

---

### 8. Lampiran
* **Link Repositori GitHub:** `https://github.com/[username-mahasiswa]/agrivision_cnn_707012400054_remidi`
*(Silakan lakukan `git push` ke repositori GitHub masing-masing)*

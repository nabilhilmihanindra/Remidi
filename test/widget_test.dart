import 'package:flutter_test/flutter_test.dart';
import 'package:agrivision_cnn_707012400054_remidi/main.dart';

void main() {
  testWidgets('AgriVision CNN App Smoke Test and Navigation',
      (WidgetTester tester) async {
    // Jalankan aplikasi
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Pastikan berada di tab Beranda
    expect(find.text('AgriVision - Beranda'), findsOneWidget);
    expect(find.text('Selamat Datang di AgriVision CNN'), findsOneWidget);
    expect(find.text('Model: EfficientNet-B0'), findsOneWidget);

    // Tekan tombol Tentang Aplikasi
    await tester.tap(find.text('Tentang Aplikasi'));
    await tester.pumpAndSettle();

    // Verifikasi berada di HalamanTentang
    expect(find.text('Tentang Aplikasi'), findsWidgets);
    expect(find.text('Tujuan Aplikasi'), findsOneWidget);
    expect(find.text('Daftar 5 Kelas Deteksi'), findsOneWidget);
    expect(find.text('Hawar daun bakteri'), findsOneWidget);

    // Kembali ke beranda
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.text('Selamat Datang di AgriVision CNN'), findsOneWidget);

    // Pindah ke Tab Deteksi (ikon ke-2 di NavigationBar)
    await tester.tap(find.text('Deteksi'));
    await tester.pumpAndSettle();

    expect(find.text('AgriVision - Deteksi'), findsOneWidget);
    expect(find.text('Riwayat Deteksi'), findsOneWidget);
    expect(find.text('Belum ada data'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('Sehat'), findsOneWidget);
    expect(find.text('Perlu Tindakan'), findsOneWidget);

    // Pindah ke Tab Pengaturan
    await tester.tap(find.text('Pengaturan'));
    await tester.pumpAndSettle();

    expect(find.text('AgriVision - Pengaturan'), findsOneWidget);
    expect(find.text('Mode Gelap'), findsOneWidget);
    expect(find.text('Muat Data Simulasi'), findsOneWidget);
    expect(find.text('Hapus Semua Data'), findsOneWidget);

    // Muat data simulasi
    await tester.tap(find.text('Muat Data Simulasi'));
    await tester.pumpAndSettle();

    // Kembali ke tab Deteksi untuk memeriksa data
    await tester.tap(find.text('Deteksi'));
    await tester.pumpAndSettle();

    // Sekarang tidak lagi "Belum ada data"
    expect(find.text('Belum ada data'), findsNothing);
    expect(find.text('10'), findsWidgets); // Total = 10
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:agrivision_cnn_707012400054_remidi/state/deteksi_bloc.dart';
import 'package:agrivision_cnn_707012400054_remidi/pages/halaman_input_deteksi.dart';

void main() {
  testWidgets('Form Input Deteksi Validasi dan Konfirmasi Dialog',
      (WidgetTester tester) async {
    final bloc = DeteksiBloc();

    await tester.pumpWidget(
      BlocProvider<DeteksiBloc>.value(
        value: bloc,
        child: const MaterialApp(
          home: HalamanInputDeteksi(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // Pastikan tombol Simpan dinonaktifkan saat Checkbox belum dicentang
    final simpanButtonFinder = find.widgetWithText(FilledButton, 'Simpan');
    expect(simpanButtonFinder, findsOneWidget);
    FilledButton button = tester.widget<FilledButton>(simpanButtonFinder);
    expect(button.onPressed, isNull);

    // Centang Checkbox "Data sudah benar"
    await tester.tap(find.text('Data sudah benar'));
    await tester.pumpAndSettle();

    // Sekarang tombol Simpan aktif
    button = tester.widget<FilledButton>(simpanButtonFinder);
    expect(button.onPressed, isNotNull);

    // Coba tekan Simpan dengan input kosong -> Muncul pesan error
    await tester.tap(simpanButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Skor deteksi tidak boleh kosong'), findsOneWidget);
    expect(find.text('Nama petugas tidak boleh kosong'), findsOneWidget);

    // Masukkan skor di luar rentang (misal 150)
    final textFields = find.byType(TextField);
    await tester.enterText(textFields.at(0), '150');
    await tester.enterText(textFields.at(1), 'Budi');
    await tester.pumpAndSettle();

    await tester.tap(simpanButtonFinder);
    await tester.pumpAndSettle();

    expect(find.text('Skor harus berupa angka 0–100'), findsOneWidget);

    // Masukkan input yang valid (skor 85, petugas Budi)
    await tester.enterText(textFields.at(0), '85');
    await tester.pumpAndSettle();

    await tester.tap(simpanButtonFinder);
    await tester.pumpAndSettle();

    // Muncul AlertDialog konfirmasi
    expect(find.text('Konfirmasi Simpan'), findsOneWidget);
    expect(find.text('Batal'), findsOneWidget);
    expect(find.widgetWithText(FilledButton, 'Simpan'), findsWidgets);

    // Tekan Simpan di dialog
    final dialogSimpanButton = find.descendant(
      of: find.byType(AlertDialog),
      matching: find.text('Simpan'),
    );
    await tester.tap(dialogSimpanButton);
    await tester.pumpAndSettle();

    // Periksa apakah data masuk ke BLoC
    expect(bloc.state.semuaData.length, 1);
    expect(bloc.state.semuaData.first.skor, 85.0);
    expect(bloc.state.semuaData.first.namaPetugas, 'Budi');
    expect(bloc.state.semuaData.first.status, 'Perlu Tindakan');

    bloc.close();
  });
}

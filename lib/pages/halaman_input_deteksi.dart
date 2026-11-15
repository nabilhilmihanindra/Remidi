import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/hasil_deteksi.dart';
import '../state/deteksi_bloc.dart';
import '../state/deteksi_event.dart';

class HalamanInputDeteksi extends StatefulWidget {
  const HalamanInputDeteksi({super.key});

  @override
  State<HalamanInputDeteksi> createState() => _HalamanInputDeteksiState();
}

class _HalamanInputDeteksiState extends State<HalamanInputDeteksi> {
  final _formKey = GlobalKey<FormState>();

  String _petak = daftarPetak.first;
  String _kelas = daftarKelas.first;
  final TextEditingController _skorController = TextEditingController();
  final TextEditingController _petugasController = TextEditingController();
  bool _dataSudahBenar = false;

  String? _skorError;
  String? _petugasError;

  @override
  void dispose() {
    _skorController.dispose();
    _petugasController.dispose();
    super.dispose();
  }

  bool _validasiForm() {
    bool valid = true;
    final skorText = _skorController.text.trim();
    final petugasText = _petugasController.text.trim();

    // Validasi skor deteksi (harus angka 0 - 100)
    if (skorText.isEmpty) {
      _skorError = 'Skor deteksi tidak boleh kosong';
      valid = false;
    } else {
      final skor = double.tryParse(skorText);
      if (skor == null || skor < 0 || skor > 100) {
        _skorError = 'Skor harus berupa angka 0–100';
        valid = false;
      } else {
        _skorError = null;
      }
    }

    // Validasi nama petugas (tidak boleh kosong)
    if (petugasText.isEmpty) {
      _petugasError = 'Nama petugas tidak boleh kosong';
      valid = false;
    } else {
      _petugasError = null;
    }

    setState(() {});
    return valid;
  }

  void _tampilkanDialogKonfirmasi() {
    if (!_validasiForm()) return;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Konfirmasi Simpan'),
          content: const Text(
            'Apakah Anda yakin data deteksi sudah benar dan ingin menyimpannya?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Batal'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                _simpanData();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _simpanData() {
    final double skor = double.parse(_skorController.text.trim());
    final String petugas = _petugasController.text.trim();

    final dataBaru = HasilDeteksi(
      petak: _petak,
      kelas: _kelas,
      skor: skor,
      namaPetugas: petugas,
      waktu: DateTime.now(),
    );

    // Simpan ke state pengelola di akar aplikasi (DeteksiBloc)
    context.read<DeteksiBloc>().add(TambahDeteksiEvent(dataBaru));

    // Tampilkan SnackBar
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data tersimpan'),
        duration: Duration(seconds: 2),
      ),
    );

    // Kembali ke halaman sebelumnya
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Input Deteksi'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian Petak
              Text(
                'Petak',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 4),
              // ignore: deprecated_member_use
              RadioListTile<String>(
                title: const Text('Petak 1'),
                value: 'Petak 1',
                // ignore: deprecated_member_use
                groupValue: _petak,
                contentPadding: EdgeInsets.zero,
                // ignore: deprecated_member_use
                onChanged: (val) {
                  if (val != null) setState(() => _petak = val);
                },
              ),
              // ignore: deprecated_member_use
              RadioListTile<String>(
                title: const Text('Petak 2'),
                value: 'Petak 2',
                // ignore: deprecated_member_use
                groupValue: _petak,
                contentPadding: EdgeInsets.zero,
                // ignore: deprecated_member_use
                onChanged: (val) {
                  if (val != null) setState(() => _petak = val);
                },
              ),
              const SizedBox(height: 12),

              // Bagian Kelas
              DropdownButtonFormField<String>(
                initialValue: _kelas,
                decoration: const InputDecoration(
                  labelText: 'Kelas',
                  border: OutlineInputBorder(),
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                ),
                items: daftarKelas.map((kelas) {
                  return DropdownMenuItem<String>(
                    value: kelas,
                    child: Text(kelas),
                  );
                }).toList(),
                onChanged: (val) {
                  if (val != null) setState(() => _kelas = val);
                },
              ),
              const SizedBox(height: 16),

              // Bagian Skor Deteksi (%)
              TextField(
                controller: _skorController,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: 'Skor Deteksi (%)',
                  border: const OutlineInputBorder(),
                  errorText: _skorError,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                ),
                onChanged: (val) {
                  if (_skorError != null) {
                    setState(() => _skorError = null);
                  }
                },
              ),
              const SizedBox(height: 16),

              // Bagian Nama Petugas
              TextField(
                controller: _petugasController,
                decoration: InputDecoration(
                  labelText: 'Nama Petugas',
                  border: const OutlineInputBorder(),
                  errorText: _petugasError,
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 14),
                ),
                onChanged: (val) {
                  if (_petugasError != null) {
                    setState(() => _petugasError = null);
                  }
                },
              ),
              const SizedBox(height: 16),

              // CheckboxListTile "Data sudah benar"
              CheckboxListTile(
                title: const Text('Data sudah benar'),
                value: _dataSudahBenar,
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.trailing,
                onChanged: (val) {
                  setState(() {
                    _dataSudahBenar = val ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Tombol Simpan
              SizedBox(
                width: double.infinity,
                height: 48,
                child: FilledButton(
                  onPressed:
                      _dataSudahBenar ? _tampilkanDialogKonfirmasi : null,
                  child: const Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

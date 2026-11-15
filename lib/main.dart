import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_routes.dart';
import 'app_theme.dart';
import 'pages/halaman_input_deteksi.dart';
import 'pages/halaman_tentang.dart';
import 'pages/kerangka_navigasi.dart';
import 'state/deteksi_bloc.dart';
import 'state/deteksi_state.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Pengelola state (DeteksiBloc) dipasang di atas MaterialApp
    return BlocProvider(
      create: (context) => DeteksiBloc(),
      child: BlocBuilder<DeteksiBloc, DeteksiState>(
        builder: (context, state) {
          return MaterialApp(
            title: 'AgriVision CNN',
            debugShowCheckedModeBanner: false,
            // Konfigurasi tema terang dan gelap
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            // Konfigurasi route menggunakan AppRoutes
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
  }
}

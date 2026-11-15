import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../state/deteksi_bloc.dart';
import '../state/deteksi_state.dart';
import 'halaman_beranda.dart';
import 'halaman_deteksi.dart';
import 'halaman_pengaturan.dart';
import 'halaman_statistik.dart';

class KerangkaNavigasi extends StatefulWidget {
  const KerangkaNavigasi({super.key});

  @override
  State<KerangkaNavigasi> createState() => _KerangkaNavigasiState();
}

class _KerangkaNavigasiState extends State<KerangkaNavigasi> {
  int _currentIndex = 0;

  final List<String> _tabTitles = const [
    'Beranda',
    'Deteksi',
    'Statistik',
    'Pengaturan',
  ];

  final List<Widget> _pages = const [
    HalamanBeranda(),
    HalamanDeteksi(),
    HalamanStatistik(),
    HalamanPengaturan(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('AgriVision - ${_tabTitles[_currentIndex]}'),
      ),
      // IndexedStack agar state halaman tab tidak hilang saat berpindah
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BlocBuilder<DeteksiBloc, DeteksiState>(
        builder: (context, state) {
          final countPerluTindakan = state.totalPerluTindakan;

          return NavigationBar(
            selectedIndex: _currentIndex,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: [
              const NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Beranda',
              ),
              NavigationDestination(
                icon: countPerluTindakan > 0
                    ? Badge(
                        label: Text('$countPerluTindakan'),
                        child: const Icon(Icons.search),
                      )
                    : const Icon(Icons.search),
                label: 'Deteksi',
              ),
              const NavigationDestination(
                icon: Icon(Icons.bar_chart),
                label: 'Statistik',
              ),
              const NavigationDestination(
                icon: Icon(Icons.settings),
                label: 'Pengaturan',
              ),
            ],
          );
        },
      ),
    );
  }
}

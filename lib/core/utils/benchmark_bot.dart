import 'dart:ui' show FrameTiming;
import 'package:flutter/material.dart';

class BenchmarkBot {
  static bool isRunning = false;
  static int totalFrames = 0;
  static int jankFrames = 0;
  static double totalBuildDurationMs = 0;

  static Future<void> runAutomatedTest({
    required BuildContext context,
    required ScrollController scrollController,
    required Function(String category) onFilterCategory,
    required VoidCallback onOpenCart,
  }) async {
    if (isRunning) return;
    isRunning = true;

    // Reset Statistik
    totalFrames = 0;
    jankFrames = 0;
    totalBuildDurationMs = 0;

    // Pasang Pendeteksi Frame Jank Otomatis
    void timingCallback(List<FrameTiming> timings) {
      for (final timing in timings) {
        totalFrames++;
        final durationMs = timing.totalSpan.inMicroseconds / 1000.0;
        totalBuildDurationMs += durationMs;

        // Jika render frame lebih dari 16.6ms (batas 60 FPS), hitung sebagai JANK!
        if (durationMs > 16.6) {
          jankFrames++;
        }
      }
    }

    WidgetsBinding.instance.addTimingsCallback(timingCallback);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('🤖 Benchmark Otomatis Dimulai... Jangan sentuh layar!'),
        duration: Duration(seconds: 2),
        backgroundColor: Colors.orange,
      ),
    );

    await Future.delayed(const Duration(seconds: 1));

    // AKSI 1: Scroll ke Bawah
    if (scrollController.hasClients) {
      await scrollController.animateTo(
        2500.0,
        duration: const Duration(seconds: 3),
        curve: Curves.easeInOut,
      );
    }
    await Future.delayed(const Duration(milliseconds: 400));

    // AKSI 2: Scroll Balik ke Atas
    if (scrollController.hasClients) {
      await scrollController.animateTo(
        0.0,
        duration: const Duration(seconds: 3),
        curve: Curves.easeInOut,
      );
    }
    await Future.delayed(const Duration(milliseconds: 400));

    // AKSI 3: Filter Kategori
    onFilterCategory('groceries');
    await Future.delayed(const Duration(milliseconds: 600));

    onFilterCategory('beauty');
    await Future.delayed(const Duration(milliseconds: 600));

    onFilterCategory('Semua');
    await Future.delayed(const Duration(milliseconds: 600));

    // AKSI 4: Buka Keranjang
    onOpenCart();
    await Future.delayed(const Duration(milliseconds: 2500));

    // AKSI 5: Kembali ke Beranda
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    }

    // Lepas Callback Timings
    WidgetsBinding.instance.removeTimingsCallback(timingCallback);
    isRunning = false;

    // HITUNG STATISTIK AKHIR
    final avgDuration = totalFrames > 0
        ? (totalBuildDurationMs / totalFrames).toStringAsFixed(2)
        : '0';
    final smoothnessRate = totalFrames > 0
        ? (((totalFrames - jankFrames) / totalFrames) * 100).toStringAsFixed(1)
        : '100';

    // CETAK REKAPITULASI RESMI DI TERMINAL VS CODE
    debugPrint('\n==================================================');
    debugPrint('📊 HASIL PENGUJIAN OTOMATIS (BENCHMARK REPORT)');
    debugPrint('--------------------------------------------------');
    debugPrint('Total Frame Dirender   : $totalFrames frame');
    debugPrint('Total Frame Jank (Drop): $jankFrames frame');
    debugPrint('Persentase Mulus (60FPS): $smoothnessRate %');
    debugPrint('Rata-rata Waktu Render : $avgDuration ms / frame');
    debugPrint('==================================================\n');

    // Tampilkan juga di layar HP
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '✅ Selesai! Total Jank: $jankFrames dari $totalFrames frames.',
        ),
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.green,
      ),
    );
  }
}

class LoanCalculator {
  // Aturan bisnis: Bunga 2% per bulan dan Biaya Admin tetap
  static const double bungaPerBulan = 0.02; 
  static const double biayaAdminTetap = 50000.0;

  static double hitungTotalBunga(double pokok, int tenorBulan) {
    return pokok * bungaPerBulan * tenorBulan;
  }

  static double hitungTotalBayar(double pokok, int tenorBulan) {
    final totalBunga = hitungTotalBunga(pokok, tenorBulan);
    return pokok + totalBunga + biayaAdminTetap;
  }

  static double hitungCicilanPerBulan(double pokok, int tenorBulan) {
    final totalBayar = hitungTotalBayar(pokok, tenorBulan);
    return totalBayar / tenorBulan;
  }
}
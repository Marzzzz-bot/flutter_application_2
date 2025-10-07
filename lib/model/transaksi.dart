class Transaksi {
  final String id;
  final String barangId;
  final String jenis; // "masuk" atau "keluar"
  final int jumlah;
  final DateTime tanggal;

  Transaksi({
    required this.id,
    required this.barangId,
    required this.jenis,
    required this.jumlah,
    required this.tanggal,
  });

  // Dari JSON ke Transaksi
  factory Transaksi.fromJson(Map<String, dynamic> json) {
    return Transaksi(
      id: json['id'],
      barangId: json['barangId'],
      jenis: json['jenis'],
      jumlah: json['jumlah'],
      tanggal: DateTime.parse(json['tanggal']),
    );
  }

  // Dari Transaksi ke JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barangId': barangId,
      'jenis': jenis,
      'jumlah': jumlah,
      'tanggal': tanggal.toIso8601String(),
    };
  }
}

class Supplier {
  final String id;
  final String nama;
  final String kontak;

  Supplier({required this.id, required this.nama, required this.kontak});

  factory Supplier.fromJson(Map<String, dynamic> json) {
    return Supplier(id: json['id'], nama: json['nama'], kontak: json['kontak']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'kontak': kontak};
  }
}

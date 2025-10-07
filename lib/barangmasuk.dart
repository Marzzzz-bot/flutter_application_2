import 'package:flutter/material.dart';

import 'model/barang.dart';
import 'model/transaksi.dart';

class BarangMasukPage extends StatefulWidget {
  final List<Barang> barangList;
  final List<Transaksi> transaksiList;
  final Function(Barang, int) onBarangMasuk;

  const BarangMasukPage({
    super.key,
    required this.barangList,
    required this.transaksiList,
    required this.onBarangMasuk,
  });

  @override
  State<BarangMasukPage> createState() => _BarangMasukPageState();
}

class _BarangMasukPageState extends State<BarangMasukPage> {
  Barang? selectedBarang;
  final TextEditingController jumlahController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barang Masuk')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            DropdownButton<Barang>(
              hint: const Text('Pilih Barang'),
              value: selectedBarang,
              isExpanded: true,
              items: widget.barangList.map((b) {
                return DropdownMenuItem(value: b, child: Text(b.nama));
              }).toList(),
              onChanged: (b) => setState(() => selectedBarang = b),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: jumlahController,
              decoration: const InputDecoration(
                labelText: 'Jumlah Masuk',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedBarang != null &&
                    jumlahController.text.isNotEmpty) {
                  int jumlah = int.tryParse(jumlahController.text) ?? 0;
                  if (jumlah > 0) {
                    widget.onBarangMasuk(selectedBarang!, jumlah);
                    Navigator.pop(context);
                  }
                }
              },
              child: const Text('Tambah Barang Masuk'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'model/barang.dart';
import 'model/transaksi.dart';

class BarangKeluarPage extends StatefulWidget {
  final List<Barang> barangList;
  final List<Transaksi> transaksiList;
  final Function(Barang, int) onBarangKeluar;

  const BarangKeluarPage({
    super.key,
    required this.barangList,
    required this.transaksiList,
    required this.onBarangKeluar,
  });

  @override
  State<BarangKeluarPage> createState() => _BarangKeluarPageState();
}

class _BarangKeluarPageState extends State<BarangKeluarPage> {
  Barang? selectedBarang;
  final TextEditingController jumlahController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Barang Keluar')),
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
                labelText: 'Jumlah Keluar',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (selectedBarang == null) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Pilih Barang'),
                      content: const Text(
                        'Silakan pilih barang terlebih dahulu.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                if (jumlahController.text.isEmpty) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Jumlah kosong'),
                      content: const Text(
                        'Masukkan jumlah barang yang akan keluar.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                int jumlah = int.tryParse(jumlahController.text) ?? -1;
                if (jumlah <= 0) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Jumlah tidak valid'),
                      content: const Text(
                        'Masukkan angka jumlah yang benar (lebih dari 0).',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                if (selectedBarang!.stok < jumlah) {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Stok tidak cukup'),
                      content: Text(
                        'Stok untuk ${selectedBarang!.nama} hanya ${selectedBarang!.stok}. Anda mencoba mengeluarkan $jumlah.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Tutup'),
                        ),
                      ],
                    ),
                  );
                  return;
                }

                // Valid — lakukan pengurangan
                widget.onBarangKeluar(selectedBarang!, jumlah);
                Navigator.pop(context);
              },
              child: const Text('Kurangi Barang Keluar'),
            ),
          ],
        ),
      ),
    );
  }
}

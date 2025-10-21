import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'model/supplier.dart';
import 'model/transaksi.dart';

class TransaksiPage extends StatelessWidget {
  final List<Transaksi> transaksiList;
  final List<Supplier> supplierList;

  const TransaksiPage({
    super.key,
    required this.transaksiList,
    this.supplierList = const [],
  });

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd MMM yyyy HH:mm');
    return Scaffold(
      appBar: AppBar(title: const Text('Data Transaksi')),
      body: ListView.builder(
        itemCount: transaksiList.length,
        itemBuilder: (context, index) {
          final transaksi = transaksiList[index];
          final supplierName = transaksi.supplierId == null
              ? '-'
              : (supplierList
                    .firstWhere(
                      (s) => s.id == transaksi.supplierId,
                      orElse: () => Supplier(
                        id: transaksi.supplierId!,
                        nama: '-',
                        kontak: '-',
                      ),
                    )
                    .nama);

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: transaksi.jenis == 'masuk'
                    ? Colors.green.shade100
                    : Colors.red.shade100,
                child: Icon(
                  transaksi.jenis == 'masuk' ? Icons.add_box : Icons.outbox,
                  color: transaksi.jenis == 'masuk'
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
              title: Text(
                transaksi.jenis == 'masuk' ? 'Barang Masuk' : 'Barang Keluar',
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ID Transaksi: ${transaksi.id}'),
                  Text('ID Barang: ${transaksi.barangId}'),
                  Text('Jumlah: ${transaksi.jumlah}'),
                  Text(
                    'Tanggal: ${dateFormat.format(transaksi.tanggal.toLocal())}',
                  ),
                  Text('Supplier: $supplierName'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

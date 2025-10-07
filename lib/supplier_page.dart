import 'package:flutter/material.dart';

import 'model/supplier.dart';

class SupplierPage extends StatelessWidget {
  final List<Supplier> supplierList;

  const SupplierPage({super.key, required this.supplierList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Supplier')),
      body: ListView.builder(
        itemCount: supplierList.length,
        itemBuilder: (context, index) {
          final supplier = supplierList[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade100,
                child: Icon(Icons.people, color: Colors.orange.shade700),
              ),
              title: Text(supplier.nama),
              subtitle: Text('Kontak: ${supplier.kontak}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(supplier.nama),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${supplier.id}'),
                        Text('Nama: ${supplier.nama}'),
                        Text('Kontak: ${supplier.kontak}'),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Tutup'),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

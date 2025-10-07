import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';

import 'model/barang.dart';

class BarangPage extends StatefulWidget {
  final List<Barang> barangList;

  const BarangPage({super.key, required this.barangList});

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  List<Barang> get barangList => widget.barangList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Barang')),
      body: ListView.builder(
        itemCount: barangList.length,
        itemBuilder: (context, index) {
          final barang = barangList[index];
          return Slidable(
            key: ValueKey(barang.id),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              children: [
                SlidableAction(
                  onPressed: (context) async {
                    // Pick new image
                    final picker = ImagePicker();
                    final XFile? file = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (file != null) {
                      setState(() {
                        barang.image = file.path; // store local path
                      });
                    }
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.image,
                  label: 'Ganti Gambar',
                ),
                SlidableAction(
                  onPressed: (context) async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Hapus Barang'),
                        content: Text('Hapus ${barang.nama}?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      setState(() {
                        barangList.removeAt(index);
                      });
                    }
                  },
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Hapus',
                ),
              ],
            ),
            child: Card(
              margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  backgroundImage: barang.image != null
                      ? (barang.image!.startsWith('http')
                            ? CachedNetworkImageProvider(barang.image!)
                                  as ImageProvider
                            : FileImage(File(barang.image!)))
                      : null,
                  child: barang.image == null
                      ? Icon(Icons.inventory, color: Colors.blue.shade700)
                      : null,
                ),
                title: Text(barang.nama),
                subtitle: Text(
                  'Stok: ${barang.stok} | Harga: Rp${barang.harga}',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text(barang.nama),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (barang.image != null) ...[
                            Center(
                              child: Image(
                                image: barang.image!.startsWith('http')
                                    ? CachedNetworkImageProvider(barang.image!)
                                    : FileImage(File(barang.image!))
                                          as ImageProvider,
                                width: 120,
                                height: 120,
                              ),
                            ),
                            const SizedBox(height: 12),
                          ],
                          Text('ID: ${barang.id}'),
                          Text('Stok: ${barang.stok}'),
                          Text('Harga: Rp${barang.harga}'),
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
            ),
          );
        },
      ),
    );
  }
}

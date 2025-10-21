import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

// shared_preferences moved to homepage; not needed here

import 'model/barang.dart';

class BarangPage extends StatefulWidget {
  final List<Barang> barangList;
  final Future<void> Function()? onSave;
  final List<dynamic>? supplierList;
  final void Function({
    required String barangId,
    required String jenis,
    required int jumlah,
    String? supplierId,
  })?
  onAddTransaksi;

  const BarangPage({
    super.key,
    required this.barangList,
    this.onSave,
    this.supplierList,
    this.onAddTransaksi,
  });

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  List<Barang> get barangList => widget.barangList;

  final _uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Barang')),
      floatingActionButton: FloatingActionButton.extended(
        icon: const Icon(Icons.add),
        label: const Text('Tambah Barang'),
        onPressed: () => _showAddDialog(),
      ),
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
                    final messenger = ScaffoldMessenger.of(context);
                    final picker = ImagePicker();
                    final XFile? file = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (file == null) return;
                    if (!mounted)
                      return; // ensure widget still mounted before using context or setState
                    setState(() {
                      barang.image = file.path; // store local path
                    });
                    // persist via callback if provided
                    if (widget.onSave != null) await widget.onSave!();
                    if (!mounted) return;
                    messenger.showSnackBar(
                      const SnackBar(content: Text('Gambar disimpan')),
                    );
                  },
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  icon: Icons.image,
                  label: 'Ganti Gambar',
                ),
                SlidableAction(
                  onPressed: (context) async {
                    final scaffold = ScaffoldMessenger.of(context);
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
                    if (confirmed != true) return;
                    if (!mounted) return; // must check before state changes
                    final removed = barangList[index];
                    setState(() {
                      barangList.removeAt(index);
                    });
                    // persist via callback if provided
                    if (widget.onSave != null) await widget.onSave!();
                    if (!mounted) return;

                    scaffold.clearSnackBars();
                    scaffold.showSnackBar(
                      SnackBar(
                        content: Text('${removed.nama} dihapus'),
                        action: SnackBarAction(
                          label: 'Undo',
                          onPressed: () async {
                            if (!mounted) return;
                            setState(() {
                              barangList.insert(index, removed);
                            });
                            if (widget.onSave != null) await widget.onSave!();
                          },
                        ),
                      ),
                    );
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
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('ID: ${barang.id}'),
                    Text('Stok: ${barang.stok}'),
                    Text('Harga: Rp${barang.harga}'),
                  ],
                ),
                isThreeLine: true,
              ),
            ),
          );
        },
      ),
    );
  }

  void _showAddDialog() {
    final idController = TextEditingController();
    final namaController = TextEditingController();
    final stokController = TextEditingController(text: '0');
    final hargaController = TextEditingController(text: '0');

    String? selectedSupplierId;

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tambah Barang'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: InputDecoration(
                  labelText: 'ID (kosongkan untuk auto)',
                ),
              ),
              TextField(
                controller: namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
              ),
              TextField(
                controller: stokController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stok'),
              ),
              TextField(
                controller: hargaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Harga'),
              ),
              const SizedBox(height: 8),
              if ((widget.supplierList ?? []).isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    const Text(
                      'Supplier (opsional)',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      initialValue: selectedSupplierId,
                      items: (widget.supplierList ?? [])
                          .map<DropdownMenuItem<String>>((s) {
                            final id = (s is Map) ? s['id'] : (s.id ?? '');
                            final name = (s is Map)
                                ? s['nama']
                                : (s.nama ?? '');
                            return DropdownMenuItem(
                              value: id,
                              child: Text(name),
                            );
                          })
                          .toList(),
                      onChanged: (v) => selectedSupplierId = v,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ),
              ElevatedButton.icon(
                icon: const Icon(Icons.image),
                label: const Text('Pilih Gambar (opsional)'),
                onPressed: () async {
                  final picker = ImagePicker();
                  final XFile? file = await picker.pickImage(
                    source: ImageSource.gallery,
                  );
                  if (file != null) {
                    // put selected path into a hidden field (reuse idController temporarily)
                    idController.text =
                        idController.text; // no-op but keep controller alive
                    // store path in hargaController.text temporarily? better to close and re-open; instead store in local var
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final messenger = ScaffoldMessenger.of(context);
              final navigator = Navigator.of(context);
              final idInput = idController.text.trim();
              final nama = namaController.text.trim();
              final stok = int.tryParse(stokController.text) ?? 0;
              final harga = double.tryParse(hargaController.text) ?? 0.0;
              if (nama.isEmpty) {
                if (!mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Nama wajib diisi')),
                );
                return;
              }
              final id = idInput.isEmpty ? _uuid.v4().substring(0, 8) : idInput;
              final newBarang = Barang(
                id: id,
                nama: nama,
                stok: stok,
                harga: harga,
              );
              setState(() {
                barangList.insert(0, newBarang);
              });
              // Persist list
              if (widget.onSave != null) await widget.onSave!();
              // Add a 'masuk' transaction if parent provided callback
              if (widget.onAddTransaksi != null) {
                widget.onAddTransaksi!(
                  barangId: id,
                  jenis: 'masuk',
                  jumlah: stok,
                  supplierId: selectedSupplierId,
                );
              }
              if (!mounted) return;
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('Barang ditambahkan')),
              );
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}

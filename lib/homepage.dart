import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_application_2/barangkeluar.dart';
import 'package:flutter_application_2/barangmasuk.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';

import 'barangpage.dart';
import 'login.dart';
import 'model/barang.dart';
import 'model/supplier.dart';
import 'model/transaksi.dart';
import 'model/user.dart';
import 'supplier_page.dart' as supplier_page;

class MyHomePage extends StatefulWidget {
  final String title;
  final String username;
  final String email;

  const MyHomePage({
    super.key,
    required this.title,
    required this.username,
    required this.email,
  });

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Barang> barangList = [
    Barang(
      id: 'B001',
      nama: 'Beras',
      stok: 100,
      harga: 12000,
      image: 'assets/1211.png',
    ),
    Barang(
      id: 'B002',
      nama: 'Gula',
      stok: 50,
      harga: 14000,
      image: 'assets/1213.png',
    ),
    Barang(id: 'B003', nama: 'Minyak Goreng', stok: 80, harga: 15000),
    Barang(id: 'B004', nama: 'Tepung Terigu', stok: 60, harga: 9000),
    Barang(id: 'B005', nama: 'Garam', stok: 40, harga: 5000),
    Barang(id: 'B006', nama: 'Susu Bubuk', stok: 30, harga: 25000),
    Barang(id: 'B007', nama: 'Kopi', stok: 25, harga: 20000),
    Barang(id: 'B008', nama: 'Mie Instan', stok: 120, harga: 3500),
    Barang(id: 'B009', nama: 'Kecap', stok: 35, harga: 8000),
    Barang(id: 'B010', nama: 'Saus Tomat', stok: 20, harga: 7000),
  ];
  List<Transaksi> transaksiList = [];
  List<User> userList = [];
  List<Supplier> supplierList = [];

  void _tambahBarangMasuk(Barang barang, int jumlah) {
    setState(() {
      barang.stok += jumlah;
      transaksiList.add(
        Transaksi(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          barangId: barang.id,
          jenis: 'masuk',
          jumlah: jumlah,
          tanggal: DateTime.now(),
        ),
      );
    });
  }

  void _kurangiBarangKeluar(Barang barang, int jumlah) {
    setState(() {
      barang.stok -= jumlah;
      transaksiList.add(
        Transaksi(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          barangId: barang.id,
          jenis: 'keluar',
          jumlah: jumlah,
          tanggal: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.store, color: Colors.blue.shade700),
            ),
            const SizedBox(width: 10),
            Text(
              widget.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: CircleAvatar(
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.person, color: Colors.blue.shade700),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient + blur
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFB2EBF2),
                  Color(0xFF80DEEA),
                  Color(0xFF4DD0E1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Container(color: Colors.transparent),
            ),
          ),
          // Konten utama
          LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 900
                  ? 4
                  : constraints.maxWidth > 600
                  ? 3
                  : 2;

              final double topPadding =
                  MediaQuery.of(context).padding.top + kToolbarHeight + 20;

              return SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: topPadding,
                  left: 16,
                  right: 16,
                  bottom: 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Container(
                      padding: const EdgeInsets.all(18),
                      margin: const EdgeInsets.only(bottom: 18),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue.shade100.withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.blue.shade100,
                            child: Icon(
                              Icons.person,
                              color: Colors.blue.shade700,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 18),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Selamat datang, ${widget.username} 👋",
                                style: GoogleFonts.poppins(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              Text(
                                widget.email,
                                style: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    // Menu Gudang
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AnimationLimiter(
                        child: GridView.count(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.1,
                          children: [
                            AnimationConfiguration.staggeredList(
                              position: 0,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildFeatureCard(
                                    Icons.add_box,
                                    'Barang Masuk',
                                    Colors.green,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BarangMasukPage(
                                            barangList: barangList,
                                            transaksiList: transaksiList,
                                            onBarangMasuk: _tambahBarangMasuk,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            AnimationConfiguration.staggeredList(
                              position: 1,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildFeatureCard(
                                    Icons.outbox,
                                    'Barang Keluar',
                                    Colors.red,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BarangKeluarPage(
                                                barangList: barangList,
                                                transaksiList: transaksiList,
                                                onBarangKeluar:
                                                    _kurangiBarangKeluar,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            AnimationConfiguration.staggeredList(
                              position: 2,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildFeatureCard(
                                    Icons.inventory_2,
                                    'Data Barang',
                                    Colors.blue,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => BarangPage(
                                            barangList: barangList,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            AnimationConfiguration.staggeredList(
                              position: 3,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildFeatureCard(
                                    Icons.people,
                                    'Supplier',
                                    Colors.orange,
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              supplier_page.SupplierPage(
                                                supplierList: supplierList,
                                              ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            AnimationConfiguration.staggeredList(
                              position: 4,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildFeatureCard(
                                    Icons.bar_chart,
                                    'Laporan',
                                    Colors.purple,
                                  ),
                                ),
                              ),
                            ),
                            AnimationConfiguration.staggeredList(
                              position: 5,
                              duration: const Duration(milliseconds: 500),
                              child: SlideAnimation(
                                horizontalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: _buildFeatureCard(
                                    Icons.logout,
                                    'Logout',
                                    Colors.grey,
                                    onTap: () {
                                      Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const LoginPage(),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // Aktivitas Terbaru
                    Text(
                      "Aktivitas Terbaru",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: transaksiList.length,
                      itemBuilder: (context, index) {
                        final transaksi = transaksiList[index];
                        return Card(
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: transaksi.jenis == 'masuk'
                                  ? Colors.green.shade100
                                  : Colors.red.shade100,
                              child: Icon(
                                transaksi.jenis == 'masuk'
                                    ? Icons.add_box
                                    : Icons.outbox,
                                color: transaksi.jenis == 'masuk'
                                    ? Colors.green.shade700
                                    : Colors.red.shade700,
                              ),
                            ),
                            title: Text(
                              '${transaksi.jenis == 'masuk' ? 'Barang Masuk' : 'Barang Keluar'}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              'ID Barang: ${transaksi.barangId}\nJumlah: ${transaksi.jumlah}\nTanggal: ${transaksi.tanggal.toLocal()}',
                            ),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text(
                                    transaksi.jenis == 'masuk'
                                        ? 'Detail Barang Masuk'
                                        : 'Detail Barang Keluar',
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('ID Transaksi: ${transaksi.id}'),
                                      Text('ID Barang: ${transaksi.barangId}'),
                                      Text('Jumlah: ${transaksi.jumlah}'),
                                      Text(
                                        'Tanggal: ${transaksi.tanggal.toLocal()}',
                                      ),
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
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(
    IconData icon,
    String label,
    Color color, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.7), color],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.25),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 40),
              const SizedBox(height: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Barang class is now imported from model/barang.dart

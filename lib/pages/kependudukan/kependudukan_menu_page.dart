import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ==================== DEFINISI WARNA ====================
// UBAH DI SINI: Palet warna soft & elegant untuk tampilan yang tidak mencolok
const Color primaryBlue = Color(0xFF1E88E5);     // UBAH DI SINI: Biru soft untuk warga dan tema utama
const Color softGreen = Color(0xFF43A047);       // UBAH DI SINI: Hijau soft untuk keluarga dan statistik positif
const Color softOrange = Color(0xFFFF7043);      // UBAH DI SINI: Orange soft untuk rumah dan aksen hangat
const Color darkBlue = Color(0xFF1565C0);        // UBAH DI SINI: Biru gelap untuk gradient dan depth
const Color lightBlue = Color(0xFFE3F2FD);       // UBAH DI SINI: Biru sangat muda untuk background card
const Color backgroundWhite = Color(0xFFFFFFFF); // UBAH DI SINI: Putih untuk card dan background utama
const Color backgroundGray = Color(0xFFF8F9FA);  // UBAH DI SINI: Abu-abu lembut untuk background halaman
const Color textPrimary = Color(0xFF212121);     // UBAH DI SINI: Hitam untuk teks utama dan judul
const Color textSecondary = Color(0xFF757575);   // UBAH DI SINI: Abu-abu untuk teks sekunder dan deskripsi
const Color textTertiary = Color(0xFF9E9E9E);    // UBAH DI SINI: Abu-abu muda untuk teks tersier dan info
const Color dividerGray = Color(0xFFE0E0E0);     // UBAH DI SINI: Abu-abu untuk border dan garis pemisah

class KependudukanMenuPage extends StatelessWidget {
  const KependudukanMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    // ==================== STRUKTUR UTAMA HALAMAN ====================
    // UBAH DI SINI: Layout utama halaman dengan scroll dan padding
    return Container(
      color: backgroundGray, // Background halaman abu-abu lembut
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24), // UBAH DI SINI: Padding luar halaman
        child: Column(
          children: [
            _buildWelcomeCard(),     // UBAH DI SINI: Card selamat datang dengan gradient biru
            const SizedBox(height: 24), // UBAH DI SINI: Jarak antar section
            _buildQuickStats(),      // UBAH DI SINI: Statistik cepat dengan 3 card
            const SizedBox(height: 24),
            _buildMenuGrid(context), // UBAH DI SINI: Menu utama dengan 3 opsi navigasi
            const SizedBox(height: 24),
            _buildRecentData(),      // UBAH DI SINI: Data aktivitas terbaru
          ],
        ),
      ),
    );
  }

  // ==================== WELCOME CARD ====================
  // UBAH DI SINI: Card selamat datang dengan background gradient biru
  Widget _buildWelcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32), // UBAH DI SINI: Padding dalam card
      decoration: BoxDecoration(
        // UBAH DI SINI: Gradient background dari biru ke biru gelap
        gradient: const LinearGradient(
          colors: [primaryBlue, darkBlue],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24), // UBAH DI SINI: Sudut melengkung card
        boxShadow: [
          // UBAH DI SINI: Shadow untuk efek kedalaman
          BoxShadow(
            color: primaryBlue.withOpacity(0.3),
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // UBAH DI SINI: Icon kependudukan dengan background transparan
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15), // Background semi-transparan
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.25),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.groups_2_rounded, // Icon grup orang untuk kependudukan
                  color: Colors.white,
                  size: 32,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // UBAH DI SINI: Judul utama halaman
                    const Text(
                      'Kependudukan RW',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                        letterSpacing: -0.8,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // UBAH DI SINI: Subtitle/badge dashboard
                    Text(
                      'Dashboard Manajemen',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.8),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          // UBAH DI SINI: Deskripsi panjang tentang fungsi halaman
          Text(
            'Kelola data warga, keluarga, dan rumah secara terintegrasi dengan sistem yang modern dan efisien',
            style: TextStyle(
              fontSize: 15,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w400,
              height: 1.5,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== QUICK STATS ====================
  // UBAH DI SINI: Section statistik cepat dengan 3 card (warga, keluarga, rumah)
  Widget _buildQuickStats() {
    return Row(
      children: [
        // UBAH DI SINI: Card statistik warga (biru)
        Expanded(child: _buildStatCard('Warga', '1,250', Icons.person_rounded, primaryBlue)),
        const SizedBox(width: 16), // UBAH DI SINI: Jarak antar card
        // UBAH DI SINI: Card statistik keluarga (hijau)
        Expanded(child: _buildStatCard('Keluarga', '312', Icons.family_restroom_rounded, softGreen)),
        const SizedBox(width: 16),
        // UBAH DI SINI: Card statistik rumah (orange)
        Expanded(child: _buildStatCard('Rumah', '298', Icons.home_rounded, softOrange)),
      ],
    );
  }

  // UBAH DI SINI: Widget untuk membuat card statistik individual
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 18), // UBAH DI SINI: Padding card
      decoration: BoxDecoration(
        color: backgroundWhite, // UBAH DI SINI: Background putih
        borderRadius: BorderRadius.circular(20), // UBAH DI SINI: Sudut melengkung
        border: Border.all(
          color: dividerGray.withOpacity(0.2), // UBAH DI SINI: Border abu-abu tipis
          width: 1,
        ),
        boxShadow: [
          // UBAH DI SINI: Shadow untuk kedalaman
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: color.withOpacity(0.1), // Shadow berwarna sesuai tema
            spreadRadius: 0,
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          // UBAH DI SINI: Container icon dengan gradient background
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withOpacity(0.2),
                  color.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: color.withOpacity(0.25),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(height: 14),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: color,
              letterSpacing: -0.8,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: textSecondary,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== MENU GRID ====================
  // UBAH DI SINI: Section menu utama dengan 3 opsi navigasi
  Widget _buildMenuGrid(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            // UBAH DI SINI: Garis accent vertikal untuk header
            Container(
              width: 5,
              height: 28,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [primaryBlue, darkBlue],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(3),
              ),
            ),
            const SizedBox(width: 14),
            // UBAH DI SINI: Judul section menu
            const Text(
              'Menu Kependudukan',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
                color: textPrimary,
                letterSpacing: -0.8,
                height: 1.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        // UBAH DI SINI: Layout 3 menu dalam 1 column dengan spacing yang natural
        Column(
          children: [
            // UBAH DI SINI: Menu data warga (biru)
            _buildMenuCard(
              context,
              'Data Warga',
              'Kelola dan pantau data seluruh warga RW',
              Icons.person_rounded,
              primaryBlue,
              'kependudukan-warga',
            ),
            const SizedBox(height: 14), // UBAH DI SINI: Jarak antar menu card
            // UBAH DI SINI: Menu data keluarga (hijau)
            _buildMenuCard(
              context,
              'Data Keluarga',
              'Manajemen informasi unit keluarga',
              Icons.family_restroom_rounded,
              softGreen,
              'kependudukan-keluarga',
            ),
            const SizedBox(height: 14),
            // UBAH DI SINI: Menu data rumah (orange)
            _buildMenuCard(
              context,
              'Data Rumah',
              'Kelola data properti dan hunian',
              Icons.home_rounded,
              softOrange,
              'kependudukan-rumah',
            ),
          ],
        ),
      ],
    );
  }

  // ==================== MENU CARD ====================
  // UBAH DI SINI: Widget untuk membuat card menu individual yang bisa diklik
  Widget _buildMenuCard(
    BuildContext context,
    String title,      // UBAH DI SINI: Judul menu (Data Warga, dll)
    String subtitle,   // UBAH DI SINI: Deskripsi menu
    IconData icon,     // UBAH DI SINI: Icon menu
    Color color,       // UBAH DI SINI: Warna tema menu
    String routeName,  // UBAH DI SINI: Nama route untuk navigasi
  ) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => context.pushNamed(routeName), // UBAH DI SINI: Navigasi ke halaman tujuan
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity, // UBAH DI SINI: Lebar penuh untuk horizontal layout
          padding: const EdgeInsets.all(20), // UBAH DI SINI: Padding dalam card
          decoration: BoxDecoration(
            color: backgroundWhite, // UBAH DI SINI: Background putih
            borderRadius: BorderRadius.circular(20), // UBAH DI SINI: Sudut melengkung
            border: Border.all(
              color: dividerGray.withOpacity(0.2), // UBAH DI SINI: Border tipis
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                spreadRadius: 0,
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
              BoxShadow(
                color: color.withOpacity(0.08),
                spreadRadius: 0,
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              // Icon di sebelah kiri
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withOpacity(0.2),
                      color.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: color.withOpacity(0.25),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: color.withOpacity(0.15),
                      spreadRadius: 0,
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: 18),
              // Teks di sebelah kanan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: textPrimary,
                        letterSpacing: -0.4,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: textSecondary,
                        fontWeight: FontWeight.w500,
                        height: 1.4,
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              // Arrow icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 16,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ==================== RECENT DATA ====================
  // UBAH DI SINI: Section aktivitas terbaru dengan 4 item data
  Widget _buildRecentData() {
    return Container(
      padding: const EdgeInsets.all(28), // UBAH DI SINI: Padding besar untuk section
      decoration: BoxDecoration(
        color: backgroundWhite, // UBAH DI SINI: Background putih
        borderRadius: BorderRadius.circular(24), // UBAH DI SINI: Sudut melengkung
        border: Border.all(
          color: dividerGray.withOpacity(0.2), // UBAH DI SINI: Border tipis
          width: 1,
        ),
        boxShadow: [
          // UBAH DI SINI: Double shadow untuk efek premium
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            spreadRadius: 0,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 40,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // UBAH DI SINI: Garis accent vertikal untuk header
              Container(
                width: 5,
                height: 28,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [primaryBlue, darkBlue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 14),
              // UBAH DI SINI: Judul section aktivitas
              const Expanded(
                child: Text(
                  'Aktivitas Terbaru',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: textPrimary,
                    letterSpacing: -0.8,
                    height: 1.2,
                  ),
                ),
              ),
              // UBAH DI SINI: Badge counter jumlah item
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: lightBlue.withOpacity(0.3), // Background biru muda
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: primaryBlue.withOpacity(0.2),
                    width: 1,
                  ),
                ),
                child: Text(
                  '4 Item',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: primaryBlue,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildRecentItem(
            'Ahmad Budiman',
            'Pendaftaran warga baru',
            '10 Jan 2025 • 14:30',
            Icons.person_add_alt_1_rounded,
            primaryBlue,
            'Warga Baru',
          ),
          _buildRecentItem(
            'Keluarga Santoso',
            'Registrasi unit keluarga',
            '9 Jan 2025 • 09:15',
            Icons.group_add_rounded,
            softGreen,
            'Keluarga Baru',
          ),
          _buildRecentItem(
            'Jl. Merdeka No. 15',
            'Pendataan properti baru',
            '8 Jan 2025 • 16:45',
            Icons.home_work_rounded,
            softOrange,
            'Rumah Baru',
          ),
          _buildRecentItem(
            'Siti Aminah',
            'Pembaruan data penduduk',
            '7 Jan 2025 • 11:20',
            Icons.edit_note_rounded,
            textSecondary,
            'Update Data',
          ),
        ],
      ),
    );
  }

  // UBAH DI SINI: Widget untuk membuat item aktivitas individual
  Widget _buildRecentItem(String title, String description, String datetime, IconData icon, Color color, String category) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16), // UBAH DI SINI: Jarak antar item
      padding: const EdgeInsets.all(18), // UBAH DI SINI: Padding dalam card
      decoration: BoxDecoration(
        color: backgroundGray, // UBAH DI SINI: Background abu-abu lembut
        borderRadius: BorderRadius.circular(18), // UBAH DI SINI: Sudut melengkung
        border: Border.all(
          color: dividerGray.withOpacity(0.15), // UBAH DI SINI: Border tipis
          width: 1,
        ),
        boxShadow: [
          // UBAH DI SINI: Shadow halus untuk depth
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // UBAH DI SINI: Icon dengan design yang lebih refined
          Container(
            padding: const EdgeInsets.all(12), // UBAH DI SINI: Padding icon
            decoration: BoxDecoration(
              color: backgroundWhite, // UBAH DI SINI: Background putih untuk icon
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: color.withOpacity(0.2), // UBAH DI SINI: Border sesuai warna tema
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.15),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: color, size: 22), // UBAH DI SINI: Icon aktivitas
          ),
          const SizedBox(width: 16), // UBAH DI SINI: Jarak icon ke konten
          // UBAH DI SINI: Content area dengan informasi lengkap
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // UBAH DI SINI: Category badge dengan warna sesuai tema
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1), // Background transparan sesuai warna
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: color.withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    category, // UBAH DI SINI: Text kategori (Warga Baru, dll)
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: color,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                // UBAH DI SINI: Title/nama aktivitas
                Text(
                  title, // UBAH DI SINI: Judul aktivitas (Ahmad Budiman, dll)
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: textPrimary,
                    letterSpacing: -0.3,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                // UBAH DI SINI: Description/deskripsi aktivitas
                Text(
                  description, // UBAH DI SINI: Deskripsi aktivitas (Pendaftaran warga baru, dll)
                  style: const TextStyle(
                    fontSize: 14,
                    color: textSecondary,
                    fontWeight: FontWeight.w500,
                    height: 1.4,
                    letterSpacing: 0.1,
                  ),
                ),
                const SizedBox(height: 8),
                // UBAH DI SINI: Datetime dengan icon jam
                Row(
                  children: [
                    Icon(
                      Icons.access_time_rounded, // UBAH DI SINI: Icon jam
                      size: 14,
                      color: textTertiary.withOpacity(0.8),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      datetime, // UBAH DI SINI: Tanggal dan waktu (10 Jan 2025 • 14:30)
                      style: TextStyle(
                        fontSize: 12,
                        color: textTertiary.withOpacity(0.9),
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

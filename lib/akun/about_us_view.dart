import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsView extends StatelessWidget {
  const AboutUsView({super.key});

  // Helper function untuk membuka email
  Future<void> _launchEmail(BuildContext context) async {
    final Uri emailUri = Uri.parse('mailto:support@gonesa.app');
    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Tidak dapat membuka aplikasi email')),
          );
        }
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA), // Warna background original
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 16),
                _buildHeaderCard(), // Header "GoNesa"
                const SizedBox(height: 24),
                _buildDescriptionCard(), // Deskripsi Aplikasi
                const SizedBox(height: 24),
                _buildTeamSection(), // Tim Developer (7 Orang)
                const SizedBox(height: 24),
                _buildDosenSection(), // Dosen Pembimbing
                const SizedBox(height: 24),
                _buildTechInfoSection(), // Teknologi & Info
                const SizedBox(height: 24),
                _buildContactSection(context), // Tombol Kontak
                const SizedBox(height: 32),
                _buildFooter(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- 1. APP BAR (DESIGN ASLI) ---
  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: const Color(0xFF00AA13),
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'Tentang GoNesa',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
        titlePadding: const EdgeInsets.only(left: 20, bottom: 16),
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF00AA13),
                Color(0xFF00C91D),
              ],
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: -30,
                right: -30,
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.1),
                  ),
                ),
              ),
              Positioned(
                bottom: -20,
                left: -20,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- 2. HEADER CARD (Design Asli, Konten Baru) ---
  Widget _buildHeaderCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.white, Colors.grey.shade50],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF00AA13), Color(0xFF00C91D)],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF00AA13).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            // Ganti icon ini dengan Image.asset('assets/logo.png') jika sudah siap
            child: const Icon(Icons.local_taxi, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'GoNesa',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2C3E50),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            'Arek Arek Lucu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // --- 3. DESKRIPSI (Design ProjectInfo Asli, Konten Baru) ---
  Widget _buildDescriptionCard() {
    return _buildCardContainer(
      title: 'Tentang Aplikasi',
      icon: Icons.info_outline,
      iconColor: Colors.blue,
      child: Text(
        'GoNesa adalah aplikasi super app berbasis Flutter yang dikembangkan sebagai proyek akhir mahasiswa Informatika UNESA Kampus 5 Magetan. Aplikasi ini mengintegrasikan berbagai layanan seperti transportasi, makanan, pengiriman, dan keuangan digital dalam satu platform.',
        style: TextStyle(
          fontSize: 14,
          color: Colors.grey[700],
          height: 1.6,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }

  // --- 4. TIM DEVELOPER (Design Asli, Data Baru) ---
  Widget _buildTeamSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _buildSectionIcon(Icons.group, const Color(0xFF00AA13)),
                const SizedBox(width: 12),
                const Text(
                  'Tim Developer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
              ],
            ),
          ),
          // List Anggota Tim (Warna-warni sesuai design asli)
          _buildTeamMember(name: 'Anton Dwi Atmoko', nim: '24111814141', color: Colors.blue),
          _buildTeamMember(name: 'Bintang Wira Akbar A.H.', nim: '24111814099', color: Colors.purple),
          _buildTeamMember(name: 'Bagus Chandra Priyatna', nim: '24111814129', color: Colors.green),
          _buildTeamMember(name: 'Annas Ridho Sadila', nim: '24111814114', color: Colors.orange),
          _buildTeamMember(name: 'Bagas Abhisyeka R.', nim: '24111814008', color: Colors.teal),
          _buildTeamMember(name: 'Dedi Firmansyah', nim: '24111814021', color: Colors.indigo),
          _buildTeamMember(name: 'Desta Berlianda Faathir', nim: '24111814095', color: Colors.pink),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  // --- 5. DOSEN PEMBIMBING (Reusable Style) ---
  Widget _buildDosenSection() {
    return _buildCardContainer(
      title: 'Dosen Pembimbing',
      icon: Icons.school,
      iconColor: const Color(0xFF00AA13), // Hijau Gojek
      child: Column(
        children: [
          _buildSimpleRow(Icons.person, 'Saifudin Yahya, S.Kom., M.T.I.'),
          _buildSimpleRow(Icons.account_balance, 'Prodi S1 Informatika'),
          _buildSimpleRow(Icons.location_on, 'UNESA Kampus 5 Magetan'),
        ],
      ),
    );
  }

  // --- 6. TEKNOLOGI & INFO (Reusable Style) ---
  Widget _buildTechInfoSection() {
    return _buildCardContainer(
      title: 'Detail Teknis',
      icon: Icons.build,
      iconColor: Colors.orange,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Teknologi:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildTechChip('Flutter 3.x'),
              _buildTechChip('Firebase Auth'),
              _buildTechChip('Firestore'),
              _buildTechChip('TheMealDB API'),
              _buildTechChip('Localization'),
            ],
          ),
          const Divider(height: 24),
          const Text(
            'Info Versi:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2C3E50)),
          ),
          const SizedBox(height: 4),
          Text('Versi: 1.0.0+1', style: TextStyle(color: Colors.grey[700])),
          Text('Lisensi: MIT License', style: TextStyle(color: Colors.grey[700])),
        ],
      ),
    );
  }

  // --- 7. KONTAK BUTTON (Style Gradient) ---
  Widget _buildContactSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF00AA13), Color(0xFF00C91D)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00AA13).withOpacity(0.4),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => _launchEmail(context),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.email, color: Colors.white),
                  SizedBox(width: 8),
                  Text(
                    'Hubungi Kami',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // --- FOOTER ---
  Widget _buildFooter() {
    return Column(
      children: [
        Text(
          '© 2025 GoNesa Team',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
        const SizedBox(height: 4),
        Text(
          'Made with ❤ in Magetan',
          style: TextStyle(fontSize: 12, color: Colors.grey[600]),
        ),
      ],
    );
  }

  // =========================================================================
  // HELPER WIDGETS (Untuk Mempertahankan Consistency Design)
  // =========================================================================

  // Container Putih dengan Shadow (Basic Block)
  Widget _buildCardContainer({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _buildSectionIcon(icon, iconColor),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  // Icon Kecil dengan Background Gradient (Design Asli)
  Widget _buildSectionIcon(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.7), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    );
  }

  // Card Member Tim (Design Asli yang keren)
  Widget _buildTeamMember({
    required String name,
    required String nim,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [color.withOpacity(0.7), color],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(Icons.person, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 15, // Sedikit disesuaikan agar nama panjang muat
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'NIM: $nim',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Baris Info Sederhana (Untuk Dosen)
  Widget _buildSimpleRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(color: Colors.grey[800], fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  // Chip Teknologi (Supaya rapi)
  Widget _buildTechChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF00AA13).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF00AA13).withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Color(0xFF00AA13),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

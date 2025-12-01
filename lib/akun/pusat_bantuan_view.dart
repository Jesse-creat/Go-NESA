import 'package:flutter/material.dart';
import 'package:gojek/app_locale.dart';
import 'package:gojek/constans.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localization/flutter_localization.dart';

class PusatBantuanView extends StatelessWidget {
  const PusatBantuanView({super.key});

  Future<void> _launchWhatsApp(BuildContext context) async {
    const phoneNumber = '6282140518120';
    const message = 'Halo, saya butuh bantuan terkait aplikasi GoNesa.';
    final whatsappUrl = "https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}";
    final uri = Uri.parse(whatsappUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka WhatsApp.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _launchEmail(BuildContext context) async {
    const email = 'candracan404@gmail.com';
    const subject = 'Bantuan Aplikasi GoNesa';
    final emailUrl = 'mailto:$email?subject=${Uri.encodeComponent(subject)}';
    final uri = Uri.parse(emailUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Tidak dapat membuka aplikasi email.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocale.pusatBantuan.getString(context)),
        backgroundColor: GoNesaPalette.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),
            Text(
              'Butuh Bantuan?',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Pilih salah satu cara di bawah ini untuk menghubungi tim support kami.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 40),
            _buildContactMethod(
              context: context,
              icon: Icons.wechat_rounded,
              title: 'Chat via WhatsApp',
              subtitle: 'Respon cepat (rekomendasi)',
              color: const Color(0xFF25D366),
              onTap: () => _launchWhatsApp(context),
            ),
            const SizedBox(height: 20),
            _buildContactMethod(
              context: context,
              icon: Icons.email_rounded,
              title: 'Kirim Email',
              subtitle: 'Respon dalam 1x24 jam',
              color: const Color(0xFFEA4335),
              onTap: () => _launchEmail(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactMethod({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 4,
      shadowColor: color.withOpacity(0.3),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:gojek/constans.dart';

class InboxPage extends StatelessWidget {
  const InboxPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GojekPalette.green,
        title: const Text('Inbox', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(8.0),
        children: [
          _buildInboxItem(
            icon: Icons.local_offer,
            iconColor: GojekPalette.menuDeals,
            title: 'Promo Spesial Untukmu!',
            subtitle: 'Cashback 50% untuk GO-RIDE dan GO-CAR. Jangan sampai ketinggalan!',
            time: '10:30',
            isUnread: true,
          ),
          _buildInboxItem(
            icon: Icons.chat,
            iconColor: GojekPalette.menuRide,
            title: 'Driver GO-RIDE',
            subtitle: 'Saya sudah di depan ya, kak.',
            time: 'Kemarin',
            isUnread: true,
          ),
          _buildInboxItem(
            icon: Icons.security,
            iconColor: Colors.blue,
            title: 'Keamanan Akun',
            subtitle: 'Waspada penipuan! Jangan berikan kode OTP kepada siapa pun.',
            time: '15 Agu',
            isUnread: false,
          ),
          _buildInboxItem(
            icon: Icons.restaurant,
            iconColor: GojekPalette.menuFood,
            title: 'Pesanan GO-FOOD Selesai',
            subtitle: 'Pesananmu dari Geprek Bensu telah selesai. Beri penilaian?',
            time: '14 Agu',
            isUnread: false,
          ),
        ],
      ),
    );
  }

  Widget _buildInboxItem({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required String time,
    required bool isUnread,
  }) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.symmetric(vertical: 4.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: iconColor.withOpacity(0.1),
          child: Icon(icon, color: iconColor),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: isUnread ? FontWeight.bold : FontWeight.normal),
        ),
        subtitle: Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(time, style: const TextStyle(fontSize: 12, color: Colors.grey)),
            if (isUnread) ...[
              const SizedBox(height: 4),
              const CircleAvatar(
                radius: 5,
                backgroundColor: GojekPalette.green,
              ),
            ],
          ],
        ),
        onTap: () {},
      ),
    );
  }
}

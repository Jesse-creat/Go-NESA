import 'package:flutter/material.dart';
import 'package:gojek/pesanan/pesanan_view.dart';

class GojekAppBar extends AppBar {
  GojekAppBar({
    Key? key,
    VoidCallback? onProfileTap, // Made optional
    required VoidCallback onSearchTap,
  }) : super(
          key: key,
          elevation: 0,
          backgroundColor: Colors.white,
          flexibleSpace: _buildGojekAppBar(onProfileTap, onSearchTap),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1.0),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.grey.withOpacity(0.0),
                    Colors.grey.withOpacity(0.1),
                    Colors.grey.withOpacity(0.0),
                  ],
                ),
              ),
              height: 1.0,
            ),
          ),
        );

  static Widget _buildGojekAppBar(
    VoidCallback? onProfileTap,
    VoidCallback onSearchTap,
  ) {
    return Builder(
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              /// 🔍 Search Bar (kiri)
              Expanded(
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: onSearchTap,
                    borderRadius: BorderRadius.circular(24.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 8.0,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5F7FA),
                        borderRadius: BorderRadius.circular(24.0),
                        border: Border.all(
                          color: Colors.grey.withOpacity(0.2),
                          width: 1.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search_rounded,
                            size: 20.0,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 8.0),
                          Expanded(
                            child: Text(
                              "Cari layanan, makanan, tujuan",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 13.0,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 12.0),

              /// 🎯 Right Section - Actions
              Row(
                children: <Widget>[
                  // Rewards Point Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12.0,
                      vertical: 6.0,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFFD180).withOpacity(0.3),
                          const Color(0xFFFFB74D).withOpacity(0.3),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.0),
                      border: Border.all(
                        color: const Color(0xFFFFB74D).withOpacity(0.3),
                        width: 1.0,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                            color: Colors.orange[700],
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.stars_rounded,
                            color: Colors.white,
                            size: 14.0,
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        const Text(
                          "1.781",
                          style: TextStyle(
                            fontSize: 13.0,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFE65100),
                          ),
                        ),
                        const SizedBox(width: 4.0),
                        Text(
                          "poin",
                          style: TextStyle(
                            fontSize: 11.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[800],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12.0),

                  // Order History Button
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PesananView(),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(12.0),
                      child: Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(12.0),
                          border: Border.all(
                            color: Colors.grey.withOpacity(0.15),
                            width: 1.0,
                          ),
                        ),
                        child: Icon(
                          Icons.receipt_long_rounded,
                          color: Colors.grey[700],
                          size: 20.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

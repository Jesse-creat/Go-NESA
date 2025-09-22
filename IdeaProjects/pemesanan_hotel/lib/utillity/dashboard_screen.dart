import 'package:flutter/material.dart';
import 'package:pemesanan_hotel/data/hotel_data.dart';
import 'package:pemesanan_hotel/models/hotel_model.dart';
import 'package:pemesanan_hotel/utillity/hotel_detail_screen.dart';
import 'package:pemesanan_hotel/utillity/booking_list_screen.dart';
import 'package:intl/intl.dart';

class DashboardScreen extends StatefulWidget {
  final String username;

  const DashboardScreen({required this.username, super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<Hotel> _filteredHotels = [];
  final TextEditingController _searchController = TextEditingController();

  RangeValues _priceRange = const RangeValues(500000, 3000000);
  double _selectedRating = 0;

  @override
  void initState() {
    super.initState();
    _applyFilters();
    _searchController.addListener(_applyFilters);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _applyFilters() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHotels = hotelList.where((hotel) {
        final nameMatch = hotel.name.toLowerCase().contains(query);
        final priceMatch = hotel.pricePerNight >= _priceRange.start && hotel.pricePerNight <= _priceRange.end;
        final ratingMatch = hotel.rating >= _selectedRating;
        return nameMatch && priceMatch && ratingMatch;
      }).toList();
    });
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('Filter Hotel'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Rentang Harga', style: TextStyle(fontWeight: FontWeight.bold)),
                    RangeSlider(
                      values: _priceRange,
                      min: 500000,
                      max: 3000000,
                      divisions: 25,
                      labels: RangeLabels(
                        'Rp ${_priceRange.start.round()}',
                        'Rp ${_priceRange.end.round()}',
                      ),
                      onChanged: (values) => setDialogState(() => _priceRange = values),
                    ),
                    const SizedBox(height: 20),
                    const Text('Rating Minimum', style: TextStyle(fontWeight: FontWeight.bold)),
                    Wrap(
                      spacing: 8.0,
                      children: [4.0, 4.5, 4.8].map((rating) {
                        return ChoiceChip(
                          label: Text('$rating+'),
                          selected: _selectedRating == rating,
                          onSelected: (selected) => setDialogState(() => _selectedRating = selected ? rating : 0),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    setDialogState(() {
                      _priceRange = const RangeValues(500000, 3000000);
                      _selectedRating = 0;
                    });
                    _applyFilters();
                  },
                  child: const Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Terapkan'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Mengubah title AppBar untuk menampilkan username
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Pilih Hotel'),
            Text(
              'Selamat Datang: ${widget.username}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFF0C0C),
        foregroundColor: Colors.white,
        actions: [
          IconButton(icon: const Icon(Icons.filter_list), onPressed: _showFilterDialog, tooltip: 'Filter Hotel'),
          IconButton(icon: const Icon(Icons.history), onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const BookingListScreen())), tooltip: 'Riwayat Pesanan'),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Cari nama hotel...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          Expanded(
            child: _filteredHotels.isEmpty
                ? const Center(child: Text('Tidak ada hotel yang sesuai filter.', style: TextStyle(fontSize: 18, color: Colors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    itemCount: _filteredHotels.length,
                    itemBuilder: (context, index) {
                      final hotel = _filteredHotels[index];
                      final formatCurrency = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => HotelDetailScreen(hotel: hotel))),
                        child: Card(
                          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                          elevation: 5,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Hero(tag: hotel.imageUrl, child: Image.asset(hotel.imageUrl, height: 180, width: double.infinity, fit: BoxFit.cover)),
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(hotel.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 4),
                                    Row(children: [const Icon(Icons.location_on, size: 16, color: Colors.grey), const SizedBox(width: 4), Text(hotel.location, style: const TextStyle(color: Colors.grey))]),
                                    const SizedBox(height: 8),
                                    Text('${formatCurrency.format(hotel.pricePerNight)} / malam', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(
                                        0xFFFF0C0C))),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

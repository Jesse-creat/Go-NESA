class Voucher {
  final String title;
  final String description;
  final DateTime expiryDate;
  final String code;
  final String imageUrl;

  Voucher({
    required this.title,
    required this.description,
    required this.expiryDate,
    required this.code,
    required this.imageUrl,
  });
}
